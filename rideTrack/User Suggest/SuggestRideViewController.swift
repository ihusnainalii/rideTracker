//
//  SuggestRideViewController.swift
//  Ride Track
//
//  Created by Justin Lawrence on 5/10/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class SuggestRideViewController: UIViewController, DataModelProtocol, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var parkName = ""
    var parkID = 0
    var rideType = 0
    var userAttractionDatabase: [UserAttractionProvider]!
    var isAdmin = UserDefaults.standard.integer(forKey: "isAdmin")
    var durationInSeconds = 0
    var seconds = 0
    var minutes = 0
    var userName = ""
    var userIDNum = ""
    var token = ""
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var typeDiscription: UITextView!
    
    @IBOutlet weak var closingStack: UIStackView!
    
    @IBOutlet weak var typeLabel: UIButton!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldOpen: UITextField!
    @IBOutlet weak var textFieldClose: UITextField!
    @IBOutlet weak var pickerType: UIPickerView!
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var YearClosedText: UILabel!
    @IBOutlet weak var manufacturerText: UITextField!
    @IBOutlet weak var notesText: UITextView!
    @IBOutlet weak var scoreCardSwitch: UISwitch!
    @IBOutlet weak var seasonalSwitch: UISwitch!
    
    @IBOutlet weak var formerNameField: UITextField!
    @IBOutlet weak var lengthField: UITextField!
    @IBOutlet weak var durationButton: UIButton!
    @IBOutlet weak var durationPickerView: UIView!
    @IBOutlet weak var speedField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var modelField: UITextField!
    let screenSize = UIScreen.main.bounds
    @IBOutlet weak var scrollWidth: NSLayoutConstraint!
    @IBOutlet weak var durationPicker: UIPickerView!
    
    let greyColor = UIColor(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 1.0)

    var rideTypePickerData: [String] = [String]()
    
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        print("items downloads?")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = Auth.auth().currentUser
        userIDNum = (userID?.uid)!
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.token = result.token
            }
        }
        
        scoreCardSwitch.isOn = false
        seasonalSwitch.isOn = false
        parkNameLabel.text = parkName
        textFieldName.delegate = self
        textFieldOpen.delegate = self
        textFieldClose.delegate = self
        manufacturerText.delegate = self
        speedField.delegate = self
        lengthField.delegate = self
        heightField.delegate = self
        formerNameField.delegate = self
        notesText.delegate = self
        submitButton.isEnabled = false
        
        pickerType.isHidden = true

        self.pickerType.delegate = self
        self.pickerType.dataSource = self
        rideTypePickerData = ["","Roller Coaster", "Water Ride","Childrens Ride", "Flat Ride", "Transport Ride", "Dark Ride", "Explore", "Spectacular", "Show", "Film", "Parade", "Play Area", "Upcharge"]
        activeSwitch.isOn=false
        closingStack.isHidden = true
       durationPickerView.isHidden = true
        durationButton.setTitleColor(UIColor.lightGray, for: .normal)
        durationPicker.delegate = self
        durationPicker.dataSource = self
        typeDiscription.delegate = self

         self.textFieldClose.keyboardType = UIKeyboardType.numberPad
        self.textFieldOpen.keyboardType = UIKeyboardType.numberPad
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))) //hide keyboard when tapping the anywhere else
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        notesText.layer.borderWidth = 0.5
        notesText.layer.borderColor = borderColor.cgColor
        notesText.layer.cornerRadius = 5.0
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
            scrollWidth.constant = (screenSize.width - 1)
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pickerType {return 1}
        else { return 2}
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerType { return rideTypePickerData.count }
        else { return 60 }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerView == pickerType { return pickerView.frame.size.width}
        else { return pickerView.frame.size.width/2}
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerType { return rideTypePickerData[row] as String }
        else {
            if component == 0 { return "\(row) minutes" }
            else { return "\(row) seconds" }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerType {
        //rideType = pickerData[row]
        switch rideTypePickerData[row] {
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
        typeLabel.setTitle(rideTypePickerData[row], for: .normal)
        typeLabel.setTitleColor(UIColor.black, for: .normal)
        if textFieldName.text != "" && rideType != 0 {
            submitButton.isEnabled = true
        }
        print("Ride type is: ",rideType)
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
            durationButton.setTitleColor(UIColor.black, for: .normal)
            durationInSeconds = minutes*60+seconds
        }
    }
    
    @IBAction func extinctSwitch(_ sender: Any) {
        if (activeSwitch.isOn){
            UIView.animate(withDuration: 0.3, animations: { //Animate Here
                self.closingStack.isHidden = false
                self.view.layoutIfNeeded()
            }, completion: nil)
            print ("CLOSED")
        }
        else {
            UIView.animate(withDuration: 0.3, animations: { //Animate Here
                self.closingStack.isHidden = true
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
    }
    
    @IBAction func buttonSave(_ sender: Any) {
        let dataModel = DataModel()
        if textFieldName.text == "Getting admin access 102" && parkName == "Magic Kingdom"{ //admin access code
            let adminAlertController = UIAlertController(title: "Congratulations", message: "You have now been given admin access to approve user submissions. You can also quickly modify ride details without approval", preferredStyle: .alert)
            let becomeAdminAction  = UIAlertAction(title: "Become Admin", style: .default, handler: { (action) -> Void in
                self.isAdmin = 1
                UserDefaults.standard.set(self.isAdmin, forKey: "isAdmin")
                self.performSegue(withIdentifier: "unwindToDetailsView", sender: self)
                Analytics.logEvent("new_admin", parameters:["adnimUserName": self.userName])
            })
            let removeAdminAction = UIAlertAction(title: "Remove Admin Status", style: .default, handler: { (action) -> Void in
                self.isAdmin = 0
                UserDefaults.standard.set(self.isAdmin, forKey: "isAdmin")
                self.performSegue(withIdentifier: "unwindToDetailsView", sender: self)
            })
            adminAlertController.addAction(becomeAdminAction)
            adminAlertController.addAction(removeAdminAction)
            self.present(adminAlertController, animated: true, completion: nil)
        }
        dataModel.delegate = self
        print ("This is the type: ", rideType)
        if rideType == 0 {
            rideType = -1
        }
        var scoreCard = 0
        //getting values from text fields
        if scoreCardSwitch.isOn { scoreCard = 1 }
        
        var seasonal = 0
        if seasonalSwitch.isOn {seasonal = 1}
        
        let parknum = parkID
        let ride = textFieldName.text
        let open = textFieldOpen.text
        let close = textFieldClose.text
        let type = rideType
        let park = parkName
        let manufacturer = manufacturerText.text
        var tempNotes = notesText.text
        var Active = 1
        
        if (activeSwitch?.isOn)!{
            Active = 0
            print ("ACTIVE?: \(Active)")
        }
        
        if (textFieldName.text == ""){
            let ivalidAlertController = UIAlertController(title: "Empty ride name", message: "Please enter the ride name", preferredStyle: .alert)
            ivalidAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ivalidAlertController, animated: true, completion:nil)
        }
        else if (rideType == -1){
            let ivalidAlertController = UIAlertController(title: "Empty ride type", message: "Please enter the ride type", preferredStyle: .alert)
            ivalidAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ivalidAlertController, animated: true, completion:nil)
            
        }
        else {
            let alertController = UIAlertController(title: "Suggest Attraction", message: "Are you sure you want suggest \(String(describing: ride!)) from \(parkName)?", preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                if tempNotes == "Notes/Citations"{
                    tempNotes = ""
                }
                let orgNotes = tempNotes?.replacingOccurrences(of: " ", with: "_")
                let notes = String (orgNotes!.filter { !" \n".contains($0) })
                //creating the post parameter by concatenating the keys and values from text field
                let tempName = ride!.replacingOccurrences(of: "&", with: "!A?")
                let tempMan = manufacturer!.replacingOccurrences(of: "&", with: "!A?")
                
                let urlPath = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/usersuggestservice.php?parknum=\(parknum)&ride=\(tempName)&open=\(open!)&close=\(close!)&type=\(type)&park=\(park)&active=\(Active)&seasonal=\(seasonal)&rideID=\(0)&manufacturer=\(tempMan)&notes=\(notes)&modify=0&scoreCard=\(scoreCard)&formerNames=\(self.formerNameField.text!)&model=\(self.modelField.text!)&height=\(self.heightField.text!)&maxSpeed=\(self.speedField.text!)&length=\(self.lengthField.text!)&duration=\(self.durationInSeconds)&email=\(self.userName)&token=\(self.token)&userID=\(self.userIDNum)"

                print (urlPath)
                Active = 1
                dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
                let ThankAlertController = UIAlertController(title: "Thank You", message: "Thank you for your submission. We will review it and add it to the database.", preferredStyle: .alert)
                print ("ride type is: ", self.rideType)
                let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                    //let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "parksView")
                    self.performSegue(withIdentifier: "unwindToDetailsView", sender: self)
                   // self.performSegue(withIdentifier: "unwindToDetailsView", sender: self)
                }
                Analytics.logEvent("new_attraction_suggested", parameters: nil)
                ThankAlertController.addAction(action)
                self.present(ThankAlertController, animated: true, completion:nil)
                
            }
            alertController.addAction(OKAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel button tapped");
            }
            alertController.addAction(cancelAction)
            // Present Dialog message
            self.present(alertController, animated: true, completion:nil)
            
        }
        
    }

    @IBAction func typeButton(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: { //Animate Here
            self.pickerType.isHidden = false
            self.view.layoutIfNeeded()
        }, completion: nil)
       
    }
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openDurationPicker(_ sender: Any) {
        var done = textFieldShouldReturn(speedField)
        done = textFieldShouldReturn(lengthField)
        done = textFieldShouldReturn(heightField)
        UIView.animate(withDuration: 0.3, animations: { //Animate Here
            self.durationPickerView.isHidden = false
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func closeDurationPicker(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: { //Animate Here
            self.durationPickerView.isHidden = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: { //Animate Here
            self.pickerType.isHidden = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textFieldName.text != "" && rideType != 0 {
            submitButton.isEnabled = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            self.pickerType.isHidden = true
        if notesText.text == "Notes/Citations" {
            notesText.text = ""
            notesText.textColor = UIColor.black
        }

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    @IBAction func openDiscriptionType(_ sender: Any) {
        typeDiscription.isHidden = false
        typeDiscription.layer.cornerRadius = 7
        typeDiscription.layer.shadowOpacity = 0.3
        typeDiscription.layer.shadowOffset = CGSize.zero
        typeDiscription.layer.shadowRadius = 5
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

    
    
    
}

