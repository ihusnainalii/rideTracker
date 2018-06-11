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


class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, DataModelProtocol, NSFetchedResultsControllerDelegate, ParkTableViewCellDelegate {
    
    
    
    @IBOutlet weak var listTableView: UITableView!
    
    
    var arrayOfAllParks = [ParksModel]()
    var selectedPark: ParksModel = ParksModel()
    var titleTest = "test"
    var usersParkList = [ParksModel]()
    var park = ParksModel()
    var downloadIncrementor = 0
   // var showExtinct = 0
    var showExtinct = UserDefaults.standard.integer(forKey: "showExtinct")
    var showPayed = UserDefaults.standard.integer(forKey: "shoPayed")
    //var parkListData: [ParkListData] = UserDefaults.standard.array(forKey: "parkListData") as! [ParkListData]

    var segueWithTableViewSelect = true
    var selectedIndex = 0
    
    @IBOutlet weak var currentLocationView: UIView!
    @IBOutlet weak var currentLocationParkNameLabel: UILabel!
    var closestPark = ParksModel()

    
    var userAttractionDatabase: [[UserAttractionProvider]] = [[]]
    var userAttractions: [NSManagedObject] = []
    
    var fetchRequest: NSFetchedResultsController<RideTrack>? = nil
    var managedContext: NSManagedObjectContext? = nil
    let screenSize = UIScreen.main.bounds

    var locationManager: CLLocationManager = CLLocationManager()
    
    var latitude: Double?
    var longitude: Double?
    


    override func viewDidLoad() {
        
        //Initialize current location UI
        currentLocationView.frame = CGRect(x: 0, y: Int(screenSize.height + 100), width: Int(screenSize.width), height: 100)
        currentLocationView.layer.shadowOffset = CGSize.zero
        currentLocationView.layer.shadowRadius = 12
        currentLocationView.layer.shadowOpacity = 0.3
        currentLocationView.layer.cornerRadius = 10
        
        listTableView.isUserInteractionEnabled = true
        super.viewDidLoad()
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let urlPath = "http://www.beingpositioned.com/theparksman/parksdbservice.php"
        
        let dataModel = DataModel()
        dataModel.delegate = self
        dataModel.downloadData(urlPath: urlPath, dataBase: "parks")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print ("AT TOP, ShowExtinct is ", showExtinct)
        segueWithTableViewSelect = true

        print("VIEW WILL APPEAR RAN")
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "parkID", ascending: true)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RideTrack")
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            userAttractions = try managedContext.fetch(fetchRequest)
            dataMigrationToList()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func itemsDownloaded(items: NSArray) {
        
        
        arrayOfAllParks = items as! [ParksModel]
        
        //Adds parks the user has already saved to the table list
        //        for i in 0..<userAttractionDatabase.count{
        //
        //            //Needs to be changed to match parkID, not index?
        //            //**MARK FIX THIS***
        //            usersParkList.add(feedItems[userAttractionDatabase[i][0].parkID])
        //        }
        if (userAttractionDatabase[downloadIncrementor].count == 0){
        }
        else{
            for i in 0..<arrayOfAllParks.count{
                park = arrayOfAllParks[i]
                if park.parkID == userAttractionDatabase[downloadIncrementor][0].parkID{
                    if downloadIncrementor < userAttractionDatabase.count - 1{
                        downloadIncrementor += 1
                    }
                    
                    usersParkList.append(arrayOfAllParks[i] )
                }
                //usersParkList.add(feedItems[userAttractionDatabase[i][0].parkID])
            }
            //printUserDatabase()
            self.listTableView.reloadData()
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
        print("GETTING GPS DATA")
    }
    
    
    
    func parkTableViewCellDidRemovePark(_ sender: ParksTableViewCell) {
        guard let indexPath = listTableView.indexPath(for: sender) else { return }

        //Find and delete all the saved data for the selected parkID
        var indexToRemove = 0
        let removedParkID = usersParkList[indexPath.row].parkID
        for i in 0..<userAttractionDatabase.count{
            if userAttractionDatabase[i][0].parkID == removedParkID{
                print("Delete all items in this array for park ID \(removedParkID!)")
                indexToRemove = i
                break
            }
        }
        //Delete from coreData
        deletePark(parkID: removedParkID!)
        
        for i in 0..<userAttractionDatabase[indexToRemove].count{
            if userAttractionDatabase[indexToRemove][i].rideID != -1{
                //deletePark(parkID: removedParkID!)
            }
        }
        
        userAttractionDatabase[indexToRemove].removeAll()
        userAttractionDatabase.remove(at: indexToRemove)
        usersParkList.remove(at: indexPath.row)

        printUserDatabase()
        listTableView.reloadData()
    }
    
    func save(parkID: Int, rideID: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "RideTrack",
                                                in: managedContext)!
        
        let newPark = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
        
        newPark.setValue(parkID, forKeyPath: "parkID")
        newPark.setValue(rideID, forKeyPath: "rideID")
        newPark.setValue(0, forKey: "numberOfTimesRidden")
        
        print("Just saved new park: ", parkID)
        do {
            try managedContext.save()
            userAttractions.append(newPark)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func deletePark(parkID: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RideTrack")
        //fetchRequest.predicate = NSPredicate(format: "rideID = %@", "\(rideID)")
        fetchRequest.predicate = NSPredicate(format: "parkID = %@", "\(parkID)")

        do
        {
            let fetchedResults =  try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
            
            for entity in fetchedResults! {
                
                managedContext.delete(entity)
                print("Deleted park \(parkID)")
                do {
                    try managedContext.save()
                } catch {
                    // Do something... fatalerror
                }
            }
        }
        catch _ {
            print("Could not delete")
        }
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersParkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkCell", for: indexPath) as! ParksTableViewCell
        cell.delegate = self
        let item: ParksModel = usersParkList[indexPath.row]
        cell.parkNameLabel.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAttractions"{
            let attractionVC = segue.destination as! AttractionsViewController
        
            if segueWithTableViewSelect{
                selectedIndex = (listTableView.indexPathForSelectedRow?.row)!
                selectedPark = usersParkList[selectedIndex]
            }
            attractionVC.titleName = selectedPark.name
            attractionVC.parkID = selectedPark.parkID
            attractionVC.userAttractions = userAttractions
            attractionVC.showExtinct = showExtinct
            attractionVC.showPayed = showPayed
            
            //What is this next line doing with downloadIncrementor???????
            //if userAttractionDatabase[downloadIncrementor].count != 0{
            //if userAttractionDatabase.count != 0{
            if userAttractionDatabase != [[]]{
                for i in 0..<userAttractionDatabase.count {
                    if userAttractionDatabase[i][0].parkID == selectedPark.parkID{
                        // attractionVC.userAttractionDatabase = userAttractionDatabase[i]
                        attractionVC.userAttractionDatabase = userAttractionDatabase[i]
                    }
                    else{
                    }
                }
            }
            else{
                print("array is empty")
            }
        }
        
        if segue.identifier == "toSearch"{
            let searchVC = segue.destination as! ParkSearchViewController
            searchVC.parkArray = arrayOfAllParks as NSArray
        }
        if segue.identifier == "toSettings"{
            
            let settingVC = segue.destination as! SettingsViewController
            settingVC.showExtinct = showExtinct
            settingVC.showPayed = showPayed
        }
    }
    
    @IBAction func unwindToParkList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ParkSearchViewController, let newPark = sourceViewController.selectedPark{
            addNewParkToList(newPark: newPark)
        }
    }
    
    @IBAction func unwindToList(segue:UIStoryboardSegue) {
        if let sourceViewController = segue.source as? SettingsViewController, let pressReset = sourceViewController.resetPressed{
            print ("BACK FROM SETTINGS")
            if (pressReset == 1) {
                print("RESET WAS PRESSED")
                downloadIncrementor = 0
                usersParkList = []
                self.listTableView.reloadData()
                userAttractionDatabase = [[]]
            }
        }
    }
    
    func addNewParkToList(newPark: ParksModel) {
        if checkIfNewPark(newPark: newPark){
            usersParkList.append(newPark)
            print("ADDING")
            userAttractionDatabase.append([UserAttractionProvider(parkID: newPark.parkID)])
            self.listTableView.reloadData()
            self.save(parkID: newPark.parkID, rideID: -1)
            print("new park saved: ", newPark.parkID)
            //UserDefaults.standard.set(parkListData, forKey: "parkListData")
        }
        else{
            print("Can not add a park twice")
        }
    }
    
    func checkIfNewPark(newPark: ParksModel) -> Bool {
        var isNewPark = true
        for i in 0..<usersParkList.count{
            if newPark.parkID == usersParkList[i].parkID{
                isNewPark = false
            }
        }
        return isNewPark
    }
    
    
    func printUserDatabase() {
        print("Ignore the fact that each park always starts with -1")
        
        //FIX: THIS SOMETIMES CAUSES CRASH AFTER DATA RESET
        //Why use downloadIncrementor????????
        //if (userAttractionDatabase[downloadIncrementor].count == 0){
        if userAttractionDatabase == [[]]{
            print ("Current user database is empty")
        }
        else{
            var stringToPrint = "Current user database:"
            for i in 0..<userAttractionDatabase.count{
                //Kind of funcky, but the first entry will always just be the parkID? I don't know how good of an idea this is...
                stringToPrint += "\n\nPark ID: \(userAttractionDatabase[i][0].parkID!):\n"
                for j in 1..<userAttractionDatabase[i].count{
                    //for j in 0..<userAttractionDatabase[i].count{
                    stringToPrint += "RideID: \(userAttractionDatabase[i][j].rideID!)  "
                }
                if userAttractionDatabase[i].count == 1{
                    stringToPrint += "Empty"
                }
            }

            
            print(stringToPrint)
        }
        print("This is size of UserAttractions (CoreData): ", userAttractions.count)
        print("")
    }
    
    func dataMigrationToList() {
        print("DELTE")
        userAttractionDatabase = [[]]
        var firstTime = true
        print("\nPrint the migration:")
        var parkIndex = 0
        
        //Loop through entire userAttractions array, which was fetched from CoreData
        for i in 0..<userAttractions.count {
            let ride = userAttractions[i]
            var rideNext = userAttractions[i]
            if i != userAttractions.count - 1{
                rideNext = userAttractions[i+1]
            }
            else{
                rideNext = userAttractions[i]
            }
            
            let compare1 = ride.value(forKeyPath: "parkID") as! Int
            //Crashes when
            let compare2 = rideNext.value(forKeyPath: "parkID") as! Int
            
            if firstTime{
                //Create inital entry in the 2D array with first parkID
                userAttractionDatabase[0] = [UserAttractionProvider(rideID: -1, parkID: compare1, numberOfTimesRidden: ride.value(forKey: "numberOfTimesRidden") as! Int)]
            
                print("RUNNING")
                firstTime = false
            }
            userAttractionDatabase[parkIndex].append(UserAttractionProvider(rideID: ride.value(forKeyPath: "rideID") as! Int, parkID: compare1, numberOfTimesRidden: ride.value(forKey: "numberOfTimesRidden") as! Int))
            
            if compare1 != compare2 && i != userAttractions.count - 1{
                //Add a new park to the 2D array
                parkIndex += 1
                //userAttractionDatabase.append([UserAttractionProvider(rideID: -1, parkID: compare2)])
                userAttractionDatabase.append([UserAttractionProvider(rideID: -1, parkID: compare2, numberOfTimesRidden: ride.value(forKey: "numberOfTimesRidden") as! Int)])
            }
        }
        
        //Sort each park array in asseding RideID
        for i in 0..<userAttractionDatabase.count {
            if userAttractionDatabase[i].count != 1{
                userAttractionDatabase[i].sort { $0.rideID < $1.rideID }
            }
            
        }
        
        printUserDatabase()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            var oneMileParks = [ParksModel]()
            
            //Simulate you are at Epcot
//            latitude = 28.3667
//            longitude = -81.5495
            
            //Simulate you are in Magic Kingdom
//            latitude = 28.4161
//            longitude = -81.5811
            
            
            
            let currentLocation = CLLocation(latitude: latitude!, longitude: longitude!)
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
            dataMigrationToList()
        }
        segueWithTableViewSelect = false
        selectedPark = closestPark
        performSegue(withIdentifier: "toAttractions", sender: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
    
 
}

