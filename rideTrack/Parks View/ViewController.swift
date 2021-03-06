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
import Firebase

import UserNotifications


class ViewController: UIViewController, CLLocationManagerDelegate, DataModelProtocol, NSFetchedResultsControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate{
    
    let screenSize = UIScreen.main.bounds
    
    
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var allParksTableView: UITableView!
    @IBOutlet weak var currentLocationView: UIView!
    @IBOutlet weak var currentLocationParkNameLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var favoritesView: UIView!
    @IBOutlet weak var allParksView: UIView!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var addParkButton: UIButton!
    @IBOutlet weak var searchParkView: UIView!
    @IBOutlet weak var viewAttractionLocationButton: UIButton!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var myParksLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var searchParksTextField: UITextField!
    @IBOutlet weak var searchMyParksButton: UIButton!
    @IBOutlet weak var doneSearchButton: UIButton!
    @IBOutlet weak var activityIndictor: UIActivityIndicatorView!
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var centerLogoWidthConstrant: NSLayoutConstraint!
    
    
    @IBOutlet weak var navBarHeightConstants: NSLayoutConstraint!
    @IBOutlet weak var addParkHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var currentLocationViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchRideButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoritesViewHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var allParksBottomConstrant: NSLayoutConstraint!
    @IBOutlet weak var doneSearchWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var doneSearchHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var locationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var locationViewCenterConstrant: NSLayoutConstraint!
    @IBOutlet weak var tapExpandFavoritesView: UIButton!
    @IBOutlet weak var tapExpandAllParksView: UIButton!
    @IBOutlet weak var favoritesInstructions: UILabel!
    @IBOutlet weak var allParksInstructions: UILabel!
    @IBOutlet weak var favoritesExpandButton: UIImageView!
    @IBOutlet weak var allParksExpandButton: UIImageView!
    
    var darkenBackground=UIView()
    var favoitesHeight: CGFloat = 190.0
    var favoritesHeightMax: CGFloat = 190.0
    var allParksBottomInsetValue:CGFloat = 20
    
    var favoritesIsExpanded = false
    var allParksIsExpanded = false
    var allParksIsVisible = true
    var favoritesViewIsVisible = true
    
    var selectedPark: ParksList!
    var segueWithTableViewSelect = true
    
    var favoiteParkList = [ParksList]()
    var allParksList = [ParksList]()
    var selectedAttractionsList: [NSManagedObject] = []
    var savedParkList: [NSManagedObject] = []
    var arrayOfAllParks = [ParksModel]()
    var userName = ""
    
    var firstCheckin = false
    var checkedIntoPark = false
    var numberOfCheckinsToDisplay = 0
    var lastVisit = 0.0
    var checkedInParkID = -1
    
    var savedMyParksForSearch = [ParksList]()
    var isSearchingMyParks = false
    var firstItemsToFavorites = true
    var itemsAlreadyDownloaded = false
    
    var simulateLocation = UserDefaults.standard.integer(forKey: "simulateLocation")
    
    var locationManager: CLLocationManager = CLLocationManager()
    var closestPark: ParksModel!
    var currentLocationPark: ParksList!
    
    let settingsColor = UIColor(red: 211/255.0, green: 213/255.0, blue: 215/255.0, alpha: 1.0)
    let checkInButtonColor = UIColor(red: 37/255.0, green: 103/255.0, blue: 251/255.0, alpha: 1.0)
    let favoritesGreen = UIColor(red: 40/255.0, green: 119/255.0, blue: 72/255.0, alpha: 1.0)
    
    var favoritesViewHeightBeforeAnimating: CGFloat!
    let expandParksView = ExpandParksView()
    let searchMyParks = SearchMyParks()
    
    var userNameRef: DatabaseReference!
    var parksListRef: DatabaseReference!
    var statsListRef: DatabaseReference!
    var dayInParkRef: DatabaseReference!
    var user: User!
    
    var handleUserName: UInt!
    var handleParkList: UInt!
    var handleStats: UInt!
    
    
    override func viewDidLoad() {
        configureViewDidLoad()
        if screenSize.height == 812{
            expandParksView.setFavoriteExpandHeight(variable: 227)
        }
        
        super.viewDidLoad()
        
        favoritesTableView.isUserInteractionEnabled = false
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        allParksTableView.isUserInteractionEnabled = false
        allParksTableView.delegate = self
        allParksTableView.dataSource = self
        searchParksTextField.delegate = self
        settingsButton.isUserInteractionEnabled = false
        
  
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: allParksBottomInsetValue, right: 0)
        self.allParksTableView.contentInset = insets
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        let userID = Auth.auth().currentUser
        let id = userID?.uid
        UserDefaults.standard.set(id, forKey: "userID")
        
        self.userNameRef = Database.database().reference(withPath:"users/details/\(id!)/userName") ///userName
        self.parksListRef = Database.database().reference(withPath: "all-parks-list/\(id!)")
        self.dayInParkRef = Database.database().reference(withPath: "day-in-park/\(id!)")
        self.statsListRef = Database.database().reference(withPath: "stats-list/\(id!)")
    
        
        let urlPath = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/parksdbservice.php"
        let dataModel = DataModel()
        dataModel.delegate = self
        dataModel.downloadData(urlPath: urlPath, dataBase: "parks", returnPath: "allParks")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        segueWithTableViewSelect = true
        super.viewWillAppear(animated)
        handleUserName = userNameRef.observe(.value, with: { snapshot in
            if snapshot.exists(){ //hasChild("testJustin"){
                self.userName = (snapshot.value as! String)
                print("Has username")
            }
            else {
                self.userName = ""
            }
        })
        
       handleParkList = parksListRef.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
            var newParks: [ParksList] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    
                    let parkItem = ParksList(snapshot: snapshot) {
                    
                    newParks.append(parkItem)
                }
            }
            
            self.allParksList = newParks
            self.splitAllParksWithFavoriteList(allParksList: self.allParksList)
            self.allParksTableView.reloadData()
            self.favoritesTableView.reloadData()
            self.configureAllParksView()
            self.configureFavoritesView()
        })
        statsListRef.observeSingleEvent(of: .value, with: { snapshot in
            var newStat: [Stats] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let statItem = Stats(snapshot: snapshot) {
                    newStat.append(statItem)
                }
            }
            print("Gettings stats-list")
            print(newStat.count)
            //If this is first launch, add stats to user's firebase
            if newStat.count == 0{
                print("This is the first time the user has launched")
                let newStatsModel = Stats(attractions: 0, extinctAttracions: 0, activeAttractions: 0, parks: 0, parksCompleted: 0, experiences: 0, countries: 0, rollerCoasters: 0, waterRides: 0, childrensRides: 0, flatRides: 0, transportRides: 0, darkRides: 0, exploreRides: 0, spectaculars: 0, shows: 0, films: 0, playAreas: 0, upchargeRides: 0, rollerCoasterExperience: 0, waterExperience: 0, childrensRideExperience: 0, flatRideExperience: 0, transportExperience: 0, darkRidesExperience: 0, exploreExperience: 0, spectacularExperince: 0, showExperience: 0, filmsExperience: 0, playAreaExperience: 0, upchargeExperience: 0, paradesExperience: 0, parades: 0, checkIns: 0)
                let newStatsRef = self.statsListRef.child("life-time-stats")
                newStatsRef.setValue(newStatsModel.toAnyObject())
            }
        })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        allParksTableView.isUserInteractionEnabled = true //only taps the talbeview cell once items have downloaded
        favoritesTableView.isUserInteractionEnabled = true
        settingsButton.isUserInteractionEnabled = true
        activityIndictor.stopAnimating()
        //Returns the number of total rides in the park, for the fraction view
        if returnPath == "countNumberOfRides"{
            var totalRideCount = 0
            let arrayOfAllRides = items as! [AttractionsModel]
            for i in 0..<arrayOfAllRides.count{
                if arrayOfAllRides[i].active == 1{
                    totalRideCount += 1
                }
            }
            print(totalRideCount, "updating total ride count label...")
            
            if arrayOfAllRides.count != 0{
                //parksCoreData.updatingTotalRideCount(parkID: arrayOfAllRides[0].parkID, totalRideCount: totalRideCount)
                for i in 0..<allParksList.count{
                    if allParksList[i].parkID == arrayOfAllRides[0].parkID{
                        let parkItem = allParksList[i]
                        parkItem.ref?.updateChildValues([
                            "totalRides": totalRideCount
                            ])
                        break
                    }
                }
            }
        }
        //Gets all the parks from the database, sets up the favoritesList and allMyParksList
        else{
            arrayOfAllParks = items as! [ParksModel]
            itemsAlreadyDownloaded = true
            favoritesViewHeightBeforeAnimating = favoritesViewHeightConstrant.constant

            
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.requestLocation()
            print("GETTING GPS DATA")
            MigrateToFireBase().migrate(arrayOfAllParks: arrayOfAllParks)
        }
    }
    
    func splitAllParksWithFavoriteList(allParksList: [ParksList]){
        favoiteParkList = []
        for i in 0..<allParksList.count{
            if allParksList[i].favorite{
                favoiteParkList.append(allParksList[i])
            }
        }
    }
    
    func configureFavoritesView(){
        if favoritesViewIsVisible{
            var favoritesTableAlpha: CGFloat = 1.0
            if favoritesViewIsVisible && !isSearchingMyParks{
                if !favoritesIsExpanded{
                    favoritesExpandButton.transform = CGAffineTransform(rotationAngle: -90 * CGFloat(3.14159/180))
                    if favoiteParkList.count == 0{
                        favoitesHeight = 70
                        favoritesViewHeightConstrant.constant = favoitesHeight
                        favoritesTableAlpha = 0.0
                    }
                    else{
                        favoitesHeight = favoritesHeightMax
                        favoritesViewHeightConstrant.constant = favoitesHeight
                        favoritesTableAlpha = 1.0
                    }
                }else{
                    favoritesExpandButton.transform = CGAffineTransform(rotationAngle: 0 * CGFloat(3.14159/180))
                }
            }
            UIView.animate(withDuration: 0.6, animations: {
                self.favoritesTableView.alpha = favoritesTableAlpha
            })
            self.view.layoutIfNeeded()
        }
    }
    
    func configureAllParksView(){
        if allParksIsVisible{
            var allParksViewTableAlpha: CGFloat = 1.0
            if allParksList.count == 0{
                allParksViewTableAlpha = 0.0
            }
            if allParksIsExpanded{
                allParksExpandButton.transform = CGAffineTransform(rotationAngle: 0 * CGFloat(3.14159/180))
            } else{
                allParksExpandButton.transform = CGAffineTransform(rotationAngle: -90 * CGFloat(3.14159/180))
            }
            UIView.animate(withDuration: 0.6, animations: {
                self.allParksTableView.alpha = allParksViewTableAlpha
            })
            self.view.layoutIfNeeded()
        }
    }
    
    
    func addNewParkToList(newPark: ParksModel, newCheckin: Bool) {
        
        if newPark.latitude != nil && newPark.longitude != nil {
            let center = CLLocationCoordinate2D(latitude: newPark.latitude!, longitude: newPark.longitude!)
            let region = CLCircularRegion(center: center, radius: 1500, identifier: "\(newPark.parkID!)")
            region.notifyOnEntry = true
            region.notifyOnExit = false
            let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        
            let content = UNMutableNotificationContent()
            content.title = "Check in with LogRide"
            content.body = "Welcome back to \(newPark.name!)! Check-in to track the rides you go on today!"
            content.badge = 1
            content.sound = UNNotificationSound.default
        
            let request = UNNotificationRequest(identifier: "\(newPark.parkID!)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in }
        }
        if checkIfNewPark(newPark: newPark){
            
            //Adding defualt user saved data values
            newPark.favorite = false
            newPark.totalRides = 0
            newPark.ridesRidden = 0
            newPark.incrementorEnabled = false
            
            Analytics.logEvent("add_new_park", parameters: ["parkName": newPark.name])

            //Animate in the all parks table veiw when adding the first park
            if allParksList.count == 0{
                UIView.animate(withDuration: 0.6, animations: {
                    self.allParksTableView.alpha = 1.0
                })
            }
            var checkins = 0
            var dayVisited = 0.0
            var checkInToday = false
            if newCheckin{
                checkins = 1
                var calendar = NSCalendar.current
                calendar.timeZone = NSTimeZone.local//OR NSTimeZone.localTimeZone()
                let midnight = calendar.startOfDay(for: Date())
                dayVisited = midnight.timeIntervalSince1970
                checkInToday = true
            }
            let newParkModel = ParksList(parkID: newPark.parkID, favorite: false, ridesRidden: 0, totalRides: 0, incrementorEnabled: false, name: newPark.name, location: newPark.city, showDefunct: true, parkDefunct: false, showSeasonal: false, numberOfCheckIns: checkins, lastDayVisited: dayVisited, checkedInToday: checkInToday)
    
            let newParkRef = self.parksListRef.child(String(newParkModel.parkID))
            newParkRef.setValue(newParkModel.toAnyObject())
        
            //allParksList.insert(newPark, at: 0)
            
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: allParksBottomInsetValue, right: 0)
            self.allParksTableView.contentInset = insets
            self.allParksTableView.reloadData()
            //self.parksCoreData.saveNewItemToParkList(parkID: newPark.parkID)
            
            //Get total number of rides, need to call database
            let urlPath = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/attractiondbservice.php?parkid=\(newPark.parkID!)"
            let dataModel = DataModel()
            dataModel.delegate = self
            dataModel.downloadData(urlPath: urlPath, dataBase: "attractions", returnPath: "countNumberOfRides")
            print("new park saved: ", newPark.parkID!)
            allParksList.append(newParkModel)
        }
        else{
            print("Can not add a park twice")
        }
    }
    
    
    func removeParkFromList(parkID: Int, indexPath: Int) {
        //Deletes from both RideTrack and ParkList entities
        //parksCoreData.deletePark(parkID: parkID)

        print("Make sure the data from Attractions-List-Model gets deleted again ")
        //Check if it is in user's favorites list, if so delete it
        let parkItem = allParksList[indexPath]
        parkItem.ref?.removeValue()
        allParksList.remove(at: indexPath)
        
        let userID = Auth.auth().currentUser
        let id = userID?.uid
        let attractionsListRef = Database.database().reference(withPath: "attractions-list/\(id!)/\(parkID)")
        attractionsListRef.removeValue()
        
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: ["\(parkID)"])
        //remove notification for that park
        
        print("Animate delete")
        favoritesTableView.reloadData()
        
        //Animate away favorites view to dissappear if the last park is being removed from the list
        var allParksViewTableAlpha: CGFloat = 1.0
        var favoritesTableAlpha: CGFloat = 1.0
        
        if favoritesViewIsVisible{
            if favoiteParkList.count == 0{
                favoitesHeight = 70
                favoritesViewHeightConstrant.constant = favoitesHeight
                favoritesTableAlpha = 0.0
            }
        }
        if allParksIsVisible{
            if allParksList.count == 0{
                allParksViewTableAlpha = 0.0
            }
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
            let navVC = segue.destination as? UINavigationController
            let attractionVC = navVC?.viewControllers.first as! AttractionsViewController
            
            print("SEGUE")
            if segueWithTableViewSelect && segue.identifier == "toAttractionsAll"{
                let selectedIndex = (allParksTableView.indexPathForSelectedRow?.row)!
                selectedPark = allParksList[selectedIndex]
                print ("going to attractions")
            } else if segueWithTableViewSelect && segue.identifier == "toAttractionsFavorites"{
                let selectedIndex = (favoritesTableView.indexPathForSelectedRow?.row)!
                selectedPark = favoiteParkList[selectedIndex]
            }
            
            let arrayOfAllParksIndex = getParkModelINdexFromAllParks(parkID: selectedPark.parkID)
            
            if firstCheckin{
                firstCheckin = false
                attractionVC.firstCheckin = true
                attractionVC.numberOfCheckins = numberOfCheckinsToDisplay
                attractionVC.lastVisit = lastVisit
                //attractionVC.firstCheckin = firstCheckin
            }
            
            print ("The park is ", selectedPark.name)
            attractionVC.showExtinct = selectedPark.showDefunct
            attractionVC.showSeasonal = selectedPark.showSeasonal
            attractionVC.parksViewController = self
            attractionVC.segueWithTableViewSelect = segueWithTableViewSelect
            attractionVC.parkData = arrayOfAllParks[arrayOfAllParksIndex]
            attractionVC.parkData.totalRides = selectedPark.totalRides
            attractionVC.parkData.incrementorEnabled = selectedPark.incrementorEnabled
            attractionVC.checkedIntoPark = checkedIntoPark
            checkedIntoPark = false
            if checkedInParkID == selectedPark.parkID{
                print("Currently in the park")
                attractionVC.checkedIntoPark = true
            }
            
            //If the name of the park has changed, update the name in Parks-list
            if arrayOfAllParks[arrayOfAllParksIndex].name != selectedPark.name{
                let parkItem = allParksList[findIndexInAllParksList(parkID: selectedPark.parkID)]
                parkItem.ref?.updateChildValues([
                    "name": arrayOfAllParks[arrayOfAllParksIndex].name
                    ])
            }
            

            UIView.animate(withDuration: 0.2, animations: {
                self.darkenBackground.alpha =  0.20
            })
            if isSearchingMyParks{
                searchMyParks.animateOutOfParkSearch(parksView: self)
            }
            //print("count: ", userAttractions.count)
        }
        
        if segue.identifier == "toSearch"{
            let searchVC = segue.destination as! ParkSearchViewController
            searchVC.parkArray = arrayOfAllParks
            searchVC.parksVC = self
            searchVC.savedParks = allParksList
            searchVC.userName = userName
            UIView.animate(withDuration: 0.2, animations: {
                self.darkenBackground.alpha =  0.20
            })
            
        }
        if segue.identifier == "toStats"{
            let statsVC = segue.destination as! StatsViewController
            //statsVC.simulateLocation = simulateLocation
            statsVC.allParksList = allParksList
            statsVC.arrayOfAllParks = arrayOfAllParks
        }
        if segue.identifier == "toSettings"{
            let settingsVC = segue.destination as! SettingsViewController
            settingsVC.simulateLocation = simulateLocation
            settingsVC.userID = user.uid
            settingsVC.userName = userName

        }
        if segue.identifier == "toLists"{
            //let allListVC = segue.destination as! AllListsViewController
            let navVC = segue.destination as? UINavigationController
            let allListVC = navVC?.viewControllers.first as! AllListsViewController
            allListVC.allParksList = arrayOfAllParks
            allListVC.userName = userName
        }
    }
    
    
    @IBAction func unwindToParkList(segue:UIStoryboardSegue) {
        if segue.source is SettingsViewController{
            print("back from settings")
            let settingsVC = segue.source as! SettingsViewController
            simulateLocation = settingsVC.simulateLocation
            
            searchRideButtonHeightConstraint.constant = 23
            currentLocationViewBottomConstraint.constant = -61
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            print("GETTING GPS DATA")
        }
        if segue.source is SuggestParkViewController{
             self.darkenBackground.alpha =  0
            print("Back from suggest park")
        }
        else if let sourceViewController = segue.source as? ParkSearchViewController, let newPark = sourceViewController.selectedPark{
            addNewParkToList(newPark: newPark, newCheckin: false)
            print("unwinding")
            UIView.animate(withDuration: 0.2, animations: {
                self.darkenBackground.alpha = 0.0
            })
            
        }
        else if segue.source is AttractionsViewController{
            print("DO NOT USE THIS, IT WILL NOT UPDATE THE FRACTIONS. INSTEAD CALL THE UNWIND METHOD")
        }
    }
    
    func getParkModelINdexFromAllParks(parkID: Int) -> Int{
        var i = 0
        var foundID = 0
        repeat {
            if arrayOfAllParks[i].parkID == parkID{
                foundID = i
                break
            }
            i += 1
        } while i < arrayOfAllParks.count
        return foundID
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

            if simulateLocation == 1{
                latitude = 28.4161
                longitude = -81.5811
                //latitude = 28.0372
                //longitude = -82.4195
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
                print(allParksList.count)
                
                let allParkIndex = findIndexInAllParksList(parkID: closestPark.parkID)
                if allParkIndex != -1{
                    currentLocationPark = allParksList[allParkIndex]
                    
                    //Checking if the user has already checked in today
                    var calendar = NSCalendar.current
                    calendar.timeZone = NSTimeZone.local//OR NSTimeZone.localTimeZone()
                    let midnight = calendar.startOfDay(for: Date())
                    
                    if midnight.timeIntervalSince1970 != currentLocationPark.lastDayVisited{
                        print("User has not checked into this park today")
                        currentLocationPark.checkedInToday = false
                        let parkItem = allParksList[allParkIndex]
                        parkItem.ref?.updateChildValues([
                            "checkedInToday": false
                            ])
                        //dayInParkRef.removeValue()
                        checkedInParkID = -1
                        
                    }
                    if currentLocationPark.checkedInToday{
                        viewAttractionLocationButton.backgroundColor = settingsColor
                        viewAttractionLocationButton.setTitle("View Attractions", for: .normal)
                        viewAttractionLocationButton.setTitleColor(.black, for: .normal)
                        checkedInParkID = currentLocationPark.parkID
                    } else {
                        viewAttractionLocationButton.backgroundColor = checkInButtonColor
                        viewAttractionLocationButton.setTitle("Check In", for: .normal)
                        viewAttractionLocationButton.setTitleColor(.white, for: .normal)
                        checkedInParkID = -1
                    }
                }
            
                self.currentLocationParkNameLabel.text = self.closestPark.name!
                self.view.layoutIfNeeded()
                //Begin animating the UI with the new current location park
                
                self.searchRideButtonHeightConstraint.constant = 50
                self.currentLocationViewBottomConstraint.constant = -4
                //If iPhone X, make the locationView heigher
                if screenSize.height == 812 || UIScreen.main.bounds.height == 896.0{
                    self.locationViewHeight.constant = 85
                }
                
                allParksBottomInsetValue = 45
                let insets = UIEdgeInsets(top: 0, left: 0, bottom: allParksBottomInsetValue, right: 0)
                self.allParksTableView.contentInset = insets
                UIView.animate(withDuration: 0.6, animations: {
                    self.view.layoutIfNeeded()
                })
            } else{
                allParksBottomInsetValue = 20
                let insets = UIEdgeInsets(top: 0, left: 0, bottom: allParksBottomInsetValue, right: 0)
                self.allParksTableView.contentInset = insets
                //If iPhone X, make the locationView heigher
                if screenSize.height == 812{
                    self.locationViewHeight.constant = 59
                }
            }
            
        }
    }
    
    @IBAction func showCurrentlLocationPark(_ sender: Any) {
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local//OR NSTimeZone.localTimeZone()
        let midnight = calendar.startOfDay(for: Date())
        
        if checkIfNewPark(newPark: closestPark){
            print("new park")
            addNewParkToList(newPark: closestPark, newCheckin: true)
            Analytics.logEvent("check_into_park", parameters: ["parkName": closestPark])
            configureDayInPark(closestPark: closestPark, numberOfVisits: 1, midnight: midnight)
        }
        
        checkedIntoPark = true
        segueWithTableViewSelect = false
        let selectedParkIndex = findIndexInAllParksList(parkID: closestPark.parkID)
        
        selectedPark = allParksList[selectedParkIndex]
        if !selectedPark.checkedInToday{
            firstCheckin = true
            numberOfCheckinsToDisplay = selectedPark.numberOfCheckIns + 1
            lastVisit = selectedPark.lastDayVisited
            
            let parkItem = allParksList[selectedParkIndex]
            parkItem.ref?.updateChildValues([
                "lastDayVisited": midnight.timeIntervalSince1970,
                "checkedInToday": true,
                "numberOfCheckIns": selectedPark.numberOfCheckIns + 1
                ])
            print("Checking in for first time")
        
            configureDayInPark(closestPark: closestPark, numberOfVisits: selectedPark.numberOfCheckIns+1, midnight: midnight)
        }
        
        viewAttractionLocationButton.backgroundColor = settingsColor
        viewAttractionLocationButton.setTitle("View Attractions", for: .normal)
        viewAttractionLocationButton.setTitleColor(.black, for: .normal)
        
        performSegue(withIdentifier: "toAttractionsAll", sender: nil)
    }
    
    func configureDayInPark(closestPark: ParksModel, numberOfVisits: Int, midnight: Date){
        
        let content = UNMutableNotificationContent()
        content.title = "How was your day at \(closestPark.name!)?"
        content.body = "View today's Report Card to see an overview of your day at the park!"
        content.sound = UNNotificationSound.default
        var date = DateComponents()
        date.hour = 21
        date.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: "dayInParkNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        checkedInParkID = closestPark.parkID
        let newDayInParkModel = DayInPark(checkInTime: midnight.timeIntervalSince1970, numberOfVisitsToThePark: numberOfVisits, parkName: closestPark.name)
        let startDayInParkRef = self.dayInParkRef.child(String("\(Int(midnight.timeIntervalSince1970))/todays-stats"))
        startDayInParkRef.setValue(newDayInParkModel.toAnyObject())
    }
    
    
    @IBAction func didTapSearchMyParks(_ sender: Any) {
        print("searching my parks")
        searchMyParks.animateIntoSearchView(parksView: self)
    }
    
    
    @IBAction func didTapDownSearchParks(_ sender: Any) {
        print("Done searching my parks")
        searchMyParks.animateOutOfParkSearch(parksView: self)
    }
    
    @IBAction func didChangeMySearchText(_ sender: Any) {
        searchMyParks.updateSearchResults(parksView: self)
    }

    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            searchRideButtonHeightConstraint.constant = 23
            currentLocationViewBottomConstraint.constant = -61
            //If iPhone X, make the locationView heigher
            if screenSize.height == 812{
                self.locationViewHeight.constant = 85
            }
            
            allParksBottomInsetValue = 20
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: allParksBottomInsetValue, right: 0)
            self.allParksTableView.contentInset = insets
            //If iPhone X, make the locationView heigher
            if screenSize.height == 812{
                self.locationViewHeight.constant = 59
            }
            UIView.animate(withDuration: 0.6, animations: {
                self.view.layoutIfNeeded()
            })
            return
        }
    }
    
    func unwindFromAttractions(parkID: Int) {
        segueWithTableViewSelect = true
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: allParksBottomInsetValue, right: 0)
        self.allParksTableView.contentInset = insets
        UIView.animate(withDuration: 0.2, animations: {
            self.darkenBackground.alpha =  0
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            allParksTableView.contentInset = UIEdgeInsets.zero
        } else {
            allParksTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        allParksTableView.scrollIndicatorInsets = allParksTableView.contentInset
    }
    
    func configureViewDidLoad(){
        //If iPhone 5s
        if screenSize.width == 320.0{
            ConfigureSmallerLayout().configureParksView(parksView: self)
        }

        //Initialize current location UI
        currentLocationView.layer.shadowOffset = CGSize.zero
        currentLocationView.layer.shadowRadius = 5
        currentLocationView.layer.shadowOpacity = 0.3
        currentLocationView.layer.cornerRadius = 10
        currentLocationViewBottomConstraint.constant = -61
        
        let dissmissLocationView = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        dissmissLocationView.minimumPressDuration = 1.0
        dissmissLocationView.delaysTouchesBegan = true
        dissmissLocationView.delegate = self
        self.currentLocationView.addGestureRecognizer(dissmissLocationView)
        
        
        viewAttractionLocationButton.layer.cornerRadius = 7
        viewAttractionLocationButton.titleLabel?.adjustsFontSizeToFitWidth = true
  
        doneSearchButton.backgroundColor = settingsColor
        doneSearchButton.layer.cornerRadius = 5
        doneSearchButton.titleLabel?.adjustsFontSizeToFitWidth = true
        doneSearchButton.alpha = 0.0
  
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
        searchMyParksButton.layer.cornerRadius = 7
        searchMyParksButton.layer.borderWidth = 0.3
        searchMyParksButton.layer.borderColor = UIColor.gray.cgColor
        
        searchParksTextField.alpha = 0.0
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        let lightGreen = UIColor(red: 63.0/255.0, green: 180.0/255.0, blue: 61.0/255.0, alpha: 1.0).cgColor
        let darkGreen = UIColor(red: 32.0/255.0, green: 104.0/255.0, blue: 41.0/255.0, alpha: 1.0).cgColor
        gradient.colors = [lightGreen, darkGreen]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        
        backgroundView.layer.addSublayer(gradient)
        
        darkenBackground=UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        darkenBackground.backgroundColor = UIColor.black
        darkenBackground.alpha = 0.0
        darkenBackground.isUserInteractionEnabled = true
        self.view.addSubview(darkenBackground)
        
    }
    
    @IBAction func didTapExpandAllParks(_ sender: Any) {
        print(allParksIsExpanded)
        if !allParksIsExpanded{
            print("Expanding")
            expandParksView.expandOutAllParks(parksView: self)
        } else{
            print("Reseting")
            expandParksView.resetToDefault(parksView: self)
        }
    }
    
    @IBAction func didTapExpandFavorites(_ sender: Any) {
        if !favoritesIsExpanded{
            print("Expanding")
            expandParksView.expandFavoritesView(parksView: self)
        } else{
            print("reseting")
            expandParksView.resetToDefault(parksView: self)
        }
    }
    
    
    func findIndexInAllParksList(parkID:Int) -> Int{
        var allParksIndex = -1
        for i in 0..<allParksList.count{
            if allParksList[i].parkID == parkID{
                allParksIndex = i
                break
            }
        }
        return allParksIndex
    }


    @objc func appMovedToForeground(){
        if itemsAlreadyDownloaded{
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            print("Checking location")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        parksListRef.removeObserver(withHandle: handleParkList)
        userNameRef.removeObserver(withHandle: handleUserName)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
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
            cell.locationLabel.text = parkData.location
            cell.fractionLabel.text = "\(parkData.ridesRidden!)/\(parkData.totalRides!)"
            
            if screenSize.width == 320.0{
                ConfigureSmallerLayout().favoriteCellLayout(favoriteCell: cell)
            }
            
            let rides: Double = Double(parkData.ridesRidden)
            let total = Double(parkData.totalRides)
            var progressToShow = CGFloat(0)
            if total != 0{
                //Plus 4 becasue the
                progressToShow = CGFloat(Double(cell.progressViewBackgroundWidth.constant) * (rides/total))
                if rides/total == 1{
                    cell.progressView.backgroundColor = UIColor(red: 250/255.0, green: 204/255.0, blue: 73/255.0, alpha: 1.0)
                } else{
                    cell.progressView.backgroundColor = UIColor(red: 74.0/255.0, green: 166.0/255.0, blue: 65.0/255.0, alpha: 1.0)
                }
                if parkData.parkDefunct {
                    print("this park is closed")
                    cell.progressView.backgroundColor = UIColor.lightGray}
            }
            cell.progressView.frame.size.width = progressToShow
            
            return cell
        }
            
            //sets up all parks table
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "allCell", for: indexPath) as! AllParksTableViewCell
            let parkData = allParksList[indexPath.row]
            cell.parkNameLabel.text = parkData.name
            cell.locationLabel.text = parkData.location
            cell.fractionLabel.text = "\(parkData.ridesRidden!)/\(parkData.totalRides!)"
            cell.numberOfCheckins.text = String(parkData.numberOfCheckIns)
            
            if screenSize.width == 320.0{
                ConfigureSmallerLayout().allParksCellLayout(allParksCell: cell)
            }
            
            
            let rides: Double = Double(parkData.ridesRidden)
            let total = Double(parkData.totalRides)
            var progressToShow = CGFloat(0)
            if total != 0{
                progressToShow = CGFloat(Double(cell.fractionViewWidth.constant) * (rides/total))
                if rides/total == 1{
                    cell.progressView.backgroundColor = UIColor(red: 250/255.0, green: 204/255.0, blue: 73/255.0, alpha: 1.0)
                } else{
                    cell.progressView.backgroundColor = UIColor(red: 74.0/255.0, green: 166.0/255.0, blue: 65.0/255.0, alpha: 1.0)
                }
                if parkData.parkDefunct {
                    print("this park is closed")
                    cell.progressView.backgroundColor = UIColor.lightGray}
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
                //self.allParksList[index].favorite = false
                //self.parksCoreData.saveFavoritesChange(modifyedPark: self.allParksList[index], add: false)
                
                let parkItem = self.allParksList[index]
                parkItem.ref?.updateChildValues([
                    "favorite": false
                    ])
                
                
                self.favoiteParkList.remove(at: indexPath.row)
                
                //Animate away favorites view to dissappear if the last park is being removed from the list
                self.favoitesHeight = 70
                if self.allParksIsVisible{
                    print("All parks View is Visible NOW")
                    var favoritesViewAlpha:CGFloat = 1.0
                    if self.favoiteParkList.count == 0{
                        self.favoitesHeight = 70
                        favoritesViewAlpha = 0.0
                    } else{
                        self.favoitesHeight = self.favoritesHeightMax
                    }
                    self.favoritesViewHeightConstrant.constant = self.favoitesHeight
                    UIView.animate(withDuration: 0.6, animations: {
                        self.favoritesTableView.alpha = favoritesViewAlpha
                        self.view.layoutIfNeeded()
                    })
                    
                }
                
                
                self.favoritesTableView.deleteRows(at: [indexPath], with: .left)
            } else{
                //Only add if it isn't already a favorite
                if !self.allParksList[indexPath.row].favorite{
                    //self.allParksList[indexPath.row].favorite = true
                    //self.parksCoreData.saveFavoritesChange(modifyedPark: self.allParksList[indexPath.row], add: true)
                    
                    var parkItem = self.allParksList[indexPath.row]
                    parkItem.ref?.updateChildValues([
                        "favorite": true
                        ])
                    
                    parkItem.favorite = true
                    self.allParksList[indexPath.row].favorite = true
                    
                    //Animate the favorites view to appear if the first park is being added to the list
                    if self.favoiteParkList.count == 0{
                        
                        print("PARK SEARCH \(self.isSearchingMyParks)")
                        if !self.isSearchingMyParks{
                            if self.favoritesViewIsVisible{
                                print("Favorites is visible")
                                self.favoitesHeight = self.favoritesHeightMax
                                self.favoritesViewHeightConstrant.constant = self.favoitesHeight
                                UIView.animate(withDuration: 0.6, animations: {
                                    self.favoritesTableView.alpha = 1.0
                                    self.view.layoutIfNeeded()
                                })
                            } else{
                                self.favoitesHeight = self.favoritesHeightMax
                            }
                        } else{
                            self.view.layoutIfNeeded()
                        }
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
            favoriteAction.title = "Remove from Favorites"
            favoriteAction.backgroundColor = favoritesGreen
        } else{
            if allParksList[indexPath.row].favorite{
                favoriteAction.title = "Already a Favorite"
            }else{
                favoriteAction.backgroundColor = favoritesGreen
                favoriteAction.title = "Add to Favorites"
            }
        }
        let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    //Remove park from list (only allowed to do this from all parks list)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive, title:  "removePark", handler: { (ac:UIContextualAction, view:UIView, success:@escaping (Bool) -> Void) in
            let deleteAlertController = UIAlertController(title: "Delete \(self.allParksList[indexPath.row].name!)", message: "This action will permanently delete your progress for \(self.allParksList[indexPath.row].name!)", preferredStyle: .alert)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) -> Void in
                success(true)
                self.removeParkFromList(parkID: self.allParksList[indexPath.row].parkID, indexPath: indexPath.row)
                
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                success(false)
            }
            deleteAlertController.addAction(cancel)
            deleteAlertController.addAction(delete)
            self.present(deleteAlertController, animated: true, completion:nil)
        })
        
        let removeFromFavorites = UIContextualAction(style: .normal, title:  "removeFavorites", handler: { (ac:UIContextualAction, view:UIView, success:@escaping (Bool) -> Void) in
            let index = self.findIndexInAllParksList(parkID: self.favoiteParkList[indexPath.row].parkID)
            self.allParksList[index].favorite = false
            //self.parksCoreData.saveFavoritesChange(modifyedPark: self.allParksList[index], add: false)
            
            let parkItem = self.allParksList[index]
            parkItem.ref?.updateChildValues([
                "favorite": false
                ])
            self.favoiteParkList.remove(at: indexPath.row)
            
            
            
            self.favoitesHeight = 70
            if self.allParksIsVisible{
                print("All parks View is Visible NOW")
                var favoritesViewAlpha:CGFloat = 1.0
                if self.favoiteParkList.count == 0{
                    self.favoitesHeight = 70
                    favoritesViewAlpha = 0.0
                } else{
                    self.favoitesHeight = self.favoritesHeightMax
                }
                self.favoritesViewHeightConstrant.constant = self.favoitesHeight
                UIView.animate(withDuration: 0.6, animations: {
                    self.favoritesTableView.alpha = favoritesViewAlpha
                    self.view.layoutIfNeeded()
                })
                
            }
            
            
            self.favoritesTableView.deleteRows(at: [indexPath], with: .left)
            success(true)
        })
        
        
        
        if tableView == self.allParksTableView {
            removeAction.title = "Delete"
            let configuration = UISwipeActionsConfiguration(actions: [removeAction])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
        } else{
            removeFromFavorites.title = "Remove from Favorites"
            removeFromFavorites.backgroundColor = favoritesGreen
            let configuration = UISwipeActionsConfiguration(actions: [removeFromFavorites])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
        }
        
    }
}
