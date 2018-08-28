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

    @IBOutlet weak var parkCountLabel: UILabel!
    @IBOutlet weak var attractionCountLabel: UILabel!
    @IBOutlet weak var parkCompleteCountLabel: UILabel!
    @IBOutlet weak var activeAttractionCountLabel: UILabel!
    @IBOutlet weak var defunctAttractionCountLabel: UILabel!
    @IBOutlet weak var experiencesCountLabel: UILabel!
    @IBOutlet weak var countriesCountLabel: UILabel!
    @IBOutlet weak var rollerCoasterCountLabel: UILabel!
    @IBOutlet weak var darkRideCountLabel: UILabel!
    @IBOutlet weak var waterRideCountLabel: UILabel!
    @IBOutlet weak var flatRideCountLabel: UILabel!
    @IBOutlet weak var showCountLabel: UILabel!
    @IBOutlet weak var filmCountLabel: UILabel!
    @IBOutlet weak var spectacularCountLabel: UILabel!
    @IBOutlet weak var updatingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playAreaLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var parkAndAttractionsView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var attractionView: UIView!
    @IBOutlet weak var experiencesView: UIView!
    @IBOutlet weak var parksCompleteView: UIView!
    @IBOutlet weak var rideTypesView: UIView!
    @IBOutlet weak var mapsView: UIView!
    @IBOutlet weak var achievementsView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollWidth: NSLayoutConstraint!
    let screenSize = UIScreen.main.bounds

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
    var darkRidesCount = 0
    var waterRidesCount = 0
    var flatRidesCount = 0
    var showCount = 0
    var showSpectacularCount = 0
    var filmCount = 0
    var playArea = 0
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
        
        if screenSize.width == 320 {
            scrollWidth.constant = 304
        }
        
        configureView()
        //mapView.delegate = self
        updateMap()
        // Do any additional setup after loading the view.
    }
    
    func updateStatLabels(){
        print("Updating lables")
        print(statsArray.count)
        print(statsArray[0].parks)
        print(stats.parks)
        parkCountLabel.text = String(stats.parks)
        attractionCountLabel.text = String(stats.attractions)
        parkCompleteCountLabel.text = String(stats.parksCompleted)
        activeAttractionCountLabel.text = String(stats.activeAttractions)
        defunctAttractionCountLabel.text = String(stats.extinctAttracions)
        experiencesCountLabel.text = String(stats.experiences)
        countriesCountLabel.text = String(stats.countries)
        rollerCoasterCountLabel.text = String(stats.rollerCoasters)
        darkRideCountLabel.text = String(stats.darkRides)
        waterRideCountLabel.text = String(stats.waterRides)
        flatRideCountLabel.text = String(stats.flatRides)
        showCountLabel.text = String(stats.shows)
        spectacularCountLabel.text = String(stats.spectaculars)
        filmCountLabel.text = String(stats.films)
        playAreaLabel.text = String(stats.playAreas)
    }
    
    func updateMap(){
        allParksList.sort { $0.parkID < $1.parkID }
        arrayOfAllParks.sort { $0.parkID < $1.parkID }
        var allParksIndex = 0
        var myParksIndex = 0
        var countryList: [String] = []
        repeat {
            if allParksList[myParksIndex].parkID == arrayOfAllParks[allParksIndex].parkID{
                myParksIndex += 1
//                var newCountry = false
//                if arrayOfAllParks.count != 0{
//                    countryList.append(arrayOfAllParks[0].country)
//                    for i in 1..<countryList.count{
//                        print("compare")
//                        print(countryList[i])
//                        print(arrayOfAllParks[allParksIndex].country)
//                        if countryList[i] != arrayOfAllParks[allParksIndex].country{
//                            newCountry = true
//                        }
//                    }
//                    if newCountry{
//                        countriesCount += 1
//                        countryList.append(arrayOfAllParks[allParksIndex].country)
//                        print(arrayOfAllParks[allParksIndex].country)
//                        print("Country Count \(countriesCount)")
//                    }
//                }
                
                
                //Set up map view here
                
                
                
//                let parkMapAnnotation = ParkMap(parkName: arrayOfAllParks[allParksIndex].name, longitude: arrayOfAllParks[allParksIndex].longitude, latitude: arrayOfAllParks[allParksIndex].latitude)
//                mapView.addAnnotation(parkMapAnnotation)
            }
            allParksIndex += 1
        } while myParksIndex < allParksList.count
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
                case 2:
                    waterRidesCount += 1
                case 4:
                    flatRidesCount += 1
                case 6:
                    darkRidesCount += 1
                case 8:
                    showSpectacularCount += 1
                case 9:
                    showCount += 1
                case 10:
                    filmCount += 1
                case 12:
                    playArea += 1
                default:
                    print("Not saving this ride type to stats")
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
                "rollerCoasters": rollerCoasterCount,
                "waterRides": waterRidesCount,
                "flatRides": flatRidesCount,
                "darkRides": darkRidesCount,
                "spectaculars": showSpectacularCount,
                "shows": showCount,
                "playAreas": playArea,
                "films": filmCount,
                "parksCompleted": parksCompleteCount,
                "countries": countriesCount
                ])
            updatingIndicator.isHidden = true
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
        if segue.identifier == "toMapView"{
            let mapVC = segue.destination as! MapViewController
            mapVC.arrayOfAllParks = arrayOfAllParks
            mapVC.allParksList = allParksList
        }
    }
    
    func configureView(){
        addShadowAndRoundRec(uiView: profileView)
        addShadowAndRoundRec(uiView: parkAndAttractionsView)
        addShadowAndRoundRec(uiView: countryView)
        addShadowAndRoundRec(uiView: attractionView)
        addShadowAndRoundRec(uiView: experiencesView)
        addShadowAndRoundRec(uiView: parksCompleteView)
        addShadowAndRoundRec(uiView: rideTypesView)
        addShadowAndRoundRec(uiView: achievementsView)
        addShadowAndRoundRec(uiView: mapsView)
        
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
