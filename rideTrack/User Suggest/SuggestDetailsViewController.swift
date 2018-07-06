//
//  SuggestDetailsViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 7/6/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class SuggestDetailsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, DataModelProtocol{
    func itemsDownloaded(items: NSArray, returnPath: String) {
    
    }
    

    
    

    
var selectedAttraction: ApproveSuggestAttracionModel = ApproveSuggestAttracionModel()

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var scoreCardSwitch: UISwitch!
    @IBOutlet weak var extinctSwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeSwitcher: UIPickerView!
    @IBOutlet weak var openTextField: UITextField!
    @IBOutlet weak var closedTextField: UITextField!
    @IBOutlet weak var manufacturerTextField: UITextField!
    
    var pickerData: [String] = [String]()
    var rideType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.typeSwitcher.delegate = self
        self.typeSwitcher.dataSource = self
        parkNameLabel.text = selectedAttraction.parkName
        nameTextField.text = selectedAttraction.rideName
        pickerData = ["Roller Coaster", "Water_Ride", "Childrens Ride", "Transporation Ride", "Dark Ride", "Explore", "Spectacular", "Show", "Film", "Parade", "Pay Area"]
        openTextField.text = String(selectedAttraction.YearOpen)
        closedTextField.text = String(selectedAttraction.YearClose)
        manufacturerTextField.text = selectedAttraction.manufacturer
        if selectedAttraction.active == 1 {
            extinctSwitch.isOn = false
        }
        else {
            extinctSwitch.isOn = true
        }
        scoreCardSwitch.isOn = false
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row] as String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //rideType = pickerData[row]
        switch pickerData[row] {
        case "Roller Coaster":
            rideType = 1
        case "Water Ride":
            rideType = 2
        case "Children's Ride":
            rideType = 3
        case "Flat Ride":
            rideType = 4
        case "Transport Ride":
            rideType = 5
        case "Dark Ride":
            rideType = 6
        case "Explore":
            rideType = 7
        case "Spectacular":
            rideType = 8
        case "Show":
            rideType = 9
        case "Film":
            rideType = 10
        case "Parade":
            rideType = 11
        case "Play Area":
            rideType = 12
        default:
            rideType = 1
        }
        print("Ride type is: ",rideType)
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        let tempName = nameTextField.text
        let rideName = (tempName?.replacingOccurrences(of: " ", with: "_"))!
        let parkID = selectedAttraction.parkID!
        let yearOpen = openTextField.text!
        let yearClosed = closedTextField.text!
        var active = 1
        if extinctSwitch.isOn{
             active = 0
        }
        let manufacturer = manufacturerTextField.text!
        
        let urlPath = "http://www.beingpositioned.com/theparksman/uploadToAttractionDB.php?name=\(rideName)&ParkID=\(parkID)&type=\(rideType)&yearOpen=\(yearOpen)&YearClosed=\(yearClosed)&active=\(active)&manufacturer=\(manufacturer)" //uploads to main list
        print (urlPath)
        let dataModel = DataModel()
        dataModel.delegate = self
        
        let urlPath2 = "http://www.beingpositioned.com/theparksman/deleteFromUserSuggest.php?number=\(selectedAttraction.id!)" //deletes from suggested list
        dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
        dataModel.downloadData(urlPath: urlPath2, dataBase: "upload", returnPath: "upload")
        self.performSegue(withIdentifier: "toApproveSuggestions", sender: self)
    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        let dataModel = DataModel()
        dataModel.delegate = self
        print ("The ID is ", selectedAttraction.id)
        let urlPath = "http://www.beingpositioned.com/theparksman/deleteFromUserSuggest.php?number=\(selectedAttraction.id!)"
        print (urlPath)
        dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
        self.performSegue(withIdentifier: "toApproveSuggestions", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
