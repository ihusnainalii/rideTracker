//
//  StatsViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 8/14/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import MapKit

class StatsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var allParksList = [ParksList]()
    var arrayOfAllParks = [ParksModel]()
    var simulateLocation: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView.delegate = self
        updateMap()
        // Do any additional setup after loading the view.
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toSettings"{
            let settingsVC = segue.destination as! SettingsViewController
            settingsVC.simulateLocation = simulateLocation
        }
    }
    

}

extension ViewController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? ParkMap else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            //view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
