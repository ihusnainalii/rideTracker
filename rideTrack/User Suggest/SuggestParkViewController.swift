//
//  SuggestParkViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 10/7/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class SuggestParkViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var parkNameField: UITextField!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var openField: UITextField!
    @IBOutlet weak var defuntSwitch: UISwitch!
    @IBOutlet weak var closedStack: UIStackView!
    @IBOutlet weak var closedField: UITextField!
    @IBOutlet weak var previousNamesField: UITextField!
    @IBOutlet weak var seasonalSwitch: UISwitch!
    @IBOutlet weak var websiteField: UITextField!
    
    @IBOutlet weak var scrollWidth: NSLayoutConstraint!
    let screenSize = UIScreen.main.bounds

    var parkTypeData: [String] = [String]()
    var selectedType = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollWidth.constant = screenSize.width
        parkTypeData = ["","Theme Park", "Amusment Park","Zoo", "Kiddie Park", "Family Entertainment Center"]
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
        typeButton.setTitle(parkTypeData[row], for: .normal)
        typeButton.setTitleColor(.black, for: .normal)
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
    
}
