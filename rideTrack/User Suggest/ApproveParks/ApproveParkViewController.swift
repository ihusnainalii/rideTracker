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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))) //hide keyboard when tapping the anywhere else

        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        Analytics.logEvent("new_park_deleted", parameters: nil)
        let dataModel = DataModel()
        dataModel.delegate = self
        
        let urlPath = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/deleteFromList.php?list=SuggestPark&key=idKey&tempID=\(selectedPark.tempID!)"
        dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
        self.performSegue(withIdentifier: "toSuggestParksList", sender: self)

    }
    @IBAction func approveParkPressed(_ sender: Any) {
        Analytics.logEvent("new_park_approved", parameters: nil)
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
    func itemsDownloaded(items: NSArray, returnPath: String) {}
}
