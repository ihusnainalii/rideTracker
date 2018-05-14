//
//  SuggestRideViewController.swift
//  Ride Track
//
//  Created by Justin Lawrence on 5/10/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit
import Foundation

class SuggestRideViewController: UIViewController, DataModelProtocol, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var parkName = ""
    var parkID = 0
    var rideType = ""
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldOpen: UITextField!
    @IBOutlet weak var textFieldClose: UITextField!
    @IBOutlet weak var pickerType: UIPickerView!
    var pickerData: [String] = [String]()
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            rideType = "Roller_Coaster"
        case 1:
            rideType = "Water_Ride"
        case 2:
            rideType = "Childrens_Ride"
        case 3:
            rideType = "Transporation_Ride"
        case 4:
            rideType = "Dark_Ride"
        case 5:
            rideType = "Explore"
        case 6:
            rideType = "Spectacular"
        case 7:
            rideType = "Show"
        case 8:
            rideType = "Film"
        case 9:
            rideType = "Parade"
        case 10:
            rideType = "Pay_Area"
        default:
            rideType = "UNKNOWN"
        }
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
        let oldRide = textFieldName.text
        let open = textFieldOpen.text
        let close = textFieldClose.text
        let type = rideType
        let oldPark = parkName
        
        let park = oldPark.replacingOccurrences(of: " ", with: "_")
        let ride = oldRide?.replacingOccurrences(of: " ", with: "_")

        //creating the post parameter by concatenating the keys and values from text field
        
//        let url = URL(string: "http://www.beingpositioned.com/theparksman/usersuggestservice.php?")!
        //var request = URLRequest(url: url)
       // request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
       // request.httpMethod = "POST"

        let urlPath = "http://www.beingpositioned.com/theparksman/usersuggestservice.php?parknum=\(parknum)&ride=\(ride!)&open=\(open!)&close=\(close!)&type=\(type)&park=\(park)"
        //let urlPath = "http://www.beingpositioned.com/theparksman/usersuggestservice.php?parknum=2&ride=TalesOfTiz&open=1972&close=2012&type=TESTER&park=TEST"
        print (urlPath)
        
        //request.httpBody = postString.data(using: .utf8)
        dataModel.downloadData(urlPath: urlPath, dataBase: "upload")
        
        }
    func sendData(urlPath: String) {
        print(urlPath)
        let urlPath = URL(string: urlPath)!
        let defaultSessions = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSessions.dataTask(with: urlPath) { (data, response, error)
            in
            if error != nil{
                print("Failed to send data")
            }
            else{
                print("Data Sent")
                //Able to download data from database, now need to parse it
                //self.parseJSON(data!, dataBase: dataBase)
            }
        }
        task.resume()
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

