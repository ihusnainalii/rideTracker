//
//  MapViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 8/24/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var allParksList = [ParksList]()
    var arrayOfAllParks = [ParksModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMap()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateMap(){
        allParksList.sort { $0.parkID < $1.parkID }
        arrayOfAllParks.sort { $0.parkID < $1.parkID }
        var allParksIndex = 0
        var myParksIndex = 0
        repeat {
            if allParksList[myParksIndex].parkID == arrayOfAllParks[allParksIndex].parkID{
                myParksIndex += 1
                
                //Set up map view here
                let parkMapAnnotation = ParkMap(parkName: arrayOfAllParks[allParksIndex].name, longitude: arrayOfAllParks[allParksIndex].longitude, latitude: arrayOfAllParks[allParksIndex].latitude)
                mapView.addAnnotation(parkMapAnnotation)
            }
            allParksIndex += 1
        } while myParksIndex < allParksList.count
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
