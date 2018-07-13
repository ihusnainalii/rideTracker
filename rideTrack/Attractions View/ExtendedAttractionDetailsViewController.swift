//
//  ExtendedAttractionDetailsViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 7/11/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class ExtendedAttractionDetailsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, DataModelProtocol {

    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var rideTypePicker: UIPickerView!
    @IBOutlet weak var openingField: UITextField!
    @IBOutlet weak var closingField: UITextField!
    @IBOutlet weak var manufacturingField: UITextField!
    @IBOutlet weak var scoreSwitch: UISwitch!
    @IBOutlet weak var extinctSwitch: UISwitch!
    
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    let screenSize = UIScreen.main.bounds

    var isAdmin = UserDefaults.standard.integer(forKey: "rememberPasscode")
    var rideType = 0
    var pickerData: [String] = [String]()
    var selectedAttraction: AttractionsModel = AttractionsModel()
    var parkName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Modifying: ",selectedAttraction.name)
        if isAdmin == 0 {
            nameField.isUserInteractionEnabled = false
        }
        else {
            nameField.isUserInteractionEnabled = true
        }
        nameField.text = selectedAttraction.name
        self.rideTypePicker.delegate = self
        self.rideTypePicker.dataSource = self
        nameField.delegate = self
        manufacturingField.delegate = self
        pickerData = ["","Roller Coaster", "Water Ride","Childrens Ride", "Flat Ride", "Transportation Ride", "Dark Ride", "Explore", "Spectacular", "Show", "Film", "Parade", "Play Area", "Upcharge"]
        rideTypePicker.selectRow(Int(selectedAttraction.rideType!), inComponent: 0, animated: true)
        openingField.text = String(selectedAttraction.yearOpen)
        closingField.text = String(selectedAttraction.yearClosed)
        manufacturingField.text = selectedAttraction.manufacturer
        if selectedAttraction.active == 1 {
            extinctSwitch.isOn = false
        }
        else {
            extinctSwitch.isOn = true
        }
        if selectedAttraction.hasScoreCard == 1 {
            scoreSwitch.isOn = true
        }
        else{
            scoreSwitch.isOn = false
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
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row] as String
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
    

    @IBAction func submitButton(_ sender: Any) {
        let tempName = nameField.text
        let rideName = (tempName?.replacingOccurrences(of: " ", with: "_"))!
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
        var urlPath = ""
        if isAdmin == 1{
        urlPath = "http://www.beingpositioned.com/theparksman/modifyAttraction.php?id=\(selectedAttraction.rideID!)&name=\(rideName)&ParkID=\(parkID)&type=\(rideType)&yearOpen=\(yearOpen)&YearClosed=\(yearClosed)&active=\(active)&scoreCard=\(scoreCard)&manufacturer=\(manufacturer)" //uploads to main list
        print (urlPath)
            let dataModel = DataModel()
            dataModel.delegate = self
            dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
            self.performSegue(withIdentifier: "backToDetails", sender: self)
    }
        else {
            let alert = UIAlertController(title: "Suggest Modifications to Attraction", message: "Are you sure you want to suggest these modifications to \(rideName)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: {action in                 urlPath = "http://www.beingpositioned.com/theparksman/usersuggestservice.php?parknum=\(parkID)&ride=\(rideName)&open=\(yearOpen)&close=\(yearClosed)&type=\(self.rideType)&park=\(self.parkName)&active=\(active)&manufacturer=\(manufacturer)&notes=&modify=1"
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
