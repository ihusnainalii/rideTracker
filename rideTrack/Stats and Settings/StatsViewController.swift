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

class StatsViewController: UIViewController, DataModelProtocol {

    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var statsContainerViewController: StatsContainerViewController!

    var allParksList = [ParksList]()
    var arrayOfAllParks = [ParksModel]()
    var simulateLocation: Int!
    var firstUpdate = true
    let settingsColor = UIColor(red: 211/255.0, green: 213/255.0, blue: 215/255.0, alpha: 1.0)

    
    var attractionCount = 0
    var parksCompleteCount = 0
    var activeAttractionCount = 0
    var extinctAttractionCount = 0
    var experiencesCount = 0
    var countriesCount = 0
    var rollerCoasterCount = 0
    var rollerCoasterExperience = 0
    var darkRidesCount = 0
    var darkRideExperience = 0
    var waterRidesCount = 0
    var waterRideExperience = 0
    var flatRidesCount = 0
    var flatRideExperience = 0
    var showCount = 0
    var showExperience = 0
    var spectacularCount = 0
    var spectacularExperience = 0
    var filmCount = 0
    var filmExperience = 0
    var playArea = 0
    var playAreaExperience = 0
    var childrensRidesCount = 0
    var childrensRideExperience = 0
    var transportRidesCount = 0
    var transportRideExperience = 0
    var paradeCount = 0
    var paradeExperience = 0
    var exploreCount = 0
    var exploreExperience = 0
    var upchargeCount = 0
    var upchargeExperience = 0
    
    var numberOfParksAnalized = 0
    
    var attractionListRef: DatabaseReference!
    var statsListRef: DatabaseReference!
    var user: User!
    var id: String!
    var statsFilter = "lifeTime"
    var stats: Stats!
    var statsArray = [Stats]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        let userID = Auth.auth().currentUser
        id = userID?.uid
        print(id!)
        
        self.statsListRef = Database.database().reference(withPath: "stats-list/\(id!)")
        
        statsListRef.observe(.value, with: { snapshot in
            var newStats: [Stats] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let statItem = Stats(snapshot: snapshot) {
                    newStats.append(statItem)
                }
            }
            print("Gettings stats-list")
            self.statsArray = newStats
            self.stats = self.statsArray[0]
            self.updateStatLabels()
            if self.firstUpdate{
                self.updateStatistics()
            }
            self.firstUpdate = false
        })
        
      
        configureView()
        //mapView.delegate = self
        //updateMap()
        // Do any additional setup after loading the view.
    }
    
    func updateStatLabels(){
        print("Updating lables")
        statsContainerViewController.stats = stats
        statsContainerViewController.updateAllStats(stats: stats)
    }
    
    
    
    func updateStatistics(){
        let dataModel = DataModel()
        dataModel.delegate = self
        
        
        for i in 0..<allParksList.count{
            
            if allParksList[i].totalRides == allParksList[i].ridesRidden && allParksList[i].totalRides != 0{
                parksCompleteCount += 1
            }
            
            let urlPath = "http://www.beingpositioned.com/theparksman/attractiondbservice.php?parkid=\(allParksList[i].parkID!)"
            dataModel.downloadData(urlPath: urlPath, dataBase: "attractions", returnPath: String(allParksList[i].parkID!))
        }
    }
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        var parksAttractionList: [AttractionsModel] = []
        
        for i in 0..<items.count{
            parksAttractionList.append(items[i] as! AttractionsModel)
        }
         parksAttractionList.sort { $0.rideID < $1.rideID }
        attractionListRef = Database.database().reference(withPath: "attractions-list/\(id!)/\(returnPath)")

        attractionListRef.queryOrdered(byChild: "rideID").observeSingleEvent(of: .value, with: { snapshot in
            var newAttractions: [AttractionList] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let attractionItem = AttractionList(snapshot: snapshot) {
                    newAttractions.append(attractionItem)
                }
            }
            if newAttractions.count != 0{
                self.calculateParksStats(parksAttractionList: parksAttractionList, userAttractionList: newAttractions)
            } else{
                self.numberOfParksAnalized += 1
            }
        })

    }
    
    func calculateParksStats(parksAttractionList: [AttractionsModel], userAttractionList: [AttractionList]){
 
        var userAttractionIndex = 0

        for i in 0..<parksAttractionList.count{
            if parksAttractionList[i].rideID == userAttractionList[userAttractionIndex].rideID{
                attractionCount += 1
                experiencesCount += userAttractionList[userAttractionIndex].numberOfTimesRidden
                if parksAttractionList[i].active == 1{
                    activeAttractionCount += 1
                } else{
                    extinctAttractionCount += 1
                }
                
                switch parksAttractionList[i].rideType {
                case 1:
                    rollerCoasterCount += 1
                    rollerCoasterExperience += userAttractionList[userAttractionIndex].numberOfTimesRidden
                case 2:
                    waterRidesCount += 1
                    waterRideExperience += userAttractionList[userAttractionIndex].numberOfTimesRidden
                case 3:
                    childrensRidesCount += 1
                    childrensRideExperience += userAttractionList[userAttractionIndex].numberOfTimesRidden
                case 4:
                    flatRidesCount += 1
                    flatRideExperience += userAttractionList[userAttractionIndex].numberOfTimesRidden
                case 5:
                    transportRidesCount += 1
                    transportRideExperience += userAttractionList[userAttractionIndex].numberOfTimesRidden
                case 6:
                    darkRidesCount += 1
                    darkRideExperience += userAttractionList[userAttractionIndex].numberOfTimesRidden
                case 7:
                    exploreCount += 1
                    exploreExperience += userAttractionList[userAttractionIndex].numberOfTimesRidden
                case 8:
                    spectacularCount += 1
                    spectacularExperience += userAttractionList[userAttractionIndex].numberOfTimesRidden
                case 9:
                    showCount += 1
                    showExperience += userAttractionList[userAttractionIndex].numberOfTimesRidden
                case 10:
                    filmCount += 1
                    filmExperience += userAttractionList[userAttractionIndex].numberOfTimesRidden
                case 11:
                    paradeCount += 1
                    paradeExperience += userAttractionList[userAttractionIndex].numberOfTimesRidden
                case 12:
                    playArea += 1
                    playAreaExperience += userAttractionList[userAttractionIndex].numberOfTimesRidden
                case 13:
                    upchargeCount += 1
                    upchargeExperience += userAttractionList[userAttractionIndex].numberOfTimesRidden
                default:
                    print("Not valid rideTypeID")
                }
 
                if (userAttractionIndex+1) == userAttractionList.count{
                    break
                } else{
                    userAttractionIndex += 1
                }
            }
        }
        
        numberOfParksAnalized += 1
        
        if numberOfParksAnalized == allParksList.count{
            print("updating stats")
            let statsItem = statsArray[0]
            statsItem.ref?.updateChildValues([
                "parks": allParksList.count,
                "attractions": attractionCount,
                "extinctAttracions": extinctAttractionCount,
                "activeAttractions": activeAttractionCount,
                "experiences": experiencesCount,
                "parksCompleted": parksCompleteCount,
                "countries": countriesCount,
                
                "rollerCoasters": rollerCoasterCount,
                "waterRides": waterRidesCount,
                "childrensRides": childrensRidesCount,
                "flatRides": flatRidesCount,
                "transportRides": transportRidesCount,
                "darkRides": darkRidesCount,
                "exploreRides": exploreCount,
                "spectaculars": spectacularCount,
                "shows": showCount,
                "films": filmCount,
                "playAreas": playArea,
                "upchargeRides": upchargeCount,
                "parades": paradeCount,

                "rollerCoasterExperience": rollerCoasterExperience,
                "waterExperience": waterRideExperience,
                "childrensRideExperience": childrensRideExperience,
                "flatRideExperience": flatRideExperience,
                "transportExperience": transportRideExperience,
                "darkRidesExperience": darkRideExperience,
                "exploreExperience": exploreExperience,
                "spectacularExperince": spectacularExperience,
                "showExperience": showExperience,
                "filmsExperience": filmExperience,
                "playAreaExperience": playAreaExperience,
                "upchargeExperience": upchargeExperience,
                "paradesExperience": paradeExperience
                ])
            activityIndicator.isHidden = true
        }
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
        if segue.identifier == "StatsContainer" {
            print("GETTING CONTAINER VIEW")
            statsContainerViewController = segue.destination as? StatsContainerViewController
            statsContainerViewController.statsViewController = self
            print("COUNT: \(allParksList.count)")
            statsContainerViewController.allParksList = allParksList
            statsContainerViewController.arrayOfAllParks = arrayOfAllParks
        }
//        if segue.identifier == "toMapView"{
//            let mapVC = segue.destination as! MapViewController
//            mapVC.arrayOfAllParks = arrayOfAllParks
//            mapVC.allParksList = allParksList
//        }
    }
    
 
    
    func configureView(){
        //addShadowAndRoundRec(uiView: statsView)
        
        doneButton.backgroundColor = settingsColor
        doneButton.layer.cornerRadius = 5
    }
    
    func addShadowAndRoundRec(uiView: UIView){
        uiView.layer.cornerRadius = 7
        uiView.layer.shadowOpacity = 0.3
        uiView.layer.shadowOffset = CGSize.zero
        uiView.layer.shadowRadius = 5
        uiView.layer.backgroundColor = UIColor.white.cgColor
    }
    
    @IBAction func unwindToStatsView(sender: UIStoryboardSegue) {
        print("Back to stats view")
    }
    
}
