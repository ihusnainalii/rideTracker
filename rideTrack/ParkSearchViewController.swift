//
//  ParkSearchViewController.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/17/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit

class ParkSearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var parkArray:NSArray = NSArray()
    var selectedPark: ParksModel?
    var park = ParksModel()
    var firstEntry = true
    
    //A list of parks searched for, to display in results table
    var searchedParksList: NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var searchTextFeild: UITextField!
    @IBOutlet weak var resultsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextFeild.becomeFirstResponder()
        self.searchTextFeild.delegate = self
        self.resultsTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchedParksList.removeAllObjects()
        print(parkArray.count)
        for i in 0..<parkArray.count {
            park = parkArray[i] as! ParksModel
            firstEntry = true
            if (park.name.lowercased().range(of: searchTextFeild.text!.lowercased()) != nil){
                print("name match! \(park.name!) ")
                searchedParksList.add(park)
                firstEntry = false
            }
//            if park.city.caseInsensitiveCompare(searchTextFeild.text!) == ComparisonResult.orderedSame{
//                print("Match! \(park.name) ")
//                searchedParksList.add(park)
//            }
            
            //Not allow you to add duplicates
            if (park.city.lowercased().range(of: searchTextFeild.text!.lowercased()) != nil) && firstEntry{
                print("state/city match! \(park.name!) ")
                searchedParksList.add(park)
                firstEntry = false
            }
            if (park.country.lowercased().range(of: searchTextFeild.text!.lowercased()) != nil) && firstEntry{
                print("country match! \(park.name!) ")
                searchedParksList.add(park)
                firstEntry = false
            }
        }
        print(searchedParksList.count)
        self.resultsTableView.reloadData()
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedParksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchedParkCell", for: indexPath) as! SearchTableViewCell
        let item: ParksModel = searchedParksList[indexPath.row] as! ParksModel
        cell.parkNameLabel.text = item.name
        cell.parkLocationLabel.text = item.city
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "addNewParkToList") {
            if let indexPath = resultsTableView.indexPathForSelectedRow {
                selectedPark = (searchedParksList[indexPath.row] as! ParksModel)
            }
        }
        
        if (segue.identifier == "cancel") {
            print("CANCEL")
            selectedPark = nil
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

