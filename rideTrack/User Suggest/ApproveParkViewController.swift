//
//  ApproveParkViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 10/12/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class ApproveParkViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var latField: UITextField!
    @IBOutlet weak var longField: UITextField!
    @IBOutlet weak var openField: UITextField!
    @IBOutlet weak var closedField: UITextField!
    @IBOutlet weak var defunctSwitch: UISwitch!
    @IBOutlet weak var prevNameField: UITextField!
    @IBOutlet weak var seasonalSwitch: UISwitch!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var userNameText: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollWidth: NSLayoutConstraint!
    let screenSize = UIScreen.main.bounds

    var selectedPark: ApproveSuggParksModel = ApproveSuggParksModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollWidth.constant = screenSize.width

        nameField.text = selectedPark.name
        typeField.text = selectedPark.type
        cityField.text = selectedPark.city
        countryField.text = selectedPark.country
        latField.text = String(selectedPark.latitude)
        longField.text = String(selectedPark.longitude)
        openField.text = String(selectedPark.open)
        closedField.text = String(selectedPark.closed)
        prevNameField.text = selectedPark.prevName
        websiteField.text = selectedPark.website
        userNameText.text = selectedPark.userName
        
        if selectedPark.defunct == 0 { defunctSwitch.isOn = false }
        else {defunctSwitch.isOn = true}
        
        if selectedPark.seasonal == 0
        {seasonalSwitch.isOn = false}
        else {seasonalSwitch.isOn = true}
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
