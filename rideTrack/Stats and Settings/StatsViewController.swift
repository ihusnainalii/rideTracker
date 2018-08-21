//
//  StatsViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 8/14/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class StatsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var parkCountLabel: UILabel!
    @IBOutlet weak var attractionCountLabel: UILabel!
    @IBOutlet weak var parkCompleteCountLabel: UILabel!
    @IBOutlet weak var activeAttractionCountLabel: UILabel!
    @IBOutlet weak var defunctAttractionCountLabel: UILabel!
    @IBOutlet weak var experiencesCountLabel: UILabel!
    @IBOutlet weak var countriesCountLabel: UILabel!
    @IBOutlet weak var rollerCoasterCountLabel: UILabel!
    @IBOutlet weak var darkRideCountLabel: UILabel!
    @IBOutlet weak var waterRideCountLabel: UILabel!
    @IBOutlet weak var flatRideCountLabel: UILabel!
    @IBOutlet weak var showCountLabel: UILabel!
    @IBOutlet weak var filmCountLabel: UILabel!
    
    @IBOutlet weak var spectacularCountLabel: UILabel!
    var allParksList = [ParksList]()
    var arrayOfAllParks = [ParksModel]()
    var simulateLocation: Int!
    
    var statsListRef: DatabaseReference!
    var user: User!
    var statsFilter = "lifeTime"
    var stats: Stats!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        let userID = Auth.auth().currentUser
        let id = userID?.uid
        
        self.statsListRef = Database.database().reference(withPath: "stats-list/\(id!)/\(statsFilter)")
        
        statsListRef.observe(.value, with: { snapshot in
            var newStat: [Stats] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let statItem = Stats(snapshot: snapshot) {
                    newStat.append(statItem)
                }
            }
            print("Gettings stats-list")
           // self.stats = newStat[0]
        })
        
        
        
        //mapView.delegate = self
        updateMap()
        //updateStatLabels()
        // Do any additional setup after loading the view.
    }
    
    func updateStatLabels(){
        parkCountLabel.text = String(stats.parks)
        attractionCountLabel.text = String(stats.attractions)
        parkCompleteCountLabel.text = String(stats.parksCompleted)
        activeAttractionCountLabel.text = String(stats.activeAttractions)
        defunctAttractionCountLabel.text = String(stats.extinctAttracions)
        experiencesCountLabel.text = String(stats.experiences)
        countriesCountLabel.text = String(stats.countries)
        rollerCoasterCountLabel.text = String(stats.rollerCoasters)
        darkRideCountLabel.text = String(stats.darkRides)
        waterRideCountLabel.text = String(stats.waterRides)
        flatRideCountLabel.text = String(stats.flatRides)
        showCountLabel.text = String(stats.shows)
        spectacularCountLabel.text = String(stats.spectaculars)
        filmCountLabel.text = String(stats.films)
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
