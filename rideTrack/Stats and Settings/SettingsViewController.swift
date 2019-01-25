//
//  SettingsViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 5/24/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import Firebase
import SafariServices

class SettingsViewController: UIViewController, UITextViewDelegate, SFSafariViewControllerDelegate {
    var usersParkList: NSMutableArray = NSMutableArray()
    var downloadIncrementor = 0
    // var showExtinct : Int?
    var simulateLocation = 0
    var resetPressed : Int?
    var privacyLinkText = "https://www.theparksman.com/logride-privacy-policy/"
    var termsOfServiceLinktext = "https://www.theparksman.com/logride-terms-and-conditions/"
    @IBOutlet weak var simulateLocationLabel: UILabel!
    @IBOutlet weak var approveSuggestionsButton: UIButton!
    @IBOutlet weak var simulateLocationSwitch: UISwitch!
    @IBOutlet weak var emailLink: UITextView!
    @IBOutlet weak var reportCardButton: UIButton!
    var isAdmin = UserDefaults.standard.integer(forKey: "isAdmin")
    let screenSize = UIScreen.main.bounds
    var userID: String!
    var darkenBackground=UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLink.isEditable = false
        emailLink.dataDetectorTypes = .link
        resetPressed = 0
        if simulateLocation == 0{
            simulateLocationSwitch.isOn = false
        } else{
            simulateLocationSwitch.isOn = true
        }
        if isAdmin == 1 {
            simulateLocationLabel.isHidden = false
            simulateLocationSwitch.isHidden = false
            approveSuggestionsButton.isHidden = false
            reportCardButton.isHidden = false
        }
        else {
            simulateLocationLabel.isHidden = true
            simulateLocationSwitch.isHidden = true
            approveSuggestionsButton.isHidden = true
            reportCardButton.isHidden = true
        }
        
        darkenBackground=UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        darkenBackground.backgroundColor = UIColor.black
        darkenBackground.alpha = 0.0
        darkenBackground.isUserInteractionEnabled = true
        self.view.addSubview(darkenBackground)
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "SignOut", sender: nil)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
    }
    
    @IBAction func didTapTermsofService(_ sender: Any) {
        let safariVC = SFSafariViewController(url: NSURL(string: "https://www.theparksman.com/logride-terms-and-conditions/")! as URL)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
        
    }
    
    @IBAction func didTapPrivacyPolicy(_ sender: Any) {
        let safariVC = SFSafariViewController(url: NSURL(string: "https://www.theparksman.com/logride-privacy-policy/")! as URL)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
    }
    
    @IBAction func didTapFAQ(_ sender: Any) {
        let safariVC = SFSafariViewController(url: NSURL(string: "https://www.theparksman.com/logride-faq/")! as URL)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func simulateLocation(_ sender: Any) {
        if simulateLocationSwitch.isOn{
            simulateLocation = 1
            print("simulating location")
        }
        else{
            simulateLocation = 0
            print("Stopped simulating location")
        }
        UserDefaults.standard.set(simulateLocation, forKey: "simulateLocation")
    }
    
    @IBAction func unwindToSettingsView(sender: UIStoryboardSegue) {
        print("Back to settings")
        UIView.animate(withDuration: 0.2, animations: {
            self.darkenBackground.alpha =  0.0
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toParkList"{

        }
        if segue.identifier == "toReportCard"{
            let navVC = segue.destination as? UINavigationController
            let reportCardVC = navVC?.viewControllers.first as! MyTripsViewController
            print("toReportCard with uid \(userID!)")
            reportCardVC.userID = userID!
            UIView.animate(withDuration: 0.2, animations: {
                self.darkenBackground.alpha =  0.20
            })
        }
    }
}
