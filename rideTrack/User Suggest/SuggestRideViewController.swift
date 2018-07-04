//
//  SuggestRideViewController.swift
//  Ride Track
//
//  Created by Justin Lawrence on 5/10/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit
import Foundation

class SuggestRideViewController: UIViewController, DataModelProtocol, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var parkName = ""
    var parkID = 0
    var rideType = ""
    var userAttractionDatabase: [UserAttractionProvider]!

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldOpen: UITextField!
    @IBOutlet weak var textFieldClose: UITextField!
    @IBOutlet weak var pickerType: UIPickerView!
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var YearClosedText: UILabel!
    @IBOutlet weak var manufacturerText: UITextField!
    @IBOutlet weak var notesText: UITextView!
    
    var pickerData: [String] = [String]()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count;
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row] as String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rideType = pickerData[row]
        print(pickerData[row])
    }
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        print("items downloads?")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldName.delegate = self
        textFieldOpen.delegate = self
        textFieldClose.delegate = self
        self.pickerType.delegate = self
        self.pickerType.dataSource = self
        pickerData = ["Roller_Coaster", "Water_Ride", "Childrens_Ride", "Transporation_Ride", "Dark_Ride", "Explore", "Spectacular", "Show", "Film", "Parade", "Pay_Area"]
        activeSwitch.isOn=false
        textFieldClose.isHidden = true
        YearClosedText.isHidden = true
         self.textFieldClose.keyboardType = UIKeyboardType.numberPad
        self.textFieldOpen.keyboardType = UIKeyboardType.numberPad
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))) //hide keyboard when tapping the anywhere else
        
         var borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        notesText.layer.borderWidth = 0.5
        notesText.layer.borderColor = borderColor.cgColor
        notesText.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
    }
    @IBAction func extinctSwitch(_ sender: Any) {
        if (activeSwitch.isOn){
            textFieldClose.isHidden = false
            YearClosedText.isHidden = false
            print ("CLOSED")
        }
        else {
            textFieldClose.isHidden = true
            YearClosedText.isHidden = true
            print ("OPEN")
        }
    }
    
    @IBAction func buttonSave(_ sender: Any) {
        let dataModel = DataModel()
        dataModel.delegate = self
        print ("This is the type: ", rideType)
        //getting values from text fields
        let parknum = parkID
        let orgRide = textFieldName.text
        let open = textFieldOpen.text
        let close = textFieldClose.text
        let type = rideType
        let orgPark = parkName
        let orgmanufacturer = manufacturerText.text
        let orgnotes = notesText.text
        var Active = 1
        
        if (activeSwitch?.isOn)!{
            Active = 0
            print ("ACTIVE?: \(Active)")
        }
        
        if (isStringAnInt(string: open!) == false && open != ""){
            let ivalidAlertController = UIAlertController(title: "Invalid Year", message: "Please enter a valid opening year, or leave blank if unknown", preferredStyle: .alert)
            ivalidAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ivalidAlertController, animated: true, completion:nil)
        }
        else if (isStringAnInt(string: close!) == false && close != ""){
            print ("ERROR, please enter a valid year, or leave blank if unknown")
            let ivalidAlertController = UIAlertController(title: "Invalid Year", message: "Please enter a valid closing year, or leave blank if unknown", preferredStyle: .alert)
            ivalidAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ivalidAlertController, animated: true, completion:nil)
            
        }
        else {
            let alertController = UIAlertController(title: "Suggest Attraction", message: "Are you sure you want suggest \(String(describing: orgRide!)) from \(parkName)?", preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                let park = orgPark.replacingOccurrences(of: " ", with: "_")
                let ride = orgRide?.replacingOccurrences(of: " ", with: "_")
                let manufacturer = orgmanufacturer?.replacingOccurrences(of: " ", with: "_")
                let notes = orgnotes?.replacingOccurrences(of: " ", with: "_")
                
                //creating the post parameter by concatenating the keys and values from text field
                
                let urlPath = "http://www.beingpositioned.com/theparksman/usersuggestservice.php?parknum=\(parknum)&ride=\(ride!)&open=\(open!)&close=\(close!)&type=\(type)&park=\(park)&active=\(Active)&manufacturer=\(manufacturer!)&notes=\(notes!)"
                print (urlPath)
                Active = 1
                dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
                let ThankAlertController = UIAlertController(title: "Thank You", message: "Thank you for your submission. We will review it and add it to the database.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                    //let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "parksView")
                    //self.present(ViewController!, animated: true, completion: nil)
                    self.performSegue(withIdentifier: "unwindToAttractions", sender: self)
                    
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
        
    }
    //    func addDoneButtonOnKeyboard() {
    //        print ("MADE DONE TOOL")
    //
    //        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    //        doneToolbar.barStyle       = UIBarStyle.default
    //        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    //        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(SuggestRideViewController.doneButtonAction))
    //
    //        var items = [UIBarButtonItem]()
    //        items.append(flexSpace)
    //        items.append(done)
    //
    //        doneToolbar.items = items
    //        doneToolbar.sizeToFit()
    //
    //        self.textFieldOpen.inputAccessoryView = doneToolbar
    //    }
    //
    //    @objc func doneButtonAction() {
    //        print ("CALLED DONE")
    //        //self.resignFirstResponder()
    //        self.view.endEditing(true)
    //
    //    }
    //

    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func moveTextField(textField: UITextView, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }


    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView == notesText){
            print ("Text field is: ", textView)
            moveTextField(textField: textView, moveDistance: -215, up: true)
            print ("BELOW OPENING")
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView == notesText){
            print ("Text field is: ", textView)
            moveTextField(textField: textView, moveDistance: -215, up: false)
            print ("BELOW OPENING")
        }
    }
    
    func TextFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
}
