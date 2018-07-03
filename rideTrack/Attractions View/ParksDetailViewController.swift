//
//  ParksDetailViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 7/2/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import MapKit

class ParksDetailViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var yearOpenLabel: UILabel!
    @IBOutlet weak var yearClosedLabel: UILabel!
    @IBOutlet weak var previousNameLabel: UILabel!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var parkTypeLabel: UILabel!
    @IBOutlet weak var yearClosedStack: UIStackView!
    @IBOutlet weak var previousNamesStack: UIStackView!
    @IBOutlet weak var yearOpenStack: UIStackView!
    
    var initialLocation: CLLocation!
    let regionRadius: CLLocationDistance = 1000
    var parksData: ParksModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configueLayout()
        initialLocation = CLLocation(latitude: parksData.latitude, longitude: parksData.longitude)
        centerMapOnLocation(location: initialLocation)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configueLayout(){
        parkNameLabel.text = parksData.name
        parkTypeLabel.text = parksData.type
        
        if parksData.yearOpen != 0{
            yearOpenLabel.text = String(parksData.yearOpen)
        } else{yearOpenStack.isHidden = true}
        
        if parksData.yearClosed != 0{
            yearClosedLabel.text = String(parksData.yearClosed)
        } else {yearClosedStack.isHidden = true}
        
        
        if parksData.perviousNames != ""{
            previousNameLabel.text = parksData.perviousNames
        } else{previousNamesStack.isHidden = true}
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toSuggestRide"{
            let suggestVC = segue.destination as! SuggestRideViewController
            suggestVC.parkName = parksData.name
            suggestVC.parkID = parksData.parkID
        }
        
    }
    

}
