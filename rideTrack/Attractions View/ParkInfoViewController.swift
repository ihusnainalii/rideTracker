//
//  ParkInfoViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 8/26/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import MapKit

class ParkInfoViewController: UIViewController {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var parkTypeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var previousNamesLabel: UILabel!
    @IBOutlet weak var yearOpenLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var yearClosedLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var mapBackgroundView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var previousNamesStack: UIStackView!
    @IBOutlet weak var yearOpenStack: UIStackView!
    @IBOutlet weak var yearClosedStack: UIStackView!
    @IBOutlet weak var statusStack: UIStackView!
    @IBOutlet weak var parkNameTopConstrant: NSLayoutConstraint!
    @IBOutlet weak var doneButtonTopConstrant: NSLayoutConstraint!
    
    
    var parksData: ParksModel!
    let settingsColor = UIColor(red: 211/255.0, green: 213/255.0, blue: 215/255.0, alpha: 1.0)
    var initialLocation: CLLocation!
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        initialLocation = CLLocation(latitude: parksData.latitude, longitude: parksData.longitude)
        centerMapOnLocation(location: initialLocation)
        if UIScreen.main.bounds.height == 812.0{
            parkNameTopConstrant.constant = 29
            doneButtonTopConstrant.constant = 35
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView(){
        parkNameLabel.text = parksData.name
        parkTypeLabel.text = parksData.type
        locationLabel.text = "\(parksData.city!), \(parksData.country!)"
        yearOpenLabel.text = String(parksData.yearOpen)
        
        if parksData.perviousNames == ""{
            print("No old names")
            previousNamesStack.isHidden = true
        } else{
            previousNamesLabel.text = parksData.perviousNames
        }
        if parksData.active == 1{
            yearClosedStack.isHidden = true
            statusLabel.text = "Operating"
        } else{
            yearClosedLabel.text = String(parksData.yearClosed)
            statusLabel.text = "Closed"
        }
        addShadowAndRoundRec(uiView: infoView)
        addShadowAndRoundRec(uiView: mapBackgroundView)
        doneButton.backgroundColor = settingsColor
        doneButton.layer.cornerRadius = 5
        doneButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let parkMapAnnotation = ParkMap(parkName: parksData.name, longitude: parksData.longitude, latitude: parksData.latitude)
        mapView.addAnnotation(parkMapAnnotation)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addShadowAndRoundRec(uiView: UIView){
        uiView.layer.cornerRadius = 7
        uiView.layer.shadowOpacity = 0.3
        uiView.layer.shadowOffset = CGSize.zero
        uiView.layer.shadowRadius = 5
        uiView.layer.backgroundColor = UIColor.white.cgColor
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
