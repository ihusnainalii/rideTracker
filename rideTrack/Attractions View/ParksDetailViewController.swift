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
import Firebase

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
    var favoiteParkList = [ParksList]()
    
    var parksListRef: DatabaseReference!
    var favoriteListRef: DatabaseReference!
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        let userID = Auth.auth().currentUser
        let id = userID?.uid
        self.parksListRef = Database.database().reference(withPath: "all-parks-list/\(id!) /\(parksData.name.lowercased())")
        self.favoriteListRef = Database.database().reference(withPath: "favorite-parks-list/\(id!) /\(parksData.name.lowercased())")
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
        parksListRef.updateChildValues([
            "incrementorEnabled": incrementorSwitch.isOn
            ])
        let favoriteIndex = findIndexFavoritesList(parkID: parksData.parkID)
        if favoriteIndex != -1{
            favoriteListRef.updateChildValues([
                "incrementorEnabled": incrementorSwitch.isOn
                ])
        }
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
    
    func findIndexFavoritesList(parkID: Int) -> Int{
        var favoritesIndex = -1
        for i in 0..<favoiteParkList.count{
            if favoiteParkList[i].parkID == parkID{
                favoritesIndex = i
                break
            }
        }
        return favoritesIndex
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
