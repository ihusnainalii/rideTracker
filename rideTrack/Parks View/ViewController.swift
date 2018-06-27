//
//  ViewController.swift HELLOOOOO
//  Ride Track
//
//  Created by Mark Lawrence on 4/14/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//  last pushed: May 8, 1:30
//
import UIKit
import CoreData
import Foundation
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, DataModelProtocol, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var allParksTableView: UITableView!
    @IBOutlet weak var currentLocationView: UIView!
    @IBOutlet weak var currentLocationParkNameLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var favoritesView: UIView!
    @IBOutlet weak var allParksView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var addParkButton: UIButton!
    @IBOutlet weak var searchParkView: UIView!
    
    
    var selectedPark: ParksModel = ParksModel()
    var segueWithTableViewSelect = true
    
    var favoiteParkList = [ParksModel]()
    var allParksList = [ParksModel]()
    var selectedAttractionsList: [NSManagedObject] = []
    var savedParkList: [NSManagedObject] = []
    var arrayOfAllParks = [ParksModel]()
    
    var showExtinct = UserDefaults.standard.integer(forKey: "showExtinct")
    
    let screenSize = UIScreen.main.bounds
    var locationManager: CLLocationManager = CLLocationManager()
    var closestPark = ParksModel()
    let parksCoreData = ParkCoreData()
    
    
    override func viewDidLoad() {
        
        //Initialize current location UI
        currentLocationView.frame = CGRect(x: 0, y: Int(screenSize.height + 100), width: Int(screenSize.width), height: 100)
        currentLocationView.layer.shadowOffset = CGSize.zero
        currentLocationView.layer.shadowRadius = 5
        currentLocationView.layer.shadowOpacity = 0.3
        currentLocationView.layer.cornerRadius = 10
        
        let settingsColor = UIColor(red: 211/255.0, green: 213/255.0, blue: 215/255.0, alpha: 1.0)
        settingsButton.backgroundColor = settingsColor
        settingsButton.layer.cornerRadius = 7
        settingsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        navigationBar.layer.shadowOpacity = 0.5
        navigationBar.layer.shadowOffset = CGSize.zero
        navigationBar.layer.shadowRadius = 12
        
        favoritesView.layer.cornerRadius = 7
        favoritesTableView.layer.cornerRadius = 7
        
        allParksView.layer.cornerRadius = 7
        allParksTableView.layer.cornerRadius = 7
        
        addParkButton.layer.shadowOpacity = 0.5
        addParkButton.layer.shadowOffset = CGSize.zero
        addParkButton.layer.shadowRadius = 12
        
        searchParkView.layer.cornerRadius = 7
        
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        let lightGreen = UIColor(red: 38.0/255.0, green: 214.0/255.0, blue: 32.0/255.0, alpha: 1.0).cgColor
        let darkGreen = UIColor(red: 47.0/255.0, green: 104.0/255.0, blue: 40.0/255.0, alpha: 1.0).cgColor
        gradient.colors = [lightGreen, darkGreen]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        
        backgroundView.layer.addSublayer(gradient)
        
        super.viewDidLoad()
        
        favoritesTableView.isUserInteractionEnabled = true
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self

        allParksTableView.isUserInteractionEnabled = true
        allParksTableView.delegate = self
        allParksTableView.dataSource = self
        
        let urlPath = "http://www.beingpositioned.com/theparksman/parksdbservice.php"
        let dataModel = DataModel()
        dataModel.delegate = self
        dataModel.downloadData(urlPath: urlPath, dataBase: "parks", returnPath: "allParks")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        segueWithTableViewSelect = true
        super.viewWillAppear(animated)
        
        //Get ParkList data from CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "parkID", ascending: true)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ParkList")
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            savedParkList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch saved ParkList. \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        if returnPath == "countNumberOfRides"{
            var totalRideCount = 0
            let arrayOfAllRides = items as! [AttractionsModel]
            for i in 0..<arrayOfAllRides.count{
                if arrayOfAllRides[i].active == 1{
                    totalRideCount += 1
                    print(arrayOfAllRides[i].name)
                    print(totalRideCount)
                }
            }
            print(totalRideCount, "updating total ride count label...")
            
            if arrayOfAllRides.count != 0{
                parksCoreData.updatingTotalRideCount(parkID: arrayOfAllRides[0].parkID, totalRideCount: totalRideCount)
                for i in 0..<allParksList.count{
                    if allParksList[i].parkID == arrayOfAllRides[0].parkID{
                        allParksList[i].totalRides = totalRideCount
                        break
                    }
                }
                allParksTableView.reloadData()
                favoritesTableView.reloadData()
            }
            
        }
        else{
            arrayOfAllParks = items as! [ParksModel]
            var userParkListIncrementor = 0
            var allParksIncrementor = 0
            
            if savedParkList.count != 0{
                //Like a do while loop- loop until just before the saved park incrementor goes out of index
                repeat {
                    //Check if the rideID in allParks matches that of savedParkList
                    if arrayOfAllParks[allParksIncrementor].parkID == savedParkList[userParkListIncrementor].value(forKey: "parkID") as! Int{
                        let addingPark = arrayOfAllParks[allParksIncrementor]
                        addingPark.favorite = savedParkList[userParkListIncrementor].value(forKey: "favorite") as! Bool
                        addingPark.totalRides = savedParkList[userParkListIncrementor].value(forKey: "totalRides") as! Int
                        addingPark.ridesRidden = savedParkList[userParkListIncrementor].value(forKey: "ridesRidden") as! Int
                        allParksList.append(addingPark)
                        userParkListIncrementor += 1
                        
                        if addingPark.favorite{
                            favoiteParkList.append(addingPark)
                        }
                    }
                    allParksIncrementor += 1
                } while userParkListIncrementor < savedParkList.count
            }
            
            
            allParksList.sort { $0.name < $1.name }
            favoiteParkList.sort { $0.name < $1.name }
            
            favoritesTableView.reloadData()
            allParksTableView.reloadData()
            
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.requestLocation()
            print("GETTING GPS DATA")
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if tableView == self.favoritesTableView {
            rowCount = favoiteParkList.count
        }
        if tableView == self.allParksTableView {
            rowCount =  allParksList.count
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.favoritesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoritesTableViewCell
            let parkData = favoiteParkList[indexPath.row]
            cell.parkNameLabel.text = parkData.name
            cell.locationLabel.text = parkData.city
            cell.fractionLabel.text = "\(parkData.ridesRidden!)/\(parkData.totalRides!)"
            
            let rides: Double = Double(parkData.ridesRidden)
            let total = Double(parkData.totalRides)
            var progressToShow = CGFloat(0)
            if total != 0{
                progressToShow = CGFloat(Double(cell.progressWidth + 4) * (rides/total))
                if rides/total == 1{
                    cell.progressView.backgroundColor = UIColor(red: 218.0/255.0, green: 195.0/255.0, blue: 32.0/255.0, alpha: 1.0)
                } else{
                    cell.progressView.backgroundColor = UIColor(red: 74.0/255.0, green: 166.0/255.0, blue: 65.0/255.0, alpha: 1.0)
                }
            }
            cell.progressView.frame.size.width = progressToShow
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "allCell", for: indexPath) as! AllParksTableViewCell
            let parkData = allParksList[indexPath.row]
            cell.parkNameLabel.text = parkData.name
            cell.locationLabel.text = parkData.city
            cell.fractionLabel.text = "\(parkData.ridesRidden!)/\(parkData.totalRides!)"
            
            let rides: Double = Double(parkData.ridesRidden)
            let total = Double(parkData.totalRides)
            var progressToShow = CGFloat(0)
            if total != 0{
                progressToShow = CGFloat(Double(cell.progressWidth + 4) * (rides/total))
                if rides/total == 1{
                    cell.progressView.backgroundColor = UIColor(red: 218.0/255.0, green: 195.0/255.0, blue: 32.0/255.0, alpha: 1.0)
                } else{
                    cell.progressView.backgroundColor = UIColor(red: 74.0/255.0, green: 166.0/255.0, blue: 65.0/255.0, alpha: 1.0)
                }
            }
            cell.progressView.frame.size.width = progressToShow
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favoriteAction = UIContextualAction(style: .normal, title:  "Favorites", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if tableView == self.favoritesTableView {
                let index = self.findIndexInAllParksList(parkID: self.favoiteParkList[indexPath.row].parkID)
                self.allParksList[index].favorite = false
                self.parksCoreData.saveFavoritesChange(modifyedPark: self.allParksList[index], add: false)
                self.favoiteParkList.remove(at: indexPath.row)
            } else{
                //Only add if it isn't already a favorite
                if !self.allParksList[indexPath.row].favorite{
                    self.allParksList[indexPath.row].favorite = true
                    self.favoiteParkList.append(self.allParksList[indexPath.row])
                    self.parksCoreData.saveFavoritesChange(modifyedPark: self.allParksList[indexPath.row], add: true)
                }
            }
            success(true)
            self.favoritesTableView.perform(#selector(self.favoritesTableView.reloadData), with: nil, afterDelay: 0.3)
        })
        
        if tableView == self.favoritesTableView {
            favoriteAction.title = "Remove from favorites"
        } else{
            if allParksList[indexPath.row].favorite{
                favoriteAction.title = "Already a favorite"
            }else{
                favoriteAction.title = "Add to favorites"
            }
        }
        let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive, title:  "removePark", handler: { (ac:UIContextualAction, view:UIView, success:@escaping (Bool) -> Void) in
            let deleteAlertController = UIAlertController(title: "Delete Park", message: "Are you sure you want to remove this park from your list? This will remove all assosicated park data along with it, including all rides checked off, the number of times each ride has been ridden, and the dates you rode each ride", preferredStyle: .alert)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) -> Void in
                success(true)
                self.removeParkFromList(parkID: self.allParksList[indexPath.row].parkID, indexPath: indexPath.row)
                self.favoritesTableView.reloadData()
                self.allParksTableView.reloadData()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                success(false)
            }
            deleteAlertController.addAction(cancel)
            deleteAlertController.addAction(delete)
            self.present(deleteAlertController, animated: true, completion:nil)
        })
        
        if tableView == self.allParksTableView {
            removeAction.title = "Remove park from list"
            let configuration = UISwipeActionsConfiguration(actions: [removeAction])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
        } else{
            return UISwipeActionsConfiguration.init()
        }
        
    }
    
    func addNewParkToList(newPark: ParksModel) {
        if checkIfNewPark(newPark: newPark){
            
            //Adding defualt user saved data values
            newPark.favorite = false
            newPark.totalRides = 0
            newPark.ridesRidden = 0
            
            allParksList.append(newPark)
            self.allParksTableView.reloadData()
            self.parksCoreData.saveNewItemToParkList(parkID: newPark.parkID)
            
            //Get total number of rides, need to call database
            let urlPath = "http://www.beingpositioned.com/theparksman/attractiondbservice.php?parkid=\(newPark.parkID!)"
            let dataModel = DataModel()
            dataModel.delegate = self
            dataModel.downloadData(urlPath: urlPath, dataBase: "attractions", returnPath: "countNumberOfRides")
            print("new park saved: ", newPark.parkID)
        }
        else{
            print("Can not add a park twice")
        }
    }
    
    
    func removeParkFromList(parkID: Int, indexPath: Int) {
        //Deletes from both RideTrack and ParkList entities
        parksCoreData.deletePark(parkID: parkID)
        
        //Check if it is in user's favorites list, if so delete it
        for i in 0..<favoiteParkList.count{
            if favoiteParkList[i].parkID == parkID{
                favoiteParkList.remove(at: i)
                break
            }
        }
        allParksList.remove(at: indexPath)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAttractionsAll" || segue.identifier == "toAttractionsFavorites"{
            //Re write this to simplify calling RideTrack coreData only here, while going to Attractions view
            let attractionVC = segue.destination as! AttractionsViewController
            
            if segueWithTableViewSelect && segue.identifier == "toAttractionsAll"{
                let selectedIndex = (allParksTableView.indexPathForSelectedRow?.row)!
                selectedPark = allParksList[selectedIndex]
                print ("going to attractions")
            } else{
                let selectedIndex = (favoritesTableView.indexPathForSelectedRow?.row)!
                selectedPark = favoiteParkList[selectedIndex]
            }
            
            print ("The park is ", selectedPark.name)
            attractionVC.titleName = selectedPark.name
            attractionVC.parkID = selectedPark.parkID
            attractionVC.showExtinct = showExtinct
            
            //Getting coreData Attraction data for the selected park
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let sortDescriptor = NSSortDescriptor(key: "rideID", ascending: true)
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RideTrack")
            fetchRequest.predicate = NSPredicate(format: "parkID = %@", "\(selectedPark.parkID!)")
            fetchRequest.sortDescriptors = [sortDescriptor]
            do {
                selectedAttractionsList = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch saved ParkList. \(error), \(error.userInfo)")
            }
            var userAttractions: [UserAttractionProvider] = []
            for i in 0..<selectedAttractionsList.count{
                let newAttraction = UserAttractionProvider()
                newAttraction.dateFirstRidden = selectedAttractionsList[i].value(forKeyPath: "firstRideDate") as! Date
                newAttraction.dateLastRidden = selectedAttractionsList[i].value(forKeyPath: "lastRideDate") as! Date
                newAttraction.numberOfTimesRidden = selectedAttractionsList[i].value(forKeyPath: "numberOfTimesRidden") as! Int
                newAttraction.parkID = selectedAttractionsList[i].value(forKeyPath: "parkID") as! Int
                newAttraction.rideID = selectedAttractionsList[i].value(forKeyPath: "rideID") as! Int
                userAttractions.append(newAttraction)
            }
            attractionVC.userAttractionDatabase = userAttractions
            
            print("count: ", userAttractions.count)
        }
        
        if segue.identifier == "toSearch"{
            let searchVC = segue.destination as! ParkSearchViewController
            searchVC.parkArray = arrayOfAllParks as NSArray
        }
        if segue.identifier == "toSettings"{
            let settingVC = segue.destination as! SettingsViewController
            settingVC.showExtinct = showExtinct
        }
    }
    
    
    
    @IBAction func unwindToParkList(segue:UIStoryboardSegue) {
        if segue.source is SettingsViewController{
            print ("BACK FROM SETTINGS")
        }
        else if let sourceViewController = segue.source as? ParkSearchViewController, let newPark = sourceViewController.selectedPark{
            addNewParkToList(newPark: newPark)
        }
        else if segue.source is AttractionsViewController{
            print("Back from attractions")

        }
    }
    
    func checkIfNewPark(newPark: ParksModel) -> Bool {
        var isNewPark = true
        for i in 0..<allParksList.count{
            if newPark.parkID == allParksList[i].parkID{
                isNewPark = false
            }
        }
        return isNewPark
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            var latitude = location.coordinate.latitude
            var longitude = location.coordinate.longitude
            var oneMileParks = [ParksModel]()
            
            //Simulate you are at Epcot
            //            latitude = 28.3667
            //            longitude = -81.5495
            
            //Simulate you are in Magic Kingdom
//            latitude = 28.4161
//            longitude = -81.5811
            
            let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
            for i in 0..<arrayOfAllParks.count{
                
                //distance is in meters, so if the distance is less than 1 mile, or 1609 meters, print that
                if currentLocation.distance(from: arrayOfAllParks[i].getLocation()) < 1609 {
                    print("User is within one mile of \(arrayOfAllParks[i].name!)")
                    oneMileParks.append(arrayOfAllParks[i])
                }
            }
            if oneMileParks.count != 0{
                
                //There is more than 1 park within a mile of the user. Find the closests park to present to user
                var closestParkTemp = currentLocation.distance(from: oneMileParks[0].getLocation())
                closestPark = oneMileParks[0]
                for i in 0..<oneMileParks.count{
                    if currentLocation.distance(from: oneMileParks[i].getLocation()) < closestParkTemp{
                        closestParkTemp = currentLocation.distance(from: oneMileParks[i].getLocation())
                        closestPark = oneMileParks[i]
                    }
                }
                print("Closest park is \(closestPark.name!)")
                
                //Begin animating the UI with the new current location park
                currentLocationParkNameLabel.text = closestPark.name!
                UIView.animate(withDuration: 0.6, animations: {
                    self.currentLocationView.frame = CGRect(x: 0, y: Int(self.screenSize.height - 100), width: Int(self.screenSize.width), height: 100)
                })
                
            }
        }
    }
    
    @IBAction func showCurrentlLocationPark(_ sender: Any) {
        if checkIfNewPark(newPark: closestPark){
            addNewParkToList(newPark: closestPark)
        }
        segueWithTableViewSelect = false
        selectedPark = closestPark
        performSegue(withIdentifier: "toAttractions", sender: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
    
    func unwindFromAttractions(parkID: Int) {
        segueWithTableViewSelect = true
        
        //Get ParkList data from CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "parkID", ascending: true)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ParkList")
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            savedParkList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch saved ParkList. \(error), \(error.userInfo)")
        }
    }
    
    func findIndexInAllParksList(parkID:Int) -> Int{
        var allParksIndex = 0
        for i in 0..<allParksList.count{
            if allParksList[i].parkID == parkID{
                allParksIndex = i
                break
            }
        }
        return allParksIndex
    }
}

