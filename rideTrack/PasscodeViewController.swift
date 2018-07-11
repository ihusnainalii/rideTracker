//
//  PasscodeViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 7/11/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class PasscodeViewController: UIViewController, UITextFieldDelegate {

    var rememberPasscode = UserDefaults.standard.integer(forKey: "rememberPasscode")
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var remembertext: UILabel!
    @IBOutlet weak var passcodeField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passcodeField.delegate = self
        submitButton.isEnabled = false
        remembertext.isHidden = true
        rememberSwitch.isHidden = true
        rememberSwitch.isOn = false
        if rememberPasscode == 1 {
            submitButton.isEnabled = true
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func rememberPasscodeSwitch(_ sender: Any) {
        if rememberSwitch.isOn{
            rememberPasscode = 1
            print("rember passcode 1")
        }
        else {
            print("rember passcode 0")
            rememberPasscode = 0
        }
        UserDefaults.standard.set(rememberPasscode, forKey: "rememberPasscode")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print ("Begin")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print ("Done")
        if passcodeField.text == "123"{
            submitButton.isEnabled = true
            rememberSwitch.isHidden = false
            remembertext.isHidden = false
        }
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
