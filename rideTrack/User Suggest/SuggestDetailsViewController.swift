//
//  SuggestDetailsViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 7/6/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class SuggestDetailsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UITableViewDataSource, UITableViewDelegate, DataModelProtocol{


    @IBOutlet weak var scrollWidth: NSLayoutConstraint!
    @IBOutlet weak var exisitingAttractionsTableView: UITableView!
    
    let screenSize = UIScreen.main.bounds

    var selectedAttraction: ApproveSuggestAttracionModel = ApproveSuggestAttracionModel()
    var modifyAttraction: AttractionsModel = AttractionsModel()
    var listOfAttractionsAtPark = [AttractionsModel]()
    let deleteColor = UIColor(red: 206/255.0, green: 59/255.0, blue: 63/255.0, alpha: 1.0)
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var scoreCardSwitch: UISwitch!
    @IBOutlet weak var extinctSwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeSwitcher: UIPickerView!
    @IBOutlet weak var openTextField: UITextField!
    @IBOutlet weak var closedTextField: UITextField!
    @IBOutlet weak var manufacturerTextField: UITextField!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
  
    var pickerData: [String] = [String]()
    var rideType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlPath = "http://www.beingpositioned.com/theparksman/attractiondbservice.php?parkid=\(selectedAttraction.parkID!)"
        let dataModel = DataModel()
        dataModel.delegate = self
        dataModel.downloadData(urlPath: urlPath, dataBase: "attractions", returnPath: "attractions")
        
        self.typeSwitcher.delegate = self
        self.typeSwitcher.dataSource = self
        nameTextField.delegate = self
        openTextField.delegate = self
        closedTextField.delegate = self
        manufacturerTextField.delegate = self
        parkNameLabel.text = selectedAttraction.parkName
        nameTextField.text = selectedAttraction.rideName
        pickerData = ["Roller Coaster", "Water Ride", "Childrens Ride", "Transportation Ride", "Dark Ride", "Explore", "Spectacular", "Show", "Film", "Parade", "Pay Area"]
        
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
        typeSwitcher.selectRow((Int(selectedAttraction.type!)!-2), inComponent: 0, animated: true)
        //typeSwitcher.selectRow(, inComponent: 0, animated: true)
        // Do any additional setup after loading the view.
        //if iphone 5 class
        if screenSize.width == 320 {
            scrollWidth.constant = 320
        }
    }
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        let arrayOfRides = items as! [AttractionsModel]
        for i in 0..<arrayOfRides.count{
        listOfAttractionsAtPark.append(arrayOfRides[i])
        }
        listOfAttractionsAtPark.sort { ($0.active, $1.name) > ($1.active, $0.name) }
        exisitingAttractionsTableView.reloadData()

        for i in 0..<listOfAttractionsAtPark.count {
            if listOfAttractionsAtPark[i].name! == selectedAttraction.rideName!{
                let alert = UIAlertController(title: "Duplicate Attraction", message: "This attraction already exists in the database. Would you like to delete the suggestion or update the existing attraction?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                   print ("cancel")
                }))
                alert.addAction(UIAlertAction(title: "Modify", style: .default, handler: { action in
                print ("modify")
                    self.modifyAttraction = self.listOfAttractionsAtPark[i]
                   // let vc = ModifyAttractionViewController()
                    //self.present(vc, animated: true, completion: nil)
                    self.performSegue(withIdentifier: "toModifyVC", sender: self)
                }))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                    print ("delete")
                    let dataModel = DataModel()
                    dataModel.delegate = self
                    let urlPath = "http://www.beingpositioned.com/theparksman/deleteFromUserSuggest.php?number=\(self.selectedAttraction.id!)"
                    print (urlPath)
                    dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
                    self.performSegue(withIdentifier: "toApproveSuggestions", sender: self)
                }))
                self.present(alert, animated: true, completion: nil)
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfAttractionsAtPark.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = exisitingAttractionsTableView.dequeueReusableCell(withIdentifier: "attractionCell", for: indexPath)
        cell.textLabel?.text = listOfAttractionsAtPark[indexPath.row].name!
        if listOfAttractionsAtPark[indexPath.row].active == 1 {
            cell.backgroundColor = UIColor.white
        }
        else {
            cell.backgroundColor = UIColor.gray
        }
        return cell
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
        case "Childrens Ride":
            rideType = 3
        case "Flat Ride":
            rideType = 4
        case "Transportation Ride":
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
            rideType = 0
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
        var scoreCard = 0
        if scoreCardSwitch.isOn {
            scoreCard = 1
        }
        let urlPath = "http://www.beingpositioned.com/theparksman/uploadToAttractionDB.php?name=\(rideName)&ParkID=\(parkID)&type=\(rideType)&yearOpen=\(yearOpen)&YearClosed=\(yearClosed)&active=\(active)&scoreCard=\(scoreCard)&manufacturer=\(manufacturer)" //uploads to main list
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
    
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    func textFieldDidBeginEditing(_ textView: UITextField) {
            moveTextField(textField: textView, moveDistance: -215, up: true)
            print ("BELOW OPENING")
    }
//    func textFieldDidEndEditing(_ textView: UITextField) {
//            moveTextField(textField: textView, moveDistance: -215, up: false)
//            print ("End OPENING")
//    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveTextField(textField: textField, moveDistance: -215, up: false)
        self.view.endEditing(true)
        print ("End DONE")
        return true
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toModifyVC"{
            let modifyVC = segue.destination as! ModifyAttractionViewController
            modifyVC.suggestedAttraction = selectedAttraction
            modifyVC.originalAttraction = modifyAttraction
        }
    }


}
