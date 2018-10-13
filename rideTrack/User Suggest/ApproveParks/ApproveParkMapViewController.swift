//
//  ApproveParkMapViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 10/12/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import MapKit

class ApproveParkMapViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIView!
    
    var lat = 0.0
    var long = 0.0
    var is3DTouchAvailable: Bool {
        return view.traitCollection.forceTouchCapability == .available
    }
    var generator: UIImpactFeedbackGenerator!
    var popupGenerator: UIImpactFeedbackGenerator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("latitude: \(lat), Longitude: \(long)")
        saveButton.layer.cornerRadius = 7
        saveButton.isHidden = true
        saveButton.layer.shadowOpacity = 0.4
        saveButton.layer.shadowOffset = CGSize.zero
        saveButton.layer.shadowRadius = 9
        saveButton.layer.shadowColor = UIColor.black.cgColor
        
        //set up map to show where the user submitted
        let annotation  = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
        self.mapView.addAnnotation(annotation)
        
        //zoom in at location
        let coordinates:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        self.mapView.setRegion(region, animated: true)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(appPoint(longGesture:)))
        mapView.addGestureRecognizer(longGesture)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let activityInd = UIActivityIndicatorView()
        activityInd.style = .gray
        activityInd.center = self.view.center
        activityInd.hidesWhenStopped = true
        activityInd.startAnimating()
        
        self.view.addSubview(activityInd)
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchReqest = MKLocalSearch.Request()
        searchReqest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchReqest)
        activeSearch.start {(response, error) in
            activityInd.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                print ("ERROR")
            }
            else {
                self.saveButton.isHidden = false
                let annotationsOld = self.mapView.annotations
                self.mapView.removeAnnotations(annotationsOld)
                //get data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                //                self.lat = Double(latitude!)
                //                self.long = Double(longitude!)
                self.lat = Double(round(1000*Double(latitude!))/1000)
                self.long = Double(round(1000*Double(longitude!))/1000) //only show 3 decimal points
                print("latitude: \(self.lat), Longitude: \(self.long)")
                //create annotation
                let annotation  = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                //zoom in at location
                let coordinates:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinates, span: span)
                self.mapView.setRegion(region, animated: true)
                
            }
            
        }
        
    }
    @objc func appPoint(longGesture: UIGestureRecognizer) {
        let annotationsOld = mapView.annotations
        mapView.removeAnnotations(annotationsOld)
        let touchPoint = longGesture.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        mapView.addAnnotation(annotation)
        let longitude = annotation.coordinate.longitude
        let latitude = annotation.coordinate.latitude
        self.lat = Double(round(1000*Double(latitude))/1000)
        self.long = Double(round(1000*Double(longitude))/1000) //only show 3 decimal points
        print("latitude: \(lat), Longitude: \(long)")
        self.saveButton.isHidden = false
    }
    
    @IBAction func cancelButtonPresssed(_ sender: Any) {
      //  lat = 0.0
     //   long = 0.0
        self.performSegue(withIdentifier: "backtoApprovePark", sender: self)
    }
    
}
