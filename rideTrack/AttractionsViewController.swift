//
//  AttractionsViewController.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/15/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
// Pushed may 8, 5:40

import UIKit
import CoreData


class AttractionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataModelProtocol {
    
    @IBOutlet weak var attractionsTableView: UITableView!
    @IBOutlet weak var parkLabel: UILabel!
    
    var titleName = ""
    var parkID = 0
    var attractionListForTable: NSMutableArray = []

    var userAttractionDatabase: [UserAttractionProvider]!
    let green = UIColor(red: 120.0/255.0, green: 205.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor as CGColor
    var userAttractions: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userAttractionDatabase.remove(at: 0)
        userAttractionDatabase.remove(at: 0)
        for i in 0..<userAttractionDatabase.count {
            print(userAttractionDatabase[i].rideID)
        }
        
        parkLabel.text = titleName
        self.attractionsTableView.delegate = self
        self.attractionsTableView.dataSource = self
        print(parkID)
        let urlPath = "http://www.beingpositioned.com/theparksman/attractiondbservice.php?parkid=\(parkID)"
        let dataModel = DataModel()
        // print ("There are ", feedItems.count, " attactions in park ", parkID)
        dataModel.delegate = self
        
        dataModel.downloadData(urlPath: urlPath, dataBase: "attractions")
        // Do any additional setup after loading the view, typically from a nib.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let alertController = UIAlertController(title: "Add Attraction", message: "Are you sure you want to add this attraction to your list?", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
            print ("Seclected Attraction is: ", (self.attractionListForTable[indexPath.row] as! AttractionsModel).rideID);
            
            (self.attractionListForTable[indexPath.row] as! AttractionsModel).isCheck = true;
            self.save(parkID: self.parkID, rideID: (self.attractionListForTable[indexPath.row] as! AttractionsModel).rideID);
            tableView.reloadData()
        }
        alertController.addAction(OKAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
        
        
        
       
     //   userAttractionDatabase.append(UserAttractionProvider(rideID: (attractionListForTable[indexPath.row] as! AttractionsModel).rideID, parkID: parkID))

        //print("SAVED ITEM: \(person.value(forKeyPath: "rideID")!)")
    }
    
    func itemsDownloaded(items: NSArray) {
        for i in 0..<items.count{
            attractionListForTable.add(items[i])
        }
        
        if (items.count == 0){
            print ("this park is empty")
        }
        else {
            if (userAttractionDatabase != nil){
                var userDataBaseIndex = 0
                let maxUserAttractionCount = userAttractionDatabase.count
                for i in 0..<attractionListForTable.count{
                    if userDataBaseIndex < maxUserAttractionCount{
                        if (attractionListForTable[i] as! AttractionsModel).rideID == userAttractionDatabase[userDataBaseIndex].rideID{
                            print ("We have ridden ride # ", userAttractionDatabase[userDataBaseIndex].rideID!)
                            (attractionListForTable[i] as! AttractionsModel).isCheck = true
                            userDataBaseIndex += 1
                        }
                        else{
                        }
                    }
                }
            }
        }
        self.attractionsTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attractionListForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCellIdentifier = "attractionCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: myCellIdentifier)!
        let item: AttractionsModel = attractionListForTable[indexPath.row] as! AttractionsModel
        if attractionListForTable.count != 1{
            if ((attractionListForTable[indexPath.row] as! AttractionsModel).isCheck){
                myCell.textLabel?.textColor = UIColor.green
            }
            else{
                myCell.textLabel?.textColor = UIColor.black
            }
            if (attractionListForTable[indexPath.row] as! AttractionsModel).active == 1 {
                myCell.backgroundColor = UIColor.white
            }
            else{
                myCell.backgroundColor = UIColor.lightGray
            }
        }
        myCell.textLabel!.text = item.name
        return myCell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save(parkID: Int, rideID: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "RideTrack",
                                                in: managedContext)!
        
        let newPark = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
        
        newPark.setValue(parkID, forKeyPath: "parkID")
        newPark.setValue(rideID, forKeyPath: "rideID")
        print("Just saved Attraction: ", rideID)
        do {
            try managedContext.save()
            userAttractions.append(newPark)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSuggest"{
            let suggestVC = segue.destination as! SuggestRideViewController
            //selectedPark = feedItems[selectedIndex!] as! ParksModel
            suggestVC.parkName = titleName
            suggestVC.parkID = parkID
        }
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
