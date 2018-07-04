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
    
    let screenSize = UIScreen.main.bounds

    
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
    @IBOutlet weak var viewAttractionLocationButton: UIButton!
    @IBOutlet weak var parksLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var myParksLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    @IBOutlet weak var settingsButtonHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var settingsButtonWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var navBarHeightConstants: NSLayoutConstraint!
    @IBOutlet weak var addParkHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var currentLocationViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchRideButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoritesViewHeightConstrant: NSLayoutConstraint!
    var favoitesHeight: CGFloat = 190.0
    
    var selectedPark: ParksModel = ParksModel()
    var segueWithTableViewSelect = true
    
    var favoiteParkList = [ParksModel]()
    var allParksList = [ParksModel]()
    var selectedAttractionsList: [NSManagedObject] = []
    var savedParkList: [NSManagedObject] = []
    var arrayOfAllParks = [ParksModel]()
    
    var showExtinct = UserDefaults.standard.integer(forKey: "showExtinct")
    var simulateLocation = UserDefaults.standard.integer(forKey: "simulateLocation")
    
    var locationManager: CLLocationManager = CLLocationManager()
    var closestPark = ParksModel()
    let parksCoreData = ParkCoreData()
    let settingsColor = UIColor(red: 211/255.0, green: 213/255.0, blue: 215/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        
        print(screenSize.width)
        
        //If iPhone 5s
        if screenSize.width == 320.0{
            ConfigureSmallerLayout().configureParksView(parksView: self)
        }
        
        
        print(favoitesHeight)
        
        
        //Initialize current location UI
        currentLocationView.layer.shadowOffset = CGSize.zero
        currentLocationView.layer.shadowRadius = 5
        currentLocationView.layer.shadowOpacity = 0.3
        currentLocationView.layer.cornerRadius = 10
        currentLocationViewBottomConstraint.constant = -61
        
        viewAttractionLocationButton.backgroundColor = settingsColor
        viewAttractionLocationButton.layer.cornerRadius = 7
        viewAttractionLocationButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        
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
        
        //Returns the number of total rides in the park, for the fraction view
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
            
        //Gets all the parks from the database, sets up the favoritesList and allMyParksList
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
            
            var allParksViewTableAlpha: CGFloat = 1.0
            var favoritesTableAlpha: CGFloat = 1.0

            if favoiteParkList.count == 0{
                favoritesViewHeightConstrant.constant = 70
                favoritesTableAlpha = 0.0
            }
            if allParksList.count == 0{
                allParksViewTableAlpha = 0.0
            }
            UIView.animate(withDuration: 0.6, animations: {
                self.favoritesTableView.alpha = favoritesTableAlpha
                self.allParksTableView.alpha = allParksViewTableAlpha
                self.view.layoutIfNeeded()
            })
            
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
        //Sets up favoites table
        if tableView == self.favoritesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoritesTableViewCell
            let parkData = favoiteParkList[indexPath.row]
            cell.parkNameLabel.text = parkData.name
            cell.locationLabel.text = parkData.city
            cell.fractionLabel.text = "\(parkData.ridesRidden!)/\(parkData.totalRides!)"
            
            if screenSize.width == 320.0{
                ConfigureSmallerLayout().favoriteCellLayout(favoriteCell: cell)
            }
            
            let rides: Double = Double(parkData.ridesRidden)
            let total = Double(parkData.totalRides)
            var progressToShow = CGFloat(0)
            if total != 0{
                progressToShow = CGFloat(Double(cell.progressViewWidth.constant) * (rides/total))
                if rides/total == 1{
                    cell.progressView.backgroundColor = UIColor(red: 218.0/255.0, green: 195.0/255.0, blue: 32.0/255.0, alpha: 1.0)
                } else{
                    cell.progressView.backgroundColor = UIColor(red: 74.0/255.0, green: 166.0/255.0, blue: 65.0/255.0, alpha: 1.0)
                }
            }
            cell.progressView.frame.size.width = progressToShow
            
            return cell
        }
            
        //sets up all parks table
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "allCell", for: indexPath) as! AllParksTableViewCell
            let parkData = allParksList[indexPath.row]
            cell.parkNameLabel.text = parkData.name
            cell.locationLabel.text = parkData.city
            cell.fractionLabel.text = "\(parkData.ridesRidden!)/\(parkData.totalRides!)"
            
            if screenSize.width == 320.0{
                ConfigureSmallerLayout().allParksCellLayout(allParksCell: cell)
            }
            
            
            let rides: Double = Double(parkData.ridesRidden)
            let total = Double(parkData.totalRides)
            var progressToShow = CGFloat(0)
            if total != 0{
                progressToShow = CGFloat(Double(cell.fractionViewWidth.constant) * (rides/total))
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
        
        //Add/remove ride to favorites list
        let favoriteAction = UIContextualAction(style: .normal, title:  "Favorites", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if tableView == self.favoritesTableView {
                let index = self.findIndexInAllParksList(parkID: self.favoiteParkList[indexPath.row].parkID)
                self.allParksList[index].favorite = false
                self.parksCoreData.saveFavoritesChange(modifyedPark: self.allParksList[index], add: false)
                self.favoiteParkList.remove(at: indexPath.row)
                
                //Animate away favorites view to dissappear if the last park is being removed from the list
                if self.favoiteParkList.count == 0{
                    //Need to get this value to work for all devices
                    self.favoritesViewHeightConstrant.constant = 70
                    UIView.animate(withDuration: 0.6, animations: {
                        self.favoritesTableView.alpha = 0.0
                        self.view.layoutIfNeeded()
                    })
                }
                
                
                self.favoritesTableView.deleteRows(at: [indexPath], with: .left)
            } else{
                //Only add if it isn't already a favorite
                if !self.allParksList[indexPath.row].favorite{
                    self.allParksList[indexPath.row].favorite = true
                    self.parksCoreData.saveFavoritesChange(modifyedPark: self.allParksList[indexPath.row], add: true)
                    
                    //Animate the favorites view to appear if the first park is being added to the list
                    if self.favoiteParkList.count == 0{
                        //Need to get this value to work for all devices
                        self.favoritesViewHeightConstrant.constant = self.favoitesHeight
                        UIView.animate(withDuration: 0.6, animations: {
                            self.favoritesTableView.alpha = 1.0
                            self.view.layoutIfNeeded()
                        })
                    }
   
                    self.favoritesTableView.beginUpdates()
                    self.favoiteParkList.append(self.allParksList[indexPath.row])
                    let indexPath:IndexPath = IndexPath(row:(self.favoiteParkList.count - 1), section:0)
                    self.favoritesTableView.insertRows(at: [indexPath], with: .automatic)
                    self.favoritesTableView.endUpdates()
                    
                }
                
            }
            success(true)
        })
        
        if tableView == self.favoritesTableView {
            favoriteAction.title = "Remove from favorites"
        } else{
            print("INDEX PATH ", indexPath.row)
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
    
    //Remove park from list (only allowed to do this from all parks list)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive, title:  "removePark", handler: { (ac:UIContextualAction, view:UIView, success:@escaping (Bool) -> Void) in
            let deleteAlertController = UIAlertController(title: "Delete Park", message: "Are you sure you want to remove this park from your list? This will remove all assosicated park data along with it, including all rides checked off, the number of times each ride has been ridden, and the dates you rode each ride", preferredStyle: .alert)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) -> Void in
                success(true)
                print(self.allParksList[indexPath.row].parkID)
                self.removeParkFromList(parkID: self.allParksList[indexPath.row].parkID, indexPath: indexPath.row)
                
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

            //Animate in the all parks table veiw when adding the first park
            if allParksList.count == 0{
                UIView.animate(withDuration: 0.6, animations: {
                    self.allParksTableView.alpha = 1.0
                })
            }
            
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
                favoritesTableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: .left)
                break
            }
        }
        
        allParksList.remove(at: indexPath)
        
        print("Animate delete")
        
        allParksTableView.reloadData()
        favoritesTableView.reloadData()
        
        //Animate away favorites view to dissappear if the last park is being removed from the list
        var allParksViewTableAlpha: CGFloat = 1.0
        var favoritesTableAlpha: CGFloat = 1.0

        if favoiteParkList.count == 0{
            favoritesViewHeightConstrant.constant = 70
            favoritesTableAlpha = 0.0
        }
        if allParksList.count == 0{
            allParksViewTableAlpha = 0.0
        }
        UIView.animate(withDuration: 0.6, animations: {
            self.favoritesTableView.alpha = favoritesTableAlpha
            self.allParksTableView.alpha = allParksViewTableAlpha
            self.view.layoutIfNeeded()
        })
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAttractionsAll" || segue.identifier == "toAttractionsFavorites"{
            //Re write this to simplify calling RideTrack coreData only here, while going to Attractions view
            let attractionVC = segue.destination as! AttractionsViewController
            print("SEGUE")
            if segueWithTableViewSelect && segue.identifier == "toAttractionsAll"{
                let selectedIndex = (allParksTableView.indexPathForSelectedRow?.row)!
                selectedPark = allParksList[selectedIndex]
                print ("going to attractions")
            } else if segueWithTableViewSelect && segue.identifier == "toAttractionsFavorites"{
                let selectedIndex = (favoritesTableView.indexPathForSelectedRow?.row)!
                selectedPark = favoiteParkList[selectedIndex]
            }
            
            print ("The park is ", selectedPark.name)
            attractionVC.titleName = selectedPark.name
            attractionVC.parkID = selectedPark.parkID
            attractionVC.showExtinct = showExtinct
            attractionVC.parksViewController = self
            attractionVC.parkData = selectedPark
            
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
            searchVC.parkArray = arrayOfAllParks
            
        }
        if segue.identifier == "toSettings"{
            let settingVC = segue.destination as! SettingsViewController
            settingVC.showExtinct = showExtinct
            settingVC.simulateLocation = simulateLocation
        }
    }
    
    
    
    @IBAction func unwindToParkList(segue:UIStoryboardSegue) {
        if segue.source is SettingsViewController{
        }
        else if let sourceViewController = segue.source as? ParkSearchViewController, let newPark = sourceViewController.selectedPark{
            addNewParkToList(newPark: newPark)
            
        }
        else if segue.source is AttractionsViewController{
            print("DO NOT USE THIS, IT WILL NOT UPDATE THE FRACTIONS. INSTEAD CALL THE UNWIND METHOD")
           

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
            print("Simulate", simulateLocation)
            if simulateLocation == 1{
                latitude = 28.4161
                longitude = -81.5811
            }
            
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
                
                self.currentLocationParkNameLabel.text = self.closestPark.name!
                self.view.layoutIfNeeded()
                //Begin animating the UI with the new current location park
                self.searchRideButtonHeightConstraint.constant = 50
                self.currentLocationViewBottomConstraint.constant = -4

                UIView.animate(withDuration: 0.6, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    

    @IBAction func showCurrentlLocationPark(_ sender: Any) {
        
        if checkIfNewPark(newPark: closestPark){
            print("new park")
            addNewParkToList(newPark: closestPark)
        } else{
            print("old")
        }
        
        segueWithTableViewSelect = false
        selectedPark = closestPark
        performSegue(withIdentifier: "toAttractionsAll", sender: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
    
    func unwindFromAttractions(parkID: Int) {
        segueWithTableViewSelect = true
        print("unwinding")
        //Get ParkList data from CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ParkList")
        fetchRequest.predicate = NSPredicate(format: "parkID = %@", "\(parkID)")
        var updatedPark:[NSManagedObject] = []
        do {
            updatedPark = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch saved ParkList. \(error), \(error.userInfo)")
        }
        
        let allParksIndex = findIndexInAllParksList(parkID: parkID)
        allParksList[allParksIndex].totalRides = updatedPark[0].value(forKey: "totalRides") as! Int
        allParksList[allParksIndex].ridesRidden = updatedPark[0].value(forKey: "ridesRidden") as! Int
        
        if favoiteParkList.count != 0{
            let favoritesIndex = findIndexFavoritesList(parkID: parkID)
            if favoritesIndex != -1{
                favoiteParkList[favoritesIndex].totalRides = updatedPark[0].value(forKey: "totalRides") as! Int
                favoiteParkList[favoritesIndex].ridesRidden = updatedPark[0].value(forKey: "ridesRidden") as! Int
                favoritesTableView.reloadData()
            }
        }
        allParksTableView.reloadData()
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

