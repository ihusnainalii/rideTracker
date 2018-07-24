//
//  SignUpViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 7/22/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "SignInFromSignUp", sender: nil)
            }
        }
    }
    
    @IBAction func didTapSignUp(_ sender: UIButton) {
        let email = emailField.text
        let password = passwordField.text
        Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .invalidEmail:
                        self.showAlert("Enter a valid email.")
                    case .emailAlreadyInUse:
                        self.showAlert("Email already in use.")
                    default:
                        self.showAlert("Error: \(error.localizedDescription)")
                    }
                }
                return
            }
            Auth.auth().signIn(withEmail: email!,
                               password: password!)
        })
    }
    
    @IBAction func didTapBackToLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Please try again", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
