//
//  SelectAttractionViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 10/13/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class SelectAttractionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataModelProtocol {

    @IBOutlet weak var selectAttractionTableView: UITableView!
    
    var attractionList = [AttractionsModel]()
    var selectedAttraction: AttractionsModel!
    var selectedPark: ParksList!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectAttractionTableView.dataSource = self
        selectAttractionTableView.delegate = self

        
        let urlPath = "http://www.beingpositioned.com/theparksman/attractiondbservice.php?parkid=\(selectedPark.parkID!)"
        let dataModel = DataModel()
        dataModel.delegate = self
        
        dataModel.downloadData(urlPath: urlPath, dataBase: "attractions", returnPath: "attractions")
        // Do any additional setup after loading the view.
    }
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        for i in 0..<items.count{
            attractionList.append(items[i] as! AttractionsModel)
        }
        attractionList.sort { ($0.active, $1.name) > ($1.active, $0.name)}
        selectAttractionTableView.reloadData()
        
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attractionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectAttraction", for: indexPath) as! SelectAttractionTableViewCell
        cell.attractionNameLabel.text = attractionList[indexPath.row].name
        cell.rideTypeLabel.text = convertRideTypeID(rideTypeID: attractionList[indexPath.row].rideType)
        return cell
    }
    
    func convertRideTypeID(rideTypeID: Int) -> String {
        switch rideTypeID {
        case -1:
            return ""
        case 1:
            return "Roller Coaster"
        case 2:
            return "Water Ride"
        case 3:
            return "Children's Ride"
        case 4:
            return "Flat Ride"
        case 5:
            return "Transport Ride"
        case 6:
            return "Dark Ride"
        case 7:
            return "Explore"
        case 8:
            return "Spectacular"
        case 9:
            return "Show"
        case 10:
            return "Film"
        case 11:
            return "Parade"
        case 12:
            return "Play Area"
        case 13:
            return "Upcharge"
        default:
            return ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "addNewAttractionToList") {
            if let indexPath = selectAttractionTableView.indexPathForSelectedRow {
                selectedAttraction = (attractionList[indexPath.row] )
            }
        }
        
    }

}
