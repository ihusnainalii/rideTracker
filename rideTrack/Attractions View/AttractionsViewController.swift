//
//  AttractionsViewController.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/15/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
// Pushed may 8, 5:40
import UIKit
import CoreData
import Foundation


class AttractionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataModelProtocol, AttractionsTableViewCellDelegate {
    
    
    @IBOutlet weak var attractionsTableView: UITableView!
    @IBOutlet weak var parkLabel: UILabel!
    @IBOutlet weak var NumCompleteLabel: UILabel!
    @IBOutlet weak var extinctLabel: UILabel!
    @IBOutlet weak var extinctText: UITextField!
    @IBOutlet weak var rectangleView: UIView!
    @IBOutlet weak var suggestButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var VisualEffectsLayer: UIVisualEffectView!
    @IBOutlet weak var rideCountLabel: UILabel!
    @IBOutlet weak var extinctCountLabel: UILabel!
    @IBOutlet weak var emptyParkInstructionsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var darkenLayer: UIView!
    @IBOutlet weak var downBar: UIButton!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationViewBottomConstrant: NSLayoutConstraint!
    
    let screenSize = UIScreen.main.bounds
    
    var userDataBaseIndex = 0
    var titleName = ""
    var parkID = 0
    var attractionListForTable = [AttractionsModel]()
    var savedItems: NSArray!
    var parkData: ParksModel!
    var showExtinct = 0
    var isIgnored = false
    //From the datamigration tool:
    var userAttractionDatabase: [UserAttractionProvider]!
    var ignore = [Int]()
    let ignoreList = UserDefaults.standard
    var numIgnore = 0
    var comeFromDetails = false
    var initialToucnPoint : CGPoint = CGPoint(x: 0, y: 0)
    var parksViewController: ViewController!
    var animateRow = -1
    var countOfRemove = 0
    var selectedAttractionsList: [NSManagedObject] = []
    
    let greenBar = UIColor(red: 29.0/255.0, green: 127.0/255.0, blue: 70.0/255.0, alpha: 1.0)
    let goldBar = UIColor(red: 250/255.0, green: 204/255.0, blue: 73/255.0, alpha: 1.0)
    let lightGreyBar = UIColor(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
    var userAttractions: [NSManagedObject] = []
    var userNumExtinct = 0
    var userRidesRidden = 0
    var numExtinctSelected = 0
    var RidesComplete = ""
    var extinctComplete = ""
    var rideID = 0
    var rideName = ""
    var totalNumExtinct = 0
    
    override func viewDidLoad() {
        print("Show incrementor is \(parkData.incrementorEnabled)")
        super.viewDidLoad()
        
        emptyParkInstructionsLabel.alpha = 0.0
        self.darkenLayer.backgroundColor = UIColor.clear
        animateRow = -1
        suggestButton.layer.cornerRadius = 7
        suggestButton.layer.shadowOpacity = 0.4
        suggestButton.layer.shadowOffset = CGSize.zero
        suggestButton.layer.shadowRadius = 7
        progressBar.progressTintColor = greenBar
        progressBar.trackTintColor = lightGreyBar
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 5)
        
        rectangleView.backgroundColor = UIColor.clear
        rectangleView.clipsToBounds = true
        VisualEffectsLayer.layer.cornerRadius = 10.0
        VisualEffectsLayer.clipsToBounds = true
        
        notificationView.layer.shadowOffset = CGSize.zero
        notificationView.layer.shadowRadius = 5
        notificationView.layer.shadowOpacity = 0.3
        notificationView.layer.cornerRadius = 10
        notificationViewBottomConstrant.constant = -64
        
        
        downBar.setImage(UIImage(named: "Down Bar"), for: .normal)
        
        parkLabel.text = titleName
        
        if screenSize.width == 320.0{
            ConfigureSmallerLayout().attractionsViewLayout(attractionsView: self)
        }
        
        self.attractionsTableView.delegate = self
        self.attractionsTableView.dataSource = self
        print(parkID)
        let urlPath = "http://www.beingpositioned.com/theparksman/attractiondbservice.php?parkid=\(parkID)"
        let dataModel = DataModel()
        // print ("There are ", feedItems.count, " attactions in park ", parkID)
        dataModel.delegate = self
        
        dataModel.downloadData(urlPath: urlPath, dataBase: "attractions", returnPath: "attractions")
        ignore = ignoreList.array(forKey: "SavedIgnoreListArray")  as? [Int] ?? [Int]()
 
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        savedItems = items
        activityIndicator.stopAnimating()
        for i in 0..<items.count{
            attractionListForTable.append(items[i] as! AttractionsModel)
        }
        
        if (items.count == 0){
            print ("this park is empty")
            UIView.animate(withDuration: 0.5, animations: ({
                self.emptyParkInstructionsLabel.alpha = 1.0
                self.attractionsTableView.alpha = 0.0
            }))
            
            
        }
        else {
            if (userAttractionDatabase != nil){
                userNumExtinct = 0
                totalNumExtinct = 0
                numIgnore = 0
                userRidesRidden = 0
                numExtinctSelected = 0
                countOfRemove = 0
                userDataBaseIndex = 0
                
                let maxUserAttractionCount = userAttractionDatabase.count
                for i in 0..<attractionListForTable.count{
                    if userDataBaseIndex < maxUserAttractionCount{
                        
                        if (attractionListForTable[i]).rideID == userAttractionDatabase[userDataBaseIndex].rideID{
                            
                            //The user does have data for this ride
                            // print ("We have ridden ride # ", userAttractionDatabase[userDataBaseIndex].rideID!)
                            attractionListForTable[i].isCheck = true
                            userRidesRidden += 1
                            
                            attractionListForTable[i].numberOfTimesRidden = userAttractionDatabase[userDataBaseIndex].numberOfTimesRidden
                            attractionListForTable[i].dateLastRidden = userAttractionDatabase[userDataBaseIndex].dateLastRidden
                            attractionListForTable[i].dateFirstRidden = userAttractionDatabase[userDataBaseIndex].dateFirstRidden
                            
                            if attractionListForTable[i].active == 0 {
                                userNumExtinct += 1
                            }
                            userDataBaseIndex += 1
                        }
                            
                        else{
                            //User doesn't have any data stored for this ride
                            attractionListForTable[i].numberOfTimesRidden = 0
                            
                        }
                        
                    }
                    else{
                        //The user does not have any data stored for any of the rest of the rides in this park. Can this be replaced with a break?
                        attractionListForTable[i].numberOfTimesRidden = 0
                    }
                    
                    if attractionListForTable[i].active == 0 && showExtinct == 1 {
                        totalNumExtinct += 1
                    }
                    
                    if attractionListForTable[i].numberOfTimesRidden == nil{
                        print("attraction list at rideID \(attractionListForTable[i].rideID!) found nil")
                        attractionListForTable[i].numberOfTimesRidden = 0
                    }
                    
                    if ignore.count == 0 {
                        attractionListForTable[i].isIgnored = false
                    } //setting the rides to be ignored
                    for j in 0..<ignore.count{
                        if ignore[j] == attractionListForTable[i].rideID{
                            attractionListForTable[i].isIgnored = true
                            numIgnore += 1
                            break
                        }
                        else {
                            attractionListForTable[i].isIgnored = false
                        }
                        
                    }
                }
            }
        }
        //Hide EXTINCT ATTRACTIONS
        if(showExtinct == 0){
            for i in 0..<attractionListForTable.count{ //sizeOfList
                if ((attractionListForTable[i - countOfRemove]).active == 0 && showExtinct == 0 && (attractionListForTable[i - countOfRemove]).isCheck == false){
                    //attractionListForTable.removeObject(at: i - countOfRemove)
                    attractionListForTable.remove(at: i-countOfRemove)
                    countOfRemove = countOfRemove+1
                    continue
                }
                else if (attractionListForTable[i - countOfRemove]).active == 0 && (attractionListForTable[i - countOfRemove]).isCheck == true {
                    numExtinctSelected += 1
                }
            }
        }
        print ("There are this many num extinct selected,", numExtinctSelected )
        //If user wants to show extinct, sort so that the active rides are on top of the list
        if attractionListForTable.count != 1{
            //Need both steps to sort name alphabetically and by active or not
            attractionListForTable.sort { ($0.active, $1.name) > ($1.active, $0.name) }
        }
        
        if showExtinct == 1 || userNumExtinct >= 1 {
            extinctText.isHidden = false
            extinctLabel.isHidden = false
            extinctComplete = String (userNumExtinct)
            // extinctComplete += "/"
            //extinctComplete += String (totalNumExtinct)
            extinctText.text = extinctComplete
        }
        else{
            extinctText.isHidden = true
            extinctLabel.isHidden = true
        }
        
        if (self.attractionListForTable.count - totalNumExtinct-numIgnore-numExtinctSelected) > parkData.totalRides{
            animateInNotifcationView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) { // change 2 to desired number of seconds
                // Your code with delay
                self.animateAwayNotificationView()
            }
        }
        
        updatingRideCount(parkID: parkID, userCount: userRidesRidden-userNumExtinct, totNum: attractionListForTable.count - totalNumExtinct-numIgnore-numExtinctSelected)
        
        
       
        
        self.attractionsTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Configure for iPhone 5 sizes
        if screenSize.width == 320.0{
            return 48
        } else{
            return 54
        }
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attractionListForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rideCell", for: indexPath) as! AttractionsTableViewCell
        
        cell.delegate = self
        let item: AttractionsModel = attractionListForTable[indexPath.row]
        
        if parkData.incrementorEnabled{
            if ((attractionListForTable[indexPath.row]).isCheck){
                cell.rideCountViewLeadingConstraint.constant = 3
                cell.attractionButton.setImage(#imageLiteral(resourceName: "Plus Attraction"), for: .normal)
                cell.numberOfRidesLabel.alpha = 1.0
                cell.numberOfRidesLabel.text = String(item.numberOfTimesRidden)
                configureCellIncrementing(cell: cell, item: item)
            } else if attractionListForTable[indexPath.row].isIgnored{
                configureCellIgnore(cell: cell, item: item)
            } else{
                configureCellCheck(cell: cell, item: item)
            }
        } else{
            if ((attractionListForTable[indexPath.row]).isCheck){
                cell.rideCountViewLeadingConstraint.constant = -1
                cell.attractionButton.setImage(#imageLiteral(resourceName: "green check"), for: .normal)
                cell.numberOfRidesLabel.alpha = 0.0
                cell.numberOfRidesLabel.text = ""
                attractionListForTable[indexPath.row].numberOfTimesRidden = 1
                configureCellIncrementing(cell: cell, item: item)
            } else if attractionListForTable[indexPath.row].isIgnored{
                configureCellIgnore(cell: cell, item: item)
            } else{
                configureCellCheck(cell: cell, item: item)
            }
        }
        
        if (attractionListForTable[indexPath.row]).active == 1 {
            cell.backgroundColor = UIColor.clear
        }
        else{
            cell.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        }
        
        cell.rideName!.text = item.name
        cell.rideTypeLabel.text = convertRideTypeID(rideTypeID: item.rideType)
        
        
        //If iPhone 5s
        if screenSize.width == 320.0{
            ConfigureSmallerLayout().attractionCellLayout(attractionsCell: cell)
        }
        
        
        return cell
    }
    
    func configureCellIncrementing(cell: AttractionsTableViewCell, item: AttractionsModel){
        cell.rideName?.textColor = UIColor.black
        //attractionListForTable[indexPath.row].isIgnored = false
    }
    
    func configureCellIgnore(cell: AttractionsTableViewCell, item: AttractionsModel){
        cell.rideName?.textColor = UIColor.gray
        cell.attractionButton.setImage(#imageLiteral(resourceName: "Ignore Button"), for: .normal)
        //attractionListForTable[indexPath.row].isIgnored = true
        cell.rideCountViewLeadingConstraint.constant = -1
        cell.numberOfRidesLabel.alpha = 0.0
        cell.numberOfRidesLabel.text = ""
    }
    
    func configureCellCheck(cell: AttractionsTableViewCell, item: AttractionsModel){
        cell.attractionButton.setImage(#imageLiteral(resourceName: "Check Button"), for: .normal)
        cell.rideName?.textColor = UIColor.black
        cell.numberOfRidesLabel.alpha = 0.0
        cell.rideCountViewLeadingConstraint.constant = -1
        //attractionListForTable[indexPath.row].isIgnored = false
        //cell.numberOfRidesLabel.alpha = 0.0
        cell.numberOfRidesLabel.text = ""
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if (attractionListForTable[indexPath.row]).numberOfTimesRidden != 0{
            let minusAction = UIContextualAction(style: .normal, title: "Minus", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print ("Subtracting")
                success(true)
                self.attractionCellNegativeIncrement(indexPath: indexPath)
                //success(true)
            })
            let minusColor = UIColor(red: 203/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            minusAction.backgroundColor = minusColor
            minusAction.title = "Minus"
            minusAction.image = UIImage (named:"Minus Button")
            let configurations = UISwipeActionsConfiguration(actions: [minusAction])
            configurations.performsFirstActionWithFullSwipe = true
            return configurations
        }
        else {
            return UISwipeActionsConfiguration.init()
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if (attractionListForTable[indexPath.row]).active == 1 && attractionListForTable[indexPath.row].isCheck == false {
            let ignoreAction = UIContextualAction(style: .normal, title: "Ignore", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("ignore button tapped on ride")
                let cell = self.attractionsTableView.cellForRow(at: indexPath) as! AttractionsTableViewCell

                if self.attractionListForTable[indexPath.row].isIgnored == false {
                    self.ignore.append(self.attractionListForTable[indexPath.row].rideID!)
                    print("Ignoring ", self.attractionListForTable[indexPath.row].name!)
                    self.attractionListForTable[indexPath.row].isIgnored = true
                    self.numIgnore += 1
                    
                    cell.rideName?.textColor = UIColor.gray
                    cell.attractionButton.setImage(#imageLiteral(resourceName: "Ignore Button"), for: .normal)
                }
                else {
                    for i in 0..<(self.ignore.count) {
                        if self.ignore[i] == self.attractionListForTable[indexPath.row].rideID{
                            self.ignore.remove(at: i)
                            break
                        }
                    }
                    print ("Unignoring ", self.attractionListForTable[indexPath.row].name!)
                    self.attractionListForTable[indexPath.row].isIgnored = false
                    self.numIgnore -= 1
                    
                    cell.attractionButton.setImage(#imageLiteral(resourceName: "Check Button"), for: .normal)
                    cell.rideName?.textColor = UIColor.black
                }
                self.ignoreList.set(self.ignore, forKey: "SavedIgnoreListArray")
                
                self.updatingRideCount(parkID: self.parkID, userCount: self.userRidesRidden-self.userNumExtinct, totNum: self.attractionListForTable.count - self.totalNumExtinct-self.numIgnore-self.numExtinctSelected)
                success(true)

                
            })
            
            ignoreAction.title = attractionListForTable[indexPath.row].isIgnored ? "Include" : "Exclude"
            ignoreAction.backgroundColor = attractionListForTable[indexPath.row].isIgnored ? .blue : .gray
            let configurations = UISwipeActionsConfiguration(actions: [ignoreAction])
            configurations.performsFirstActionWithFullSwipe = true
            return configurations //UISwipeActionsConfiguration(actions: [ignoreAction])
        }
        else {
            return UISwipeActionsConfiguration.init()
        }
    }
    
    func convertRideTypeID(rideTypeID: Int) -> String {
        switch rideTypeID {
        case -1:
            return ""
        case 1:
            return "Roller Coaster"
        case 2:
            return "Water Ride"
        case 3:
            return "Children's Ride"
        case 4:
            return "Flat Ride"
        case 5:
            return "Transport Ride"
        case 6:
            return "Dark Ride"
        case 7:
            return "Explore"
        case 8:
            return "Spectacular"
        case 9:
            return "Show"
        case 10:
            return "Film"
        case 11:
            return "Parade"
        case 12:
            return "Play Area"
        case 13:
            return "Upcharge"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func attractionCellTapButton(_ sender: AttractionsTableViewCell) {
        print("plus")
        guard let indexPath = attractionsTableView.indexPath(for: sender) else { return }
        if !attractionListForTable[indexPath.row].isCheck && !attractionListForTable[indexPath.row].isIgnored{
            addFirstCheckRide(indexPath: indexPath)
        } else if attractionListForTable[indexPath.row].isCheck && !attractionListForTable[indexPath.row].isIgnored{
            positiveIncrementCount(indexPath: indexPath)
        } else{
            print("Can't change it when ignored")
        }
    }
    
    
    func addFirstCheckRide(indexPath: IndexPath){
        print ("Seclected Attraction is: ", (self.attractionListForTable[indexPath.row]).rideID)
        
        (self.attractionListForTable[indexPath.row]).isCheck = true
        self.attractionListForTable[indexPath.row].numberOfTimesRidden = 1
        self.attractionListForTable[indexPath.row].dateFirstRidden = Date()
        self.attractionListForTable[indexPath.row].dateLastRidden = Date()
        self.saveUserCheckOffNewRide(parkID: self.parkID, rideID: (self.attractionListForTable[indexPath.row]).rideID);
        
        let cell = self.attractionsTableView.cellForRow(at: indexPath) as! AttractionsTableViewCell

        if parkData.incrementorEnabled{
            cell.numberOfRidesLabel.text = String(self.attractionListForTable[indexPath.row].numberOfTimesRidden)
            UIView.animate(withDuration: 0.3, animations: ({
                cell.attractionButton.setImage(#imageLiteral(resourceName: "Plus Attraction"), for: .normal)
                cell.numberOfRidesLabel.alpha = 1.0
                cell.rideCountViewLeadingConstraint.constant = 3
                self.view.layoutIfNeeded()
                
            }))
        } else{
            cell.attractionButton.setImage(#imageLiteral(resourceName: "green check"), for: .normal)
        }
        
        
        self.view.layoutIfNeeded()
        
        if (self.attractionListForTable[indexPath.row]).active == 0{
            self.userNumExtinct += 1
        }
        
        self.userRidesRidden += 1
        print ("you have been on this many rides: ", self.userRidesRidden)
        
        //UPDATE RIDES BEEN ON
        self.updatingRideCount(parkID: self.parkID, userCount: self.userRidesRidden-self.userNumExtinct, totNum: self.attractionListForTable.count - self.totalNumExtinct-self.numIgnore-self.numExtinctSelected)
        
        self.extinctComplete = String (self.userNumExtinct)
        // self.extinctComplete += "/"
        // self.extinctComplete += String (self.totalNumExtinct)
        self.extinctText.text = self.extinctComplete
        
        if self.attractionListForTable[indexPath.row].hasScoreCard == 1{
            self.addScoreToCard(selectedRide: self.attractionListForTable[indexPath.row])
        }
    }
    
    func attractionCellNegativeIncrement (indexPath: IndexPath) {
        
        if attractionListForTable[indexPath.row].numberOfTimesRidden == 1{
            //User is unchecking the ride from their list
            deleteRideCheck(rideID: attractionListForTable[indexPath.row].rideID)
            attractionListForTable[indexPath.row].numberOfTimesRidden = 0
            attractionListForTable[indexPath.row].isCheck = false
            
            self.animateRow = indexPath.row    //"Animate here")
            //self.attractionsTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
            
            
            if (attractionListForTable[indexPath.row]).active == 0 {
                userNumExtinct -= 1
            }
            userRidesRidden -= 1
            //UPDATE RIDES BEEN ON
            
            self.updatingRideCount(parkID: self.parkID, userCount: self.userRidesRidden-self.userNumExtinct, totNum: self.attractionListForTable.count - self.totalNumExtinct-self.numIgnore-self.numExtinctSelected)
            
            self.extinctComplete = String (self.userNumExtinct)
            //  self.extinctComplete += "/"
            //  self.extinctComplete += String (self.totalNumExtinct)
            self.extinctText.text = self.extinctComplete
            
            
            //Update tableview cell
            let cell = self.attractionsTableView.cellForRow(at: indexPath) as! AttractionsTableViewCell
            cell.rideCountViewLeadingConstraint.constant = -1
            UIView.animate(withDuration: 0.5, animations: ({
                cell.attractionButton.setImage(#imageLiteral(resourceName: "Check Button"), for: .normal)
                cell.numberOfRidesLabel.alpha = 0.0
                cell.numberOfRidesLabel.text = ""
                
                self.view.layoutIfNeeded()
            }))
    
        }
        else{
            let newIncrement = attractionListForTable[indexPath.row].numberOfTimesRidden - 1
            saveIncrementRideCount(rideID:  attractionListForTable[indexPath.row].rideID, incrementTo: newIncrement, postive: false)
            attractionListForTable[indexPath.row].numberOfTimesRidden = newIncrement
            let cell = self.attractionsTableView.cellForRow(at: indexPath) as! AttractionsTableViewCell
            cell.numberOfRidesLabel.text = String(newIncrement)
        }
    }
    
    func positiveIncrementCount(indexPath: IndexPath){
        
        if parkData.incrementorEnabled{
            let cell = self.attractionsTableView.cellForRow(at: indexPath) as! AttractionsTableViewCell
            let newIncrement = attractionListForTable[indexPath.row].numberOfTimesRidden + 1
            saveIncrementRideCount(rideID:  attractionListForTable[indexPath.row].rideID, incrementTo: newIncrement, postive: true)
            attractionListForTable[indexPath.row].numberOfTimesRidden = newIncrement
            attractionListForTable[indexPath.row].dateLastRidden = Date()
            
            UIView.animate(withDuration: 0.5, animations: ({
                cell.numberOfRidesLabel.text = String(newIncrement)
            }))
        }
        
        if attractionListForTable[indexPath.row].hasScoreCard == 1{
            addScoreToCard(selectedRide: attractionListForTable[indexPath.row])
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func saveUserCheckOffNewRide(parkID: Int, rideID: Int) {
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
        newPark.setValue(1, forKey: "numberOfTimesRidden")
        newPark.setValue(Date(), forKey: "firstRideDate")
        newPark.setValue(Date(), forKey: "lastRideDate")
        print("Just saved Attraction: ", rideID)
        do {
            try managedContext.save()
            userAttractions.append(newPark)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteRideCheck(rideID: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RideTrack")
        fetchRequest.predicate = NSPredicate(format: "rideID = %@", "\(rideID)")
        do
        {
            let fetchedResults =  try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
            
            for entity in fetchedResults! {
                
                managedContext.delete(entity)
                try! managedContext.save()
                print("Deleted ride \(rideID)")
            }
        }
        catch _ {
            print("Could not delete")
            
        }
        
    }
    
    func saveIncrementRideCount(rideID: Int, incrementTo: Int, postive: Bool){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RideTrack")
        fetchRequest.predicate = NSPredicate(format: "rideID = %@", "\(rideID)")
        do
        {
            let fetchedResults =  try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
            
            
            for entity in fetchedResults! {
                entity.setValue(incrementTo, forKey: "numberOfTimesRidden")
                if postive{
                    entity.setValue(Date(), forKey: "lastRideDate")
                }
                try! managedContext.save()
                print("Increment ride \(rideID) to \(incrementTo)")
            }
        }
        catch _ {
            print("Could not increment")
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toParkInfo"{
            let infoVC = segue.destination as! ParksDetailViewController
            infoVC.parksData = parkData
            
        }
        if segue.identifier == "ToDetails"{
            let detailsVC = segue.destination as! AttractionsDetailsViewController
            let selectedIndex = attractionsTableView.indexPathForSelectedRow?.row
            
            let selectedRide = attractionListForTable[selectedIndex!]
            rideID = selectedRide.rideID
            rideName = selectedRide.name
            print (rideName)
            detailsVC.selectedRide = selectedRide
            detailsVC.userAttractionDatabase = userAttractionDatabase
            comeFromDetails = true
            detailsVC.titleName = titleName
            UIView.animate(withDuration: 0.3, animations: ({
                self.darkenLayer.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                self.view.layoutIfNeeded()
                
            }))
            
        }
        
        if segue.identifier == "toParkList"{
            print("Back to parks list")
            let parkVC = segue.destination as! ViewController
            parkVC.unwindFromAttractions(parkID: parkID)
            
        }
        
    }
    
    func addScoreToCard(selectedRide: AttractionsModel){
        let scoreAlert = UIAlertController(title: "Add  new score", message: "Enter your new score for \(selectedRide.name!) to your score card. This score card can be viewed on this attractions details page.", preferredStyle: UIAlertControllerStyle.alert)
        let userInput = UIAlertAction(title: "Add your Score", style: .default) { (alertAction) in
            let textField = scoreAlert.textFields![0] as UITextField
            if textField.text != ""{
                
                let newScore = Int(textField.text!)!
                //Saving score to ScoreCard entity in CoreData
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "ScoreCard", in: managedContext)!
                let newScoreCard = NSManagedObject(entity: entity, insertInto: managedContext)
                
                newScoreCard.setValue(newScore, forKey: "score")
                newScoreCard.setValue(selectedRide.rideID, forKeyPath: "rideID")
                newScoreCard.setValue(Date(), forKeyPath: "date")
                
                do {
                    try managedContext.save()
                    print("Saved score")
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            print("cancled")
        }
        
        scoreAlert.addTextField { (textField) in
            textField.placeholder = "Enter your score"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        scoreAlert.addAction(userInput)
        scoreAlert.addAction(cancel)
        self.present(scoreAlert, animated: true, completion:nil)
    }
    
    func updatingRideCount(parkID: Int, userCount: Int, totNum: Int) {
        self.RidesComplete = String(userCount)
        self.RidesComplete += "/"
        self.RidesComplete += String(totNum)
        self.NumCompleteLabel.text = self.RidesComplete
        parkData.totalRides = totNum
        parkData.ridesRidden = userCount
        let percentage = Float(userCount)/Float(totNum)
        
        self.progressBar.setProgress(Float(percentage), animated: true)
        if percentage == 1 {
            progressBar.progressTintColor = goldBar
        }
        else {
            progressBar.progressTintColor = greenBar
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ParkList")
        fetchRequest.predicate = NSPredicate(format: "parkID = %@", "\(parkID)")
        do
        {
            let fetchedResults =  try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
            
            for entity in fetchedResults! {
                print("updating total ride count")
                entity.setValue(userCount, forKey: "ridesRidden")
                entity.setValue(totNum, forKey: "totalRides")
                try! managedContext.save()
            }
        } catch _ {
            print("Could not save favorite")
        }
    }
    
    @IBAction func unwindToAttractionsView(sender: UIStoryboardSegue) {
        print("Back to attractions view")
        if sender.source is ParksDetailViewController{
            if parkData.incrementorEnabled{
               //attractionListForTable = saveIncrementorAttractionsListForTable
                attractionListForTable.removeAll()
                userAttractionDatabase.removeAll()
                updateAttractionFromCoreData()
                countOfRemove = 0
                itemsDownloaded(items: savedItems, returnPath: "Gettings attraction data")
            }
            attractionsTableView.reloadData()
        }
        UIView.animate(withDuration: 0.3, animations: ({
            self.darkenLayer.backgroundColor = UIColor.clear
            self.view.layoutIfNeeded()
        }))
    }
    
    @IBAction func unwindfromdetails(_ sender: UIStoryboardSegue) {
        print ("Back from deatils")
        UIView.animate(withDuration: 0.3, animations: ({
            self.darkenLayer.backgroundColor = UIColor.clear
            self.view.layoutIfNeeded()
            
        }))
    }

    
    @IBAction func panGestureReconizer(_ sender: UIPanGestureRecognizer) {
        let touchPoint = (sender as AnyObject).location(in: self.view?.window)
        
        if (sender as AnyObject).state == UIGestureRecognizerState.began{
            initialToucnPoint = touchPoint
        }
        else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialToucnPoint.y > 0 {
                self.downBar.setImage(UIImage(named: "Flat Bar"), for: .normal)
                
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialToucnPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        }
        else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialToucnPoint.y > 200 {
                self.dismiss(animated: true, completion: nil)
                parksViewController.unwindFromAttractions(parkID: parkID)
                
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.downBar.setImage(UIImage(named: "Down Bar"), for: .normal)
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    @IBAction func tapDownBar(_ sender: Any) {
        print ("tap to leave")
        parksViewController.unwindFromAttractions(parkID: parkID)
        self.dismiss(animated: true, completion: nil)
    }
    
    func animateInNotifcationView(){
        notificationViewBottomConstrant.constant = -2
        UIView.animate(withDuration: 0.4, animations: ({
            self.view.layoutIfNeeded()
        }))
    }
    
    func animateAwayNotificationView() {
        notificationViewBottomConstrant.constant = -64
        UIView.animate(withDuration: 0.4, animations: ({
            self.view.layoutIfNeeded()
        }))
    }
 
    
    
    
    func updateAttractionFromCoreData(){
        //Getting coreData Attraction data for the selected park
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "rideID", ascending: true)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RideTrack")
        fetchRequest.predicate = NSPredicate(format: "parkID = %@", "\(parkData.parkID!)")
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
        userAttractionDatabase = userAttractions
    }
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
