//
//  ParksDetailViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 7/2/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import MapKit
import CoreData

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
    @IBOutlet weak var incrementorSwitch: UISwitch!
    
    var initialLocation: CLLocation!
    let regionRadius: CLLocationDistance = 1000
    var parksData: ParksModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configueLayout()
        incrementorSwitch.isOn = parksData.incrementorEnabled
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
    @IBAction func didToggleIncrementorSwitch(_ sender: Any) {
        parksData.incrementorEnabled = incrementorSwitch.isOn
        saveIncrementorChange(incrementorEnabled: incrementorSwitch.isOn)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    @IBAction func unwindToDetailsView(sender: UIStoryboardSegue) {
        print("Back to details view")
    }
    
    
    func saveIncrementorChange(incrementorEnabled: Bool){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ParkList")
        fetchRequest.predicate = NSPredicate(format: "parkID = %@", "\(parksData.parkID!)")
        do {
            let fetchedResults =  try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
            
            for entity in fetchedResults! {
                print("Setting incrementor enabled to \(incrementorEnabled)")
                entity.setValue(incrementorEnabled, forKey: "incrementorEnabled")
                try! managedContext.save()
            }
        }
        catch _ {
            print("Could not save favorite")
        }
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
