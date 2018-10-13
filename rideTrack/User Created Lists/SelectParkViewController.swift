//
//  SelectParkViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 10/13/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class SelectParkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

 
    @IBOutlet weak var allParkTableView: UITableView!
    
    var allParksList = [ParksList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        allParkTableView.delegate = self
        allParkTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allParksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectPark", for: indexPath) as! SelectParkTableViewCell
        cell.parkNameLabel.text = allParksList[indexPath.row].name
        cell.locationLabel.text = allParksList[indexPath.row].location
        return cell

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSelectAttraction"{
            let selectAttractionVC = segue.destination as! SelectAttractionViewController
            let selectedIndex = allParkTableView.indexPathForSelectedRow?.row
            selectAttractionVC.selectedPark = allParksList[selectedIndex!]
           
        }
        
    }

}
