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
    @IBOutlet weak var rideCellSquare: UIView!
    
    
    
    @IBOutlet weak var downBar: UIButton!
    
    var titleName = ""
    var parkID = 0
    var attractionListForTable = [AttractionsModel]()
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
    
    var widthofCounter: NSLayoutConstraint!
    var plusButton: UIButton!
    
    let green = UIColor(red: 120.0/255.0, green: 205.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor as CGColor
    var userAttractions: [NSManagedObject] = []
    var userNumExtinct = 0
    var userRidesRidden = 0
    var RidesComplete = ""
    var extinctComplete = ""
    var rideID = 0
    var rideName = ""
    var totalNumExtinct = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        animateRow = -1
        suggestButton.layer.cornerRadius = 7
        let suggestColor = UIColor(red: 211/255.0, green: 213/255.0, blue: 215/255.0, alpha: 1.0)
       suggestButton.backgroundColor = suggestColor
        suggestButton.layer.shadowOpacity = 0.4
        suggestButton.layer.shadowOffset = CGSize.zero
        suggestButton.layer.shadowRadius = 7
        progressBar.backgroundColor = UIColor.green
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 6)
        rectangleView.backgroundColor = UIColor.clear
        rectangleView.clipsToBounds = true
        VisualEffectsLayer.layer.cornerRadius = 10.0
        VisualEffectsLayer.clipsToBounds = true
        
        downBar.setImage(UIImage(named: "Down Bar"), for: .normal)
        
        parkLabel.text = titleName
        
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
        for i in 0..<items.count{
            attractionListForTable.append(items[i] as! AttractionsModel)
        }
        
        if (items.count == 0){
            print ("this park is empty")
        }
        else {
            if (userAttractionDatabase != nil){
                var userDataBaseIndex = 0
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
            var countOfRemove = 0
            for i in 0..<attractionListForTable.count{ //sizeOfList
                if ((attractionListForTable[i - countOfRemove]).active == 0 && showExtinct == 0){
                    //attractionListForTable.removeObject(at: i - countOfRemove)
                    attractionListForTable.remove(at: i-countOfRemove)
                    countOfRemove = countOfRemove+1
                    continue
                }
            }
        }
        
        //If user wants to show extinct, sort so that the active rides are on top of the list
        if attractionListForTable.count != 1{
            //Need both steps to sort name alphabetically and by active or not
            attractionListForTable.sort { ($0.active, $1.name) > ($1.active, $0.name) }
        }
        
        if showExtinct == 1 {
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
        
        self.updatingRideCount(parkID: self.parkID, userCount: self.userRidesRidden-self.userNumExtinct, totNum: self.attractionListForTable.count - self.totalNumExtinct-self.numIgnore)
    
        self.attractionsTableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attractionListForTable.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rideCell", for: indexPath) as! AttractionsTableViewCell
        cell.delegate = self
        
        let item: AttractionsModel = attractionListForTable[indexPath.row]
        self.widthofCounter = cell.rideCounterCellWidth
        self.plusButton = cell.plusButtonIncrement
        
        rideCellSquare = cell.rideCellSquare
        if animateRow == indexPath.row { //animates cells here!!!
            if attractionListForTable[indexPath.row].numberOfTimesRidden == 0 {
                self.widthofCounter.constant = 80
                UIView.animate(withDuration: 0.3, animations: { //Animate Here
                    self.widthofCounter.constant -= 30
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
            else{
                self.widthofCounter.constant = 50
                UIView.animate(withDuration: 0.4, animations: { //Animate Here
                    self.widthofCounter.constant += 30
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
        else {
            if attractionListForTable[indexPath.row].numberOfTimesRidden == 0 {
                self.widthofCounter.constant = 50
            }
            else if attractionListForTable[indexPath.row].numberOfTimesRidden >= 100 {
                self.widthofCounter.constant = 110
            }
            else if attractionListForTable[indexPath.row].numberOfTimesRidden >= 10 {
                self.widthofCounter.constant = 95
            }
            else{
                self.widthofCounter.constant = 80
            }
            
        }
        if attractionListForTable.count != 1{
            if ((attractionListForTable[indexPath.row]).isCheck){
                cell.rideName?.textColor = UIColor.black //used to turn green***
                cell.addRideButton.isEnabled = false
                cell.addRideButton.isHidden = true
                cell.numberOfRidesLabel.isHidden = false
                cell.plusButtonIncrement.isHidden = false
            }
            else{
                cell.rideName?.textColor = UIColor.black
                cell.addRideButton.isEnabled = true
                cell.addRideButton.isHidden = false
                cell.numberOfRidesLabel.isHidden = true
                cell.plusButtonIncrement.isHidden = true
                
            }
            if (attractionListForTable[indexPath.row]).active == 1 {
                cell.backgroundColor = UIColor.clear
            }
            else{
                cell.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            }
            
            
            if attractionListForTable[indexPath.row].isIgnored {
                cell.rideName?.textColor = UIColor.gray
                cell.addRideButton.setImage(UIImage(named: "Ignore Button"), for: .normal)
                cell.addRideButton.isEnabled = false
               // cell.addRideButton.isOpaque = true
                attractionListForTable[indexPath.row].isIgnored = true
                //break
            }
            else {
                attractionListForTable[indexPath.row].isIgnored = false
                if ((attractionListForTable[indexPath.row]).isCheck){
                    cell.rideName?.textColor = UIColor.black //Used to turn green***
                }
                else{
                    cell.rideName?.textColor = UIColor.black
                }
                cell.addRideButton.setImage(UIImage(named: "Check Button"), for: .normal)
                cell.addRideButton.isEnabled = true
            }
        }
        cell.rideName!.text = item.name
        cell.rideTypeLabel.text = convertRideTypeID(rideTypeID: item.rideType)
        cell.numberOfRidesLabel.text = String(item.numberOfTimesRidden)
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if (attractionListForTable[indexPath.row]).numberOfTimesRidden != 0{
        let minusAction = UIContextualAction(style: .normal, title: "Minus", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print ("Subtracting")
            success(true)
            self.attractionCellNegativeIncrement(indexPath: indexPath)
            //success(true)
            self.attractionsTableView.perform(#selector(self.attractionsTableView.reloadData), with: nil, afterDelay: 0.4)

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
                if self.attractionListForTable[indexPath.row].isIgnored == false {
                    self.ignore.append(self.attractionListForTable[indexPath.row].rideID!)
                    print("Ignoring ", self.attractionListForTable[indexPath.row].name!)
                    self.attractionListForTable[indexPath.row].isIgnored = true
                    self.numIgnore += 1
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
                }
                self.ignoreList.set(self.ignore, forKey: "SavedIgnoreListArray")
                
                self.updatingRideCount(parkID: self.parkID, userCount: self.userRidesRidden-self.userNumExtinct, totNum: self.attractionListForTable.count - self.totalNumExtinct-self.numIgnore)
            success(true)
            self.attractionsTableView.perform(#selector(self.attractionsTableView.reloadData), with: nil, afterDelay: 0.4)
                // self.attractionsTableView.reloadData()
                
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
        case 1:
            return "Roller Coaster"
        case 2:
            return "Water Ride"
        case 3:
            return "Flat Ride"
        case 4:
            return "Transportation Ride"
        case 5:
            return "Dark Ride"
        case 6:
            return "Explore"
        case 7:
            return "Spectacular"
        case 8:
            return "Show"
        case 9:
            return "Film"
        case 10:
            return "Parade"
        case 11:
            return "Play Area"
        case 12:
            return "Upcharge Attraction"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func attractionsTableViewCellDidTapAddRide(_ sender: AttractionsTableViewCell) {
        guard let indexPath = attractionsTableView.indexPath(for: sender) else { return }
        
        // Code in this block will trigger when OK button tapped.
        print ("Seclected Attraction is: ", (self.attractionListForTable[indexPath.row]).rideID)
        
        (self.attractionListForTable[indexPath.row]).isCheck = true
        self.attractionListForTable[indexPath.row].numberOfTimesRidden = 1
        self.attractionListForTable[indexPath.row].dateFirstRidden = Date()
        self.attractionListForTable[indexPath.row].dateLastRidden = Date()
        self.saveUserCheckOffNewRide(parkID: self.parkID, rideID: (self.attractionListForTable[indexPath.row]).rideID);
        self.attractionsTableView.reloadData()
        
        if (self.attractionListForTable[indexPath.row]).active == 0{
            self.userNumExtinct += 1
        }
        self.animateRow = indexPath.row //animate here!
        
        self.userRidesRidden += 1
        print ("you have been on this many rides: ", self.userRidesRidden)
        
        //UPDATE RIDES BEEN ON
        self.updatingRideCount(parkID: self.parkID, userCount: self.userRidesRidden-self.userNumExtinct, totNum: self.attractionListForTable.count - self.totalNumExtinct-self.numIgnore)
        
        self.extinctComplete = String (self.userNumExtinct)
        // self.extinctComplete += "/"
        // self.extinctComplete += String (self.totalNumExtinct)
        self.extinctText.text = self.extinctComplete
        
        if self.attractionListForTable[indexPath.row].hasScoreCard == 1{
            self.addScoreToCard(selectedRide: self.attractionListForTable[indexPath.row])
        }
        
        
    }
    
    func attractionCellNegativeIncrement (indexPath: IndexPath) {
        //  guard let indexPath = attractionsTableView.indexPath(for: sender) else { return }
        
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
            
            self.updatingRideCount(parkID: self.parkID, userCount: self.userRidesRidden-self.userNumExtinct, totNum: self.attractionListForTable.count - self.totalNumExtinct-self.numIgnore)
            
            self.extinctComplete = String (self.userNumExtinct)
            //  self.extinctComplete += "/"
            //  self.extinctComplete += String (self.totalNumExtinct)
            self.extinctText.text = self.extinctComplete
        }
        else{
            let newIncrement = attractionListForTable[indexPath.row].numberOfTimesRidden - 1
            saveIncrementRideCount(rideID:  attractionListForTable[indexPath.row].rideID, incrementTo: newIncrement, postive: false)
            attractionListForTable[indexPath.row].numberOfTimesRidden = newIncrement
            // attractionsTableView.reloadData()
        }
    }
    
    
    
    func attractionCellPositiveIncrement(_ sender: AttractionsTableViewCell) {
        print("plus")
        guard let indexPath = attractionsTableView.indexPath(for: sender) else { return }
        let newIncrement = attractionListForTable[indexPath.row].numberOfTimesRidden + 1
        saveIncrementRideCount(rideID:  attractionListForTable[indexPath.row].rideID, incrementTo: newIncrement, postive: true)
        attractionListForTable[indexPath.row].numberOfTimesRidden = newIncrement
        attractionListForTable[indexPath.row].dateLastRidden = Date()
        attractionsTableView.reloadData()
        
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
        
        if segue.identifier == "toSuggest"{
            let suggestVC = segue.destination as! SuggestRideViewController
            suggestVC.parkName = titleName
            suggestVC.parkID = parkID
            
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
        
        var percentage = Float(userCount)/Float(totNum)
        self.progressBar.progress = Float(percentage)
        
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
    }
    
    @IBAction func unwindfromdetails(_ sender: UIStoryboardSegue) {
        print ("Back from deatils")
        
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
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
