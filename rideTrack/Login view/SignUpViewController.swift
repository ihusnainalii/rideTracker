//
//  SignUpViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 7/22/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class SignUpViewController: UIViewController, UITextFieldDelegate, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userNameFeild: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    
    var privacyLinkText = "https://www.theparksman.com/logride-privacy-policy/"
    var termsOfServiceLinktext = "https://www.theparksman.com/logride-terms-and-conditions/"
    var userRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "SignInFromSignUp", sender: nil)
            }
        }
        emailField.delegate = self
        passwordField.delegate = self
        
        backgroundView.layer.cornerRadius = 7
        backgroundView.layer.shadowOpacity = 0.3
        backgroundView.layer.shadowOffset = CGSize.zero
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.backgroundColor = UIColor.white.cgColor
    }
    
    @IBAction func didTapSignUp(_ sender: UIButton) {
        let email = emailField.text
        let password = passwordField.text
        let userName = userNameFeild.text
        
        if userName == ""{
            showAlert("Please enter a user name.")
        }
        else{
            
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
                let userID = Auth.auth().currentUser
                let id = userID?.uid
                self.userRef = Database.database().reference(withPath: "users/details")
                let newUser = UserName(userName: userName!, userID: id!)
                let newUserRef = self.userRef.child(id!)
                newUserRef.setValue(newUser.toAnyObject())
                
            })
        }
    }
    
    @IBAction func didTapBackToLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Please try again", message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func tapTermsAndService(_ sender: Any) {
        let safariVC = SFSafariViewController(url: NSURL(string: termsOfServiceLinktext)! as URL)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
    }
    @IBAction func tapPrivacyPolicy(_ sender: Any) {
        let safariVC = SFSafariViewController(url: NSURL(string: privacyLinkText)! as URL)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
