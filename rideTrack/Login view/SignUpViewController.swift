//
//  SignUpViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 7/22/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var privacyLink: UITextView!
    @IBOutlet weak var termsOfServiceLink: UITextView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var privacyLinkText = "https://www.theparksman.com/logride-privacy-policy/"
    var termsOfServiceLinktext = "https://www.theparksman.com/logride-terms-and-conditions/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let linkAttributes: [NSAttributedStringKey: Any] = [
            .link: NSURL(string: termsOfServiceLinktext)!,
            .foregroundColor: UIColor.lightGray, .underlineStyle: NSUnderlineStyle.styleSingle.rawValue
        ]
        let attributedString = NSMutableAttributedString(string: "Terms and Conditions")
        attributedString.setAttributes(linkAttributes, range: NSMakeRange(0, 20))
        termsOfServiceLink.isEditable = false
        termsOfServiceLink.attributedText = attributedString
        termsOfServiceLink.font = .systemFont(ofSize: 15)
        termsOfServiceLink.textAlignment = .center
        
        
        let linkAttributes2: [NSAttributedStringKey: Any] = [
            .link: NSURL(string: privacyLinkText)!,
            .foregroundColor: UIColor.lightGray, .underlineStyle: NSUnderlineStyle.styleSingle.rawValue
        ]
        let attributedString2 = NSMutableAttributedString(string: "Privacy Policy")
        attributedString2.setAttributes(linkAttributes2, range: NSMakeRange(0, 14))
        privacyLink.isEditable = false
        privacyLink.attributedText = attributedString2
        privacyLink.font = .systemFont(ofSize: 15)
        privacyLink.textAlignment = .center
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "SignInFromSignUp", sender: nil)
            }
        }
        emailField.delegate = self
        passwordField.delegate = self
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
