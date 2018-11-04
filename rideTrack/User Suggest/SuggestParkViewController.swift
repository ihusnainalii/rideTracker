//
//  SuggestParkViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 10/7/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class SuggestParkViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, DataModelProtocol {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var parkNameField: UITextField!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var openField: UITextField!
    @IBOutlet weak var defuntSwitch: UISwitch!
    @IBOutlet weak var closedStack: UIStackView!
    @IBOutlet weak var closedField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var previousNamesField: UITextField!
    @IBOutlet weak var seasonalSwitch: UISwitch!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scrollWidth: NSLayoutConstraint!
    let screenSize = UIScreen.main.bounds

    var parkTypeData: [String] = [String]()
    var selectedType = ""
    
    var parkName = ""
    var type = ""
    var cityState = ""
    var country = ""
    var defunct = 0
    var oldName = ""
    var seasonal = 0
    var URLtext = ""
    var userName = ""
    var lat = 0.0
    var long = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollWidth.constant = screenSize.width
        parkTypeData = ["","Theme Park", "Amusement Park","Zoo", "Kiddie Park", "Family Entertainment Center, Resort & Casino"]
        parkNameField.delegate = self
        typePicker.delegate = self
        typePicker.dataSource = self
        cityField.delegate = self
        countryField.delegate = self
        openField.delegate = self
        closedField.delegate = self
        previousNamesField.delegate = self
        
        typePicker.isHidden = true
        closedStack.isHidden = true
        defuntSwitch.isOn = false
        seasonalSwitch.isOn = false
        submitButton.isEnabled = false
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))) //hide keyboard when tapping the anywhere else
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }
    
    
    @IBAction func pressedSubmit(_ sender: Any) {
        parkName = parkNameField.text!
        let open = openField.text!
        var closed = closedField.text!
        cityState = "\(cityField.text!), \(stateField.text!)"
        country = countryField.text!
        oldName = previousNamesField.text!
        URLtext = websiteField.text!
        if defuntSwitch.isOn { defunct = 1 }
        else {
            defunct = 0
            closed = String(0);
        }
        if seasonalSwitch.isOn {seasonal = 1}
        else {seasonal = 0}
        let dataModel = DataModel()
        
        let alertController = UIAlertController(title: "Suggest Park", message: "Are you sure you want suggest \(parkName)?", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            let urlPath = "http://www.beingpositioned.com/theparksman/suggestParkUploadtoApprove.php?name=\(self.parkName)&type=\(self.type)&city=\(self.cityState)&count=\(self.country)&lat=\(self.lat)&long=\(self.long)&open=\(open)&closed=\(closed)&defunct=\(self.defunct)&prevName=\(self.oldName)&seasonal=\(self.seasonal)&website=\(self.URLtext)&userName=\(self.userName)"
            
            print (urlPath)
            dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
                let ThankAlertController = UIAlertController(title: "Thank You", message: "Thank you for your submission. We will review it and add it to the database.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                    self.performSegue(withIdentifier: "leaveSuggPark", sender: self)
                }
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
    
    @IBAction func defunctSwitch(_ sender: Any) {
        if defuntSwitch.isOn {
            UIView.animate(withDuration: 0.3, animations: {
                self.closedStack.isHidden = false
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.3, animations: {
                self.closedStack.isHidden = true
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @IBAction func typeButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.typePicker.isHidden = false
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    //set up pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return parkTypeData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return parkTypeData[row] as String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = parkTypeData[row]
        type = parkTypeData[row]
        typeButton.setTitle(parkTypeData[row], for: .normal)
        typeButton.setTitleColor(.black, for: .normal)
        if type != "" && parkNameField.text != "" && countryField.text != "" && cityField.text != "" {
            submitButton.isEnabled = true
        }
    }

//set up textfields
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.typePicker.isHidden = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if type != "" && parkNameField.text != "" && countryField.text != "" && cityField.text != "" {
            submitButton.isEnabled = true
        }
    }
    @IBAction func unwindtoSuggestPark(sender: UIStoryboardSegue) {
        let suggestVC = sender.source as! SuggestMapViewController
        lat = suggestVC.lat
        long = suggestVC.long
        if lat != 0.0 || long != 0.0{
        locationButton.setTitle("latitude: \(lat), Longitude: \(long)", for: .normal)
        locationButton.setTitleColor(UIColor.black, for: .normal)
        }
    }
func itemsDownloaded(items: NSArray, returnPath: String) {}
    
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
