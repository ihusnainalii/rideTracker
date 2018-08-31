//
//  ExtendedAttractionDetailsViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 7/11/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class ModifyAttractionDetailsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, DataModelProtocol, UITextViewDelegate {

    

    @IBOutlet weak var notesView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var rideTypePicker: UIPickerView!
    @IBOutlet weak var openingField: UITextField!
    @IBOutlet weak var closingField: UITextField!
    @IBOutlet weak var manufacturingField: UITextField!
    @IBOutlet weak var scoreSwitch: UISwitch!
    @IBOutlet weak var extinctSwitch: UISwitch!
    @IBOutlet weak var typeButton: UIButton!
    
    @IBOutlet weak var formerNameField: UITextField!
    @IBOutlet weak var modelField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var speedField: UITextField!
    @IBOutlet weak var lengthField: UITextField!
    
    
    
    @IBOutlet weak var durationButton: UIButton!
    @IBOutlet weak var donePickDuration: UIButton!
    @IBOutlet weak var durationPickerView: UIView!
    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var defunctTop: NSLayoutConstraint!
    @IBOutlet weak var openingHieght: NSLayoutConstraint!
    @IBOutlet weak var closingStack: UIStackView!
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var topScoreCardConst: NSLayoutConstraint!
    let screenSize = UIScreen.main.bounds

    var isAdmin = UserDefaults.standard.integer(forKey: "isAdmin")
    var rideType = 0
    var typePickerData: [String] = [String]()
    var selectedAttraction: AttractionsModel = AttractionsModel()
    var parkName = ""
    var minutes = 0
    var seconds = 0
    var durationInSeconds = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Modifying: ",selectedAttraction.name!)

        openingHieght.constant = 30
        rideTypePicker.isHidden = true
        typeButton.setTitle(convertRideTypeID(rideTypeID: selectedAttraction.rideType!), for: .normal)
        
        topScoreCardConst.constant = 0
        durationPickerView.isHidden = true
        viewHeight.constant = 700
        nameField.text = selectedAttraction.name
        self.rideTypePicker.delegate = self
        self.rideTypePicker.dataSource = self
        self.durationPicker.delegate = self
        self.durationPicker.delegate = self
        nameField.delegate = self
        manufacturingField.delegate = self
        openingField.delegate = self
        closingField.delegate = self
        notesView.delegate = self
        formerNameField.delegate = self
        modelField.delegate = self
        heightField.delegate = self
        speedField.delegate = self
        lengthField.delegate = self
        
        typePickerData = ["","Roller Coaster", "Water Ride","Childrens Ride", "Flat Ride", "Transport Ride", "Dark Ride", "Explore", "Spectacular", "Show", "Film", "Parade", "Play Area", "Upcharge"]
        rideTypePicker.selectRow(Int(selectedAttraction.rideType!), inComponent: 0, animated: true)
        openingField.text = String(selectedAttraction.yearOpen)
        closingField.text = String(selectedAttraction.yearClosed)
        manufacturingField.text = selectedAttraction.manufacturer
        formerNameField.text = selectedAttraction.previousNames
        modelField.text = selectedAttraction.model
        heightField.text = String (selectedAttraction.height!)
        speedField.text = String(selectedAttraction.speed!)
        lengthField.text = String(selectedAttraction.length!)
        durationButton.setTitle(calculateDuration(), for: .normal)
        durationPicker.selectRow(minutes, inComponent: 0, animated: true)
        durationPicker.selectRow(seconds, inComponent: 1, animated: true)
        
        if selectedAttraction.active == 1 {
            extinctSwitch.isOn = false
            closingStack.isHidden = true
            defunctTop.constant = 0
        }
        else {
            extinctSwitch.isOn = true
            closingStack.isHidden = false
            defunctTop.constant = 40
        }
        if selectedAttraction.hasScoreCard == 1 {
            scoreSwitch.isOn = true
        }
        else{
            scoreSwitch.isOn = false
        }
        if selectedAttraction.yearClosed == 0 {
            closingField.text = ""
        }
        if selectedAttraction.yearOpen == 0{
            openingField.text = ""
        }
        if selectedAttraction.height == 0 {
            heightField.text = ""
        }
        if selectedAttraction.length == 0 {
            lengthField.text = ""
        }
        if selectedAttraction.duration == 0 {
            durationButton.setTitle("Duration", for: .normal)
            durationButton.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if selectedAttraction.speed == 0 {
            speedField.text = ""
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))) //hide keyboard when tapping the anywhere else

        if screenSize.width == 320 {
            scrollViewWidth.constant = 320
        }
        // Do any additional setup after loading the view.
    }
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == rideTypePicker { return 1 }
        else { return 2}
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == rideTypePicker { return typePickerData.count }
        else { return 60 }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == rideTypePicker { return typePickerData[row] as String }
        else {
            if component == 0 { return "\(row) minutes" }
            else { return "\(row) seconds" }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerView == rideTypePicker { return pickerView.frame.size.width }
        else { return pickerView.frame.size.width/2 }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //rideType = pickerData[row]
            if pickerView == rideTypePicker {
            switch typePickerData[row] {
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
            typeButton.setTitle(typePickerData[row], for: .normal)
            }
        else {
            if component == 0 {
                minutes = row
                durationButton.setTitle("\(minutes)m \(seconds)s", for: .normal)
            }
            else {
                seconds = row
                durationButton.setTitle("\(minutes)m \(seconds)s", for: .normal)
            }
        durationInSeconds = minutes*60+seconds
        }
    }
    
    func calculateDuration () -> String {
        let durationInSeconds = self.selectedAttraction.duration
        self.minutes = durationInSeconds!/60
        self.seconds = durationInSeconds!%60
        print("\(minutes) minutes \(seconds) seconds")
        return "\(minutes)m \(seconds)s"
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func defunctSwitch(_ sender: Any) {
        if extinctSwitch.isOn {
        UIView.animate(withDuration: 0.3, animations: { //Animate Here
            self.closingStack.isHidden = false
            self.defunctTop.constant = 40
            self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.3, animations: { //Animate Here
                self.closingStack.isHidden = true
                self.defunctTop.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        let rideName = nameField.text
        let parkID = selectedAttraction.parkID!
        let yearOpen = openingField.text!
        let yearClosed = closingField.text!
        var active = 1
        if extinctSwitch.isOn {
            active = 0
        }
        let manufacturer = manufacturingField.text!
        var scoreCard = 0
        if scoreSwitch.isOn {
            scoreCard = 1
        }
        if rideType == 0 {
            rideType = selectedAttraction.rideType
        }
        let tempName = rideName!.replacingOccurrences(of: "&", with: "!A?")
        let tempMan = manufacturer.replacingOccurrences(of: "&", with: "!A?")
        
        var urlPath = ""
        if isAdmin == 1{
        urlPath = "http://www.beingpositioned.com/theparksman/modifyAttraction(NEW).php?id=\(selectedAttraction.rideID!)&name=\(tempName)&ParkID=\(parkID)&type=\(rideType)&yearOpen=\(yearOpen)&YearClosed=\(yearClosed)&active=\(active)&scoreCard=\(scoreCard)&manufacturer=\(tempMan)&formerNames=\(self.formerNameField.text!)&model=\(self.modelField.text!)&height=\(self.heightField.text!)&maxSpeed=\(self.speedField.text!)&length=\(self.lengthField.text!)&duration=\(self.durationInSeconds)" //uploads to main list
        print (urlPath)
            
            var changes = "MODIFY: "
            if selectedAttraction.name != nameField.text {
                changes += "ride name changed from \(selectedAttraction.name!) to \(nameField.text!) at \(parkName) "
            }
            else  {
                changes += "\(rideName!) at \(parkName) "
            }
            if selectedAttraction.rideType != rideType {
                changes += "type changed from \(selectedAttraction.rideType!) to \(rideType) "
            }
            if selectedAttraction.yearOpen != Int(yearOpen) && selectedAttraction.yearOpen != 0{
                changes += "opening year changed from \(selectedAttraction.yearOpen!) to \(yearOpen) "
            }
            if selectedAttraction.yearClosed != Int(yearClosed) && selectedAttraction.yearClosed != 0{
                changes += "closing year changed from \(selectedAttraction.yearClosed!) to \(yearClosed) "
            }
            if selectedAttraction.active != active {
                if active == 0{
                changes += "changed to defunct"
                }
                else {
                changes += "changed to open"
                }
            }
            if selectedAttraction.manufacturer != manufacturingField.text {
                changes += "manufacturer changed from \(selectedAttraction.manufacturer!) to \(manufacturingField.text!) "
            }
            if selectedAttraction.hasScoreCard != scoreCard {
                if scoreCard == 0 {
                    changes += "scoreCard turned off"
                }
                else {
                    changes += "scoreCard turned on"
                }
            }
            let (urlPath3) = "http://www.beingpositioned.com/theparksman/uploadToDatabaseLog.php? username=\("username")&changes=\(changes)&status=\("Approved")" //uploads to suggestion log
            
            let dataModel = DataModel()
            dataModel.delegate = self
            dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
            dataModel.downloadData(urlPath: urlPath3, dataBase: "upload", returnPath: "upload")
            self.performSegue(withIdentifier: "backToDetails", sender: self)
    }
        else {
            let tempNotes = notesView.text.replacingOccurrences(of: " ", with: "_")
            let notes = String (tempNotes.filter { !" \n".contains($0) })
            let alert = UIAlertController(title: "Suggest Modifications to Attraction", message: "Are you sure you want to suggest these modifications to \(rideName!)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: {action in                 urlPath = "http://www.beingpositioned.com/theparksman/usersuggestservice(NEW).php?parknum=\(parkID)&ride=\(tempName)&open=\(yearOpen)&close=\(yearClosed)&type=\(self.rideType)&park=\(self.selectedAttraction.rideID!)&active=\(active)&manufacturer=\(tempMan)&notes=\(notes)&modify=1&scoreCard=\(scoreCard)&formerNames=\(self.formerNameField.text!)&model=\(self.modelField.text!)&height=\(self.heightField.text!)&maxSpeed=\(self.speedField.text!)&length=\(self.lengthField.text!)&duration=\(self.durationInSeconds)" //removed park Name and reaplaced with rideID
                print(urlPath)
                let dataModel = DataModel()
                dataModel.delegate = self
                dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
                self.performSegue(withIdentifier: "backToDetails", sender: self)
            }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
       
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
    
    @IBAction func openDurationPicker(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: { //Animate Here
            self.durationPickerView.isHidden = false
            self.topScoreCardConst.constant = 150
            self.viewHeight.constant += 150
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func donePickDuration(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: { //Animate Here
            self.topScoreCardConst.constant = 0
            self.viewHeight.constant -= 150
            self.durationPickerView.isHidden = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if openingHieght.constant == 150 {
            UIView.animate(withDuration: 0.3, animations: { //Animate Here
                self.rideTypePicker.isHidden = true
                self.openingHieght.constant = 30
                self.viewHeight.constant -= 150
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        print ("Made it here!")
        if notesView.text == "Notes/Citations"{
            notesView.text = ""
            notesView.textColor = UIColor.black
        }
        if openingHieght.constant == 150 {
            UIView.animate(withDuration: 0.3, animations: { //Animate Here
                self.rideTypePicker.isHidden = true
                self.openingHieght.constant = 30
                self.viewHeight.constant -= 150
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    @IBAction func typeButton(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: { //Animate Here
            self.rideTypePicker.isHidden = false
            self.openingHieght.constant = 150
            self.viewHeight.constant += 150
            self.view.layoutIfNeeded()
        }, completion: nil)    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
