//
//  ParkSearchViewController.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/17/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit

class ParkSearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var parkArray: [ParksModel]!
    var selectedPark: ParksModel?
    var park = ParksModel()
    var firstEntry = true
    
    //A list of parks searched for, to display in results table
    var searchedParksList: [ParksModel]!
    
    @IBOutlet weak var searchTextFeild: UITextField!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var blurBackgroundView: UIVisualEffectView!
    @IBOutlet weak var searchView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurBackgroundView.layer.cornerRadius = 10
        parkArray.sort { $0.name < $1.name }
        searchTextFeild.becomeFirstResponder()
        searchedParksList = parkArray
        
        self.searchTextFeild.delegate = self
        self.resultsTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func didUpdateText(_ sender: Any) {
        searchedParksList.removeAll()
        for i in 0..<parkArray.count {
            park = parkArray[i] as! ParksModel
            firstEntry = true
            if (park.name.lowercased().range(of: searchTextFeild.text!.lowercased()) != nil){
                searchedParksList.append(park)
                firstEntry = false
            }
            //            if park.city.caseInsensitiveCompare(searchTextFeild.text!) == ComparisonResult.orderedSame{
            //                print("Match! \(park.name) ")
            //                searchedParksList.add(park)
            //            }
            
            //Not allow you to add duplicates
            if (park.city.lowercased().range(of: searchTextFeild.text!.lowercased()) != nil) && firstEntry{
                searchedParksList.append(park)
                firstEntry = false
            }
            if (park.country.lowercased().range(of: searchTextFeild.text!.lowercased()) != nil) && firstEntry{
                searchedParksList.append(park)
                firstEntry = false
            }
        }
        self.resultsTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        let item: ParksModel = searchedParksList[indexPath.row]
        cell.parkNameLabel.text = item.name
        cell.parkLocationLabel.text = item.city
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "addNewParkToList") {
            if let indexPath = resultsTableView.indexPathForSelectedRow {
                selectedPark = (searchedParksList[indexPath.row] )
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

