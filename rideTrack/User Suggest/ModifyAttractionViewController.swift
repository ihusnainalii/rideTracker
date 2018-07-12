//
//  ModifyAttractionViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 7/10/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class ModifyAttractionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, DataModelProtocol {
    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var suggestedManufacturer: UILabel!
    @IBOutlet weak var suggestedClose: UILabel!
    @IBOutlet weak var suggestedName: UILabel!
    @IBOutlet weak var suggestedType: UILabel!
    @IBOutlet weak var suggestedNotes: UILabel!
    @IBOutlet weak var suggestedOpen: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var rideTypeSwitch: UIPickerView!
    @IBOutlet weak var openField: UITextField!
    @IBOutlet weak var closeField: UITextField!
    @IBOutlet weak var manufacturerField: UITextField!
    @IBOutlet weak var extinctSwitch: UISwitch!
    @IBOutlet weak var scoreCardSwtich: UISwitch!
    
    @IBOutlet weak var scrollWidth: NSLayoutConstraint!
    let screenSize = UIScreen.main.bounds

    var rideType = 0
    var pickerData: [String] = [String]()
    var originalAttraction: AttractionsModel = AttractionsModel()
    var suggestedAttraction: ApproveSuggestAttracionModel = ApproveSuggestAttracionModel()
    
    override func viewDidLoad() {
        nameField.delegate = self
        manufacturerField.delegate = self
        super.viewDidLoad()
        suggestedName.text=suggestedAttraction.rideName
        let type = convertRideTypeID(rideTypeID: Int(suggestedAttraction.type)!)
        suggestedType.text = type
        suggestedOpen.text = String(suggestedAttraction.YearOpen)
        suggestedClose.text = String(suggestedAttraction.YearClose)
        suggestedNotes.text = suggestedAttraction.notes
        suggestedManufacturer.text = suggestedAttraction.manufacturer
        
        nameField.text=originalAttraction.name
        openField.text=String(originalAttraction.yearOpen)
        closeField.text=String(originalAttraction.yearClosed)
        manufacturerField.text=originalAttraction.manufacturer
        
        self.rideTypeSwitch.delegate = self
        self.rideTypeSwitch.dataSource = self
        
        pickerData = ["","Roller Coaster", "Water Ride","Childrens Ride", "Flat Ride", "Transportation Ride", "Dark Ride", "Explore", "Spectacular", "Show", "Film", "Parade", "Play Area", "Upcharge"]
        rideTypeSwitch.selectRow(Int(originalAttraction.rideType!), inComponent: 0, animated: true)
        if originalAttraction.active == 1{
            extinctSwitch.isOn = false
        }
        else {
            extinctSwitch.isOn = true
        }
        if originalAttraction.hasScoreCard == 1 {
            scoreCardSwtich.isOn = true
        }
        else {
            scoreCardSwtich.isOn = false
        }
        if screenSize.width == 320 {
            scrollWidth.constant = 320
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))) //hide keyboard when tapping the anywhere else
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row] as String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //rideType = pickerData[row]
        switch pickerData[row] {
        case "":
            rideType = -1
        case "Roller Coaster":
            rideType = 1
        case "Water Ride":
            rideType = 2
        case "Childrens Ride":
            rideType = 3
        case "Flat Ride":
            rideType = 4
        case "Transportation Ride":
            rideType = 5
        case "Dark Ride":
            rideType = 6
        case "Explore":
            rideType = 7
        case "Spectacular":
            rideType = 8
        case "Show":
            rideType = 9
        case "Film":
            rideType = 10
        case "Parade":
            rideType = 11
        case "Play Area":
            rideType = 12
        case "Upcharge":
            rideType = 13
        default:
            rideType = 0
        }
        print("Ride type is: ", rideType)
    }
    
    func convertRideTypeID(rideTypeID: Int) -> String {
        switch rideTypeID {
        case -1:
            return ""
        case 1:
            return "Roller Coaster"
        case 2:
            return "Water Ride"
        case 3:
            return "Childrens Ride"
        case 4:
            return "Flat Ride"
        case 5:
            return "Transport Ride"
        case 6:
            return "Dark Ride"
        case 7:
            return "Explore"
        case 8:
            return "Spectacular"
        case 9:
            return "Show"
        case 10:
            return "Film"
        case 11:
            return "Parade"
        case 12:
            return "Play Area"
        case 13:
            return "Upcharge"
        default:
            return ""
        }
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        let dataModel = DataModel()
        dataModel.delegate = self
        let urlPath = "http://www.beingpositioned.com/theparksman/deleteFromUserSuggest.php?number=\(suggestedAttraction.id!)"
        print (urlPath)
        dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
        self.performSegue(withIdentifier: "toApproveSuggestions", sender: self)
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        let tempName = nameField.text
        let rideName = (tempName?.replacingOccurrences(of: " ", with: "_"))!
        let parkID = originalAttraction.parkID!
        let yearOpen = openField.text!
        let yearClosed = closeField.text!
        
        var active = 1
        if extinctSwitch.isOn{
            active = 0
        }
        let manufacturer = manufacturerField.text!
        var scoreCard = 0
        if scoreCardSwtich.isOn {
            scoreCard = 1
        }
        if rideType == 0 {
            rideType = originalAttraction.rideType
        }
        let urlPath = "http://www.beingpositioned.com/theparksman/modifyAttraction.php?id=\(originalAttraction.rideID!)&name=\(rideName)&ParkID=\(parkID)&type=\(rideType)&yearOpen=\(yearOpen)&YearClosed=\(yearClosed)&active=\(active)&scoreCard=\(scoreCard)&manufacturer=\(manufacturer)" //uploads to main list
        print (urlPath)
        let dataModel = DataModel()
        dataModel.delegate = self
        let urlPath2 = "http://www.beingpositioned.com/theparksman/deleteFromUserSuggest.php?number=\(suggestedAttraction.id!)" //deletes from suggested list
        print(urlPath2)
        dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
        dataModel.downloadData(urlPath: urlPath2, dataBase: "upload", returnPath: "upload")
        self.performSegue(withIdentifier: "toApproveSuggestions", sender: self)
    }
    
   
    
    func textFieldDidBeginEditing(_ textView: UITextField) {
        print ("BELOW OPENING")
    }

    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        print ("End DONE")
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
