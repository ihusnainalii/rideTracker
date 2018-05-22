//
//  SuggestRideViewController.swift
//  Ride Track
//
//  Created by Justin Lawrence on 5/10/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit
import Foundation

class SuggestRideViewController: UIViewController, DataModelProtocol, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var parkName = ""
    var parkID = 0
    var rideType = ""
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldOpen: UITextField!
    @IBOutlet weak var textFieldClose: UITextField!
    @IBOutlet weak var pickerType: UIPickerView!
    @IBOutlet weak var activeSwitch: UISwitch!
    var pickerData: [String] = [String]()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    
    func itemsDownloaded(items: NSArray) {
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
        // Do any additional setup after loading the view.
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
        let orgActive = activeSwitch
        var Active = 1
        
        if (orgActive?.isOn)!{
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
                
                
                //creating the post parameter by concatenating the keys and values from text field
                
                let urlPath = "http://www.beingpositioned.com/theparksman/usersuggestservice.php?parknum=\(parknum)&ride=\(ride!)&open=\(open!)&close=\(close!)&type=\(type)&park=\(park)&active=\(Active)"
                print (urlPath)
                Active = 1
                dataModel.downloadData(urlPath: urlPath, dataBase: "upload")
                let ThankAlertController = UIAlertController(title: "Thank You", message: "Thank you for your submission. We will review it and add it to the database.", preferredStyle: .alert)
                ThankAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}

