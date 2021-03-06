//
//  ModifyAttractionViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 7/10/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import Firebase

class ApproveModifyAttractionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, DataModelProtocol {
    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var suggestedManufacturer: UILabel!
    @IBOutlet weak var suggestedClose: UILabel!
    @IBOutlet weak var suggestedName: UILabel!
    @IBOutlet weak var suggestedType: UILabel!
    @IBOutlet weak var suggestedNotes: UILabel!
    @IBOutlet weak var suggestedOpen: UILabel!
    @IBOutlet weak var suggestedExtinct: UILabel!
    @IBOutlet weak var suggestedSeasonal: UILabel!
    @IBOutlet weak var suggestScoreCard: UILabel!
    @IBOutlet weak var suggestModel: UILabel!
    @IBOutlet weak var suggestFormerName: UILabel!
    @IBOutlet weak var suggestHieght: UILabel!
    @IBOutlet weak var suggestLength: UILabel!
    @IBOutlet weak var suggestSpeed: UILabel!
    @IBOutlet weak var suggestDuration: UILabel!
    
    @IBOutlet weak var originalName: UILabel!
    @IBOutlet weak var originalType: UILabel!
    @IBOutlet weak var originalOpen: UILabel!
    @IBOutlet weak var originalClose: UILabel!
    @IBOutlet weak var originalMan: UILabel!
    @IBOutlet weak var originalExtinct: UILabel!
    @IBOutlet weak var originalSeasonal: UILabel!
    @IBOutlet weak var origianalScoreCard: UILabel!
    @IBOutlet weak var originalModel: UILabel!
    @IBOutlet weak var originalFormerName: UILabel!
    @IBOutlet weak var originalHeight: UILabel!
    @IBOutlet weak var originalLength: UILabel!
    @IBOutlet weak var originalSpeed: UILabel!
    @IBOutlet weak var originalDuration: UILabel!
    
    
    @IBOutlet weak var revertButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var rideTypeSwitch: UIPickerView!
    @IBOutlet weak var openField: UITextField!
    @IBOutlet weak var closeField: UITextField!
    @IBOutlet weak var manufacturerField: UITextField!
    @IBOutlet weak var extinctSwitch: UISwitch!
    @IBOutlet weak var scoreCardSwtich: UISwitch!
    @IBOutlet weak var modelField: UITextField!
    @IBOutlet weak var formerNameField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var lengthField: UITextField!
    @IBOutlet weak var speedField: UITextField!
    @IBOutlet weak var durationField: UITextField!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var seasonalSwitch: UISwitch!
    
    @IBOutlet weak var topScrollWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollWidth: NSLayoutConstraint!
    let screenSize = UIScreen.main.bounds
    
    @IBOutlet weak var parkName: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    var scoreCard = 0
    var active = 1
    var rideType = 0
    var pickerData: [String] = [String]()
    var originalAttraction: AttractionsModel = AttractionsModel()
    var suggestedAttraction: ApproveSuggestAttracionModel = ApproveSuggestAttracionModel()
    var userName = ""
    var parkNameText = ""
    
    override func viewDidLoad() {
        nameField.delegate = self
        manufacturerField.delegate = self
        super.viewDidLoad()
      // parkName.text = parkNameText
        emailLabel.text = userName
        suggestedName.text=suggestedAttraction.rideName
        let type = convertRideTypeID(rideTypeID: Int(suggestedAttraction.type))
        suggestedType.text = type
        suggestedOpen.text = String(suggestedAttraction.YearOpen)
        suggestedClose.text = String(suggestedAttraction.YearClose)
        suggestedNotes.text = suggestedAttraction.notes
        suggestedManufacturer.text = suggestedAttraction.manufacturer
        suggestModel.text = suggestedAttraction.model
        suggestSpeed.text = String(suggestedAttraction.speed)
        suggestFormerName.text = suggestedAttraction.formerNames
        suggestHieght.text = String(suggestedAttraction.height)
        suggestLength.text = String(suggestedAttraction.length)
        suggestDuration.text = String(suggestedAttraction.duration)
        suggestedSeasonal.text = String(suggestedAttraction.seasonal)
        
        nameField.text = suggestedAttraction.rideName
        openField.text = String(suggestedAttraction.YearOpen)
        closeField.text = String(suggestedAttraction.YearClose)
        manufacturerField.text = suggestedAttraction.manufacturer
        modelField.text = suggestedAttraction.model
        formerNameField.text = suggestedAttraction.formerNames
        heightField.text = String(suggestedAttraction.height)
        lengthField.text = String(suggestedAttraction.length)
        speedField.text = String(suggestedAttraction.speed)
        durationField.text = String(suggestedAttraction.duration)
        
        let orgType = convertRideTypeID(rideTypeID: Int(originalAttraction.rideType))
        originalName.text = originalAttraction.name
        originalType.text = orgType
        originalOpen.text = String(originalAttraction.yearOpen)
        originalClose.text = String(originalAttraction.yearClosed)
        originalMan.text = originalAttraction.manufacturer
        originalModel.text = originalAttraction.model
        originalFormerName.text = originalAttraction.previousNames
        originalHeight.text = String(originalAttraction.height)
        originalLength.text = String(originalAttraction.length)
        originalSpeed.text = String(originalAttraction.speed)
        originalDuration.text = String(originalAttraction.duration)
        parkNameLabel.text = suggestedAttraction.parkName
        self.rideTypeSwitch.delegate = self
        self.rideTypeSwitch.dataSource = self
        
        pickerData = ["","Roller Coaster", "Water Ride","Childrens Ride", "Flat Ride", "Transport Ride", "Dark Ride", "Explore", "Spectacular", "Show", "Film", "Parade", "Play Area", "Upcharge"]
        rideTypeSwitch.selectRow(Int(suggestedAttraction.type!), inComponent: 0, animated: true)
       
        scoreCardSwtich.isOn = false
        
        if originalAttraction.seasonal == 1 {originalSeasonal.text = "Yes"}
        else {originalSeasonal.text = "No"}
        
        if suggestedAttraction.seasonal == 1 {suggestedSeasonal.text = "Yes"}
        else {suggestedSeasonal.text = "No"}
        
        if originalAttraction.active == 1 { originalExtinct.text = "No" }
        else { originalExtinct.text = "Yes"}
        
        if suggestedAttraction.active == 1 { suggestedExtinct.text = "No" }
        else { suggestedExtinct.text = "Yes" }
        
        if originalAttraction.hasScoreCard == 1 { origianalScoreCard.text = "yes"}
        else { origianalScoreCard.text = "No" }
        
        if suggestedAttraction.scoreCard == 1 { suggestScoreCard.text = "Yes" }
        else { suggestScoreCard.text = "No"}
        
        if suggestedAttraction.scoreCard == 1{ scoreCardSwtich.isOn = true }
        else { scoreCardSwtich.isOn = false }
        
        if suggestedAttraction.active == 1 {extinctSwitch.isOn = false}
        else { extinctSwitch.isOn = true }
        
        if suggestedAttraction.seasonal == 1 {seasonalSwitch.isOn = true}
        else {seasonalSwitch.isOn = false}
        
        if screenSize.width == 320 {
            topScrollWidth.constant = 300
        }
        scrollWidth.constant = screenSize.width
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))) //hide keyboard when tapping the anywhere else
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
        case "Transport Ride":
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
        Analytics.logEvent("attraction_modification_deleted", parameters: nil)
        let dataModel = DataModel()
        dataModel.delegate = self
        let urlPath =  "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/deleteFromList.php?list=UserSuggest&key=id&tempID=\(suggestedAttraction.id!)"
        
        let changes = getChangedDetails()
        let (urlPath3) = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/uploadToDatabaseLog.php? username=\(userName)&changes=\(changes)&status=\("Deleted")" //uploads to suggestion log
        print (urlPath)
        dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
        dataModel.downloadData(urlPath: urlPath3, dataBase: "upload", returnPath: "upload")
        self.performSegue(withIdentifier: "toApproveSuggestions", sender: self)
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        Analytics.logEvent("attraction_modification_approved", parameters: nil)
        let rideName = nameField.text
        let parkID = originalAttraction.parkID!
        let yearOpen = openField.text!
        let yearClosed = closeField.text!
        let manufacturer = manufacturerField.text!

        var active = 1
        if extinctSwitch.isOn{ active = 0}
        
        var seasonal = 0
        if seasonalSwitch.isOn{seasonal = 1}
        
        if scoreCardSwtich.isOn { scoreCard = 1 }
        
        if rideType == 0 { rideType = suggestedAttraction.type }
        
        let tempName = rideName!.replacingOccurrences(of: "&", with: "!A?")
        let tempMan = manufacturer.replacingOccurrences(of: "&", with: "!A?")
        var modifiedBy = ""
        if originalAttraction.modifyBy! == "" {
            modifiedBy = userName
            print("first adder")
        }
        else if originalAttraction.modifyBy.contains(userName){
            modifiedBy = originalAttraction.modifyBy!
            print("repeat adder")
        }
        else {
        modifiedBy = "\(originalAttraction.modifyBy!), \(userName)"
        }
        var notes = ""
        if originalAttraction.notes! == "" {
            notes = suggestedAttraction.notes!
        }
        else {
            notes = originalAttraction.notes!
            notes += suggestedAttraction.notes!
        }
        
        print("changed by: \(modifiedBy)")
        
        
        let urlPath = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/modifyAttraction.php?id=\(originalAttraction.rideID!)&name=\(tempName)&ParkID=\(parkID)&type=\(rideType)&yearOpen=\(yearOpen)&YearClosed=\(yearClosed)&active=\(active)&seasonal=\(seasonal)&scoreCard=\(scoreCard)&manufacturer=\(tempMan)&formerNames=\(self.formerNameField.text!)&model=\(self.modelField.text!)&height=\(self.heightField.text!)&maxSpeed=\(self.speedField.text!)&length=\(self.lengthField.text!)&duration=\(self.durationField.text!)&notes=\(notes)&modifyBy=\(modifiedBy)"  //uploads to main list
        print (urlPath)
        let changes = getChangedDetails()
        let (urlPath3) = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/uploadToDatabaseLog.php? username=\(userName)&changes=\(changes)&status=\("Approved")" //uploads to suggestion log
        print(urlPath3)
        let dataModel = DataModel()
        dataModel.delegate = self
        let urlPath2 =  "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/deleteFromList.php?list=UserSuggest&key=id&tempID=\(suggestedAttraction.id!)"//deletes from suggested list
        print(urlPath2)
        dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
        dataModel.downloadData(urlPath: urlPath2, dataBase: "upload", returnPath: "upload")
        dataModel.downloadData(urlPath: urlPath3, dataBase: "upload", returnPath: "upload")
        self.performSegue(withIdentifier: "toApproveSuggestions", sender: self)
    }
    
    @IBAction func revertButton(_ sender: Any) {
        revertButton.isEnabled = false

        nameField.text = originalAttraction.name
        rideTypeSwitch.selectRow(Int(originalAttraction.rideType!), inComponent: 0, animated: true)
        openField.text = String(originalAttraction.yearOpen)
        closeField.text = String(originalAttraction.yearClosed)
        manufacturerField.text = originalAttraction.manufacturer
        modelField.text = originalAttraction.model
        formerNameField.text = originalAttraction.previousNames
        heightField.text = String(originalAttraction.height)
        lengthField.text = String(originalAttraction.length)
        speedField.text = String(originalAttraction.speed)
        durationField.text = String(originalAttraction.duration)
        
        if originalAttraction.active == 1{ extinctSwitch.isOn = false}
        else { extinctSwitch.isOn = true }

        if originalAttraction.hasScoreCard == 1 { scoreCardSwtich.isOn = true }
        else { scoreCardSwtich.isOn = false }
        
        if originalAttraction.seasonal == 1 {seasonalSwitch.isOn = true}
        else {seasonalSwitch.isOn = false}
    }
    
    func getChangedDetails() ->String {
        var changes = "MODIFY: "
        if originalAttraction.name != nameField.text {
            changes += "ride name changed from \(originalAttraction.name!) to \(nameField.text!) at park ID \(suggestedAttraction.parkID!) "
        }
        else {
            changes += "\(suggestedAttraction.rideName!) at park ID \(suggestedAttraction.parkID!) "
        }
        if originalAttraction.rideType != rideType {
            changes += "type changed from \(originalAttraction.rideType!) to \(rideType) "
        }
        if originalAttraction.yearOpen != Int(openField.text!) {
            changes += "opening year changed from \(originalAttraction.yearOpen!) to \(openField.text!) "
        }
        if originalAttraction.yearClosed != Int(closeField.text!)!{
            changes += "closing year changed from \(originalAttraction.yearClosed!) to \(closeField.text!) "
        }
        if originalAttraction.active != active {
            if active == 0{
                changes += "changed to defunct "
            }
            else {
                changes += "changed to open "
            }
        }
        if originalAttraction.manufacturer != manufacturerField.text {
            changes += "manufacturer changed from \(originalAttraction.manufacturer!) to \(manufacturerField.text!) "
        }
        if originalAttraction.hasScoreCard != scoreCard {
            if scoreCard == 0 {
                changes += "scoreCard turned off"
            }
            else {
                changes += "scoreCard turned on"
            }
        }
        if originalAttraction.previousNames != formerNameField.text! {
            changes += "former names inclue \(formerNameField.text!)"
        }
        if originalAttraction.height != Double(heightField.text!) {
            changes += " height is now \(heightField.text!)ft"
        }
        if originalAttraction.speed != Double(speedField.text!){
            changes += " speed is \(speedField.text!)mph"
        }
        if originalAttraction.duration != Int(durationField.text!) {
            changes += " duration is \(String(describing: durationField.text))s"
        }
        if originalAttraction.length != Double(lengthField.text!) {
            changes += " length is \(lengthField.text!)"
        }
        return changes
        
    }
    
    func textFieldDidBeginEditing(_ textView: UITextField) {
        if openField.isEditing {
            openField.text = ""
        }
        if closeField.isEditing {
            closeField.text = ""
        }
        if manufacturerField.isEditing {
            manufacturerField.text = ""
        }
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
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
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
