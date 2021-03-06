//
//  ApproveParkViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 10/12/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import Firebase

class ApproveParkViewController: UIViewController, UITextFieldDelegate, DataModelProtocol {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var latField: UITextField!
    @IBOutlet weak var longField: UITextField!
    @IBOutlet weak var openField: UITextField!
    @IBOutlet weak var closedField: UITextField!
    @IBOutlet weak var defunctSwitch: UISwitch!
    @IBOutlet weak var prevNameField: UITextField!
    @IBOutlet weak var seasonalSwitch: UISwitch!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var userNameText: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollWidth: NSLayoutConstraint!
    let screenSize = UIScreen.main.bounds

    var selectedPark: ApproveSuggParksModel = ApproveSuggParksModel()
    var lat = 0.0
    var long = 0.0
    var approvedParks: DatabaseReference!
    var checkIfMultipleAttractions: DatabaseReference!
    var notificationParkName = ""
    var listOfParks = [ParksModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        approvedParks = Database.database().reference(withPath:"approvedSuggestions/Parks") ///userName
        checkIfMultipleAttractions = Database.database().reference(withPath:"approvedSuggestions/Parks/\(selectedPark.userID!)/Name")
        let urlPath = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/parksdbservice.php"
        let dataModel = DataModel()
        dataModel.delegate = self
        
        dataModel.downloadData(urlPath: urlPath, dataBase: "parks", returnPath: "allParks")

        scrollWidth.constant = screenSize.width
        nameField.delegate = self
        typeField.delegate = self
        cityField.delegate = self
        countryField.delegate = self
        latField.delegate = self
        longField.delegate = self
        openField.delegate = self
        closedField.delegate = self
        prevNameField.delegate = self
        websiteField.delegate = self
    
        nameField.text = selectedPark.name
        typeField.text = selectedPark.type
        cityField.text = selectedPark.city
        countryField.text = selectedPark.country
        latField.text = String(selectedPark.latitude)
        longField.text = String(selectedPark.longitude)
        openField.text = String(selectedPark.open)
        closedField.text = String(selectedPark.closed)
        prevNameField.text = selectedPark.prevName
        websiteField.text = selectedPark.website
        userNameText.text = selectedPark.userName
        
        lat = selectedPark.latitude
        long = selectedPark.longitude
        
        if selectedPark.defunct == 0 {
            defunctSwitch.isOn = false }
        else {defunctSwitch.isOn = true}
        print("defunct is \(selectedPark.defunct)")
        if selectedPark.seasonal! == 0
        {seasonalSwitch.isOn = false}
        else {seasonalSwitch.isOn = true}
        print("seasonal is \(selectedPark.seasonal!)")

        notificationParkName = nameField.text!
        checkIfMultipleAttractions.observe(.value, with: { snapshot in
            if snapshot.exists(){
                let currValue = (snapshot.value as! String)
                if currValue.count > 35 && !currValue.contains(", and more") {
                    self.notificationParkName = "\(currValue), and more"
                    print("adding and more!")
                    
                }
                else if !(currValue.contains(", and more")){
                    print("appending")
                    self.notificationParkName = "\(self.notificationParkName), \(currValue)"
                }
                else {
                    self.notificationParkName = currValue
                    print("should get here!")
                }
            }
        })
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))) //hide keyboard when tapping the anywhere else

        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        let arrayOfParks = items as! [ParksModel]
        for i in 0..<arrayOfParks.count{
            listOfParks.append(arrayOfParks[i])
            
            if arrayOfParks[i].name!.caseInsensitiveCompare(selectedPark.name!) == ComparisonResult.orderedSame {
                let alert = UIAlertController(title: "Duplicate Park", message: "This park already exisits in the database! Are you sure you want a new park with the same name?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    print ("cancel")
                }))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                    print ("delete")
                    let dataModel = DataModel()
                    dataModel.delegate = self
                    let urlPath = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/deleteFromList.php?list=SuggestPark&key=idKey&tempID=\(self.selectedPark.tempID!)"
                    print (urlPath)
                    dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
                    self.performSegue(withIdentifier: "toSuggestParksList", sender: self)
                }))
                self.present(alert, animated: true, completion: nil)
                break

            }
        }
    }

    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        Analytics.logEvent("new_park_deleted", parameters: nil)
        let dataModel = DataModel()
        dataModel.delegate = self
        
        let urlPath = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/deleteFromList.php?list=SuggestPark&key=idKey&tempID=\(selectedPark.tempID!)"
        dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
        self.performSegue(withIdentifier: "toSuggestParksList", sender: self)

    }
    @IBAction func submitPark(_ sender: Any) {
        Analytics.logEvent("new_park_approved", parameters: nil)
        
        var token = ""
        var userID = ""
        if selectedPark.token! == "" {token = "none"; userID = "NONE"}
        else {token = selectedPark.token!; userID = selectedPark.userID!}
        
        let newSuggestedAttraction = ApprovedSuggestiobsList(userToken: token, expName: notificationParkName)
        let newApprovalRef = self.approvedParks.child(userID)
        newApprovalRef.setValue(newSuggestedAttraction.toAnyObject())
  
        let dataModel = DataModel()
        dataModel.delegate = self
        let name = nameField.text
        let type = typeField.text
        let city = cityField.text
        let country = countryField.text
        let lat = latField.text
        let long = longField.text
        let open = openField.text
        let closed = closedField.text
        let prevName = prevNameField.text
        let website = websiteField.text
        var defunct = 1
        var seasonal = 0
        if defunctSwitch.isOn {defunct = 0}
        if seasonalSwitch.isOn {seasonal = 1}
        
        let urlPath = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/uploadNewPark.php?name=\(name!)&type=\(type!)&city=\(city!)&count=\(country!)&lat=\(lat!)&long=\(long!)&open=\(open!)&closed=\(closed!)&defunct=\(defunct)&prevName=\(prevName!)&seasonal=\(seasonal)&website=\(website!)&userName=\(self.selectedPark.userName!)"
        
        dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
        print(urlPath)
 
        let urlPath2 = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/deleteFromList.php?list=SuggestPark&key=idKey&tempID=\(selectedPark.tempID!)" //delete from list
        
        dataModel.downloadData(urlPath: urlPath2, dataBase: "upload", returnPath: "upload")
        self.performSegue(withIdentifier: "toSuggestParksList", sender: self)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    @IBAction func unwindtoApproveParks(sender: UIStoryboardSegue) {
        let suggestVC = sender.source as! ApproveParkMapViewController
        lat = suggestVC.lat
        long = suggestVC.long
        if lat != 0.0 || long != 0.0{
            latField.text = String(lat)
            longField.text = String(long)
        }
        else {
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap"{
            print("here going")
            let mapVC = segue.destination as! ApproveParkMapViewController
            mapVC.lat = lat
            mapVC.long = long
        }
    }
    
}
