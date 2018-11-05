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
import Firebase
import FirebaseDatabase

class AttractionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, DataModelProtocol, AttractionsTableViewCellDelegate{
    
    
    
    
    @IBOutlet weak var attractionsTableView: UITableView!
    @IBOutlet weak var parkLabel: UILabel!
    @IBOutlet weak var NumCompleteLabel: UILabel!
    @IBOutlet weak var extinctText: UITextField!
    @IBOutlet weak var rectangleView: UIView!
    @IBOutlet weak var suggestButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var VisualEffectsLayer: UIVisualEffectView!
    @IBOutlet weak var emptyParkInstructionsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var darkenLayer: UIView!
    @IBOutlet weak var downBar: UIButton!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var topOfTableView: NSLayoutConstraint!
    @IBOutlet weak var notificationViewBottomConstrant: NSLayoutConstraint!
    @IBOutlet weak var notificationViewText: UILabel!
    @IBOutlet weak var notificationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var notificationTitle: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var seachBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet var toolBarView: UIView!
    
    var generator: UIImpactFeedbackGenerator!
    var popupGenerator: UIImpactFeedbackGenerator!
    
    let screenSize = UIScreen.main.bounds
    var segueWithTableViewSelect = false
    var insets = UIEdgeInsets(top: -4.5, left: 0, bottom: 5.5, right: 0)

    @IBOutlet weak var typesFiltered: UILabel!
    
    
    var userDataBaseIndex = 0
    var titleName = ""
    var parkID = 0
    var attractionListForTable = [AttractionsModel]()
    var favoiteParkList = [ParksList]()
    var savedItems: NSArray!
    var parkData: ParksModel!
    var showExtinct = false
    var isIgnored = false
    //From the datamigration tool:
    var userAttractionDatabase: [AttractionList]!
    var ignore = [IgnoreList]()
    //let ignoreList = UserDefaults.standard
    var numIgnore = 0
    var comeFromDetails = false
    var initialToucnPoint : CGPoint = CGPoint(x: 0, y: 0)
    var parksViewController: ViewController!
    var animateRow = -1
    var countOfRemove = 0
    var selectedAttractionsList: [NSManagedObject] = []
    var totalExtinctCount = 0
    var isfiltering = false
    //let appGreen = UIColor(red: 68.0/255.0, green: 146.0/255.0, blue: 63.0/255.0, alpha: 1.0)
    let darkGreen = UIColor(red: 40/255.0, green: 119/255.0, blue: 72/255.0, alpha: 1.0)
    let appGreen = UIColor(red: 98.0/255.0, green: 213.0/255.0, blue: 88.0/255.0, alpha: 1.0)
    let goldBar = UIColor(red: 250/255.0, green: 204/255.0, blue: 73/255.0, alpha: 1.0)
//    let lightGreyBar = UIColor(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
    let lightGreyBar = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0)
    var userAttractions: [NSManagedObject] = []
    var userNumExtinct = 0
    var userRidesRidden = 0
    var numExtinctSelected = 0
    var RidesComplete = ""
    var extinctComplete = ""
    var rideID = 0
    var rideName = ""
    var totalNumExtinct = 0
    var hasHaptic = 0
    var filteredAttractions = [AttractionsModel]()
    var userRef: DatabaseReference!

    var firstCheckin = false
    var numberOfCheckins = 0
    var lastVisit = 0.0
    
    var attractionListRef: DatabaseReference!
    var parksListRef: DatabaseReference!
    var favoriteListRef: DatabaseReference!
    var scoreCardRef: DatabaseReference!
    var userNameRef: DatabaseReference!
    var user: User!
    var loginEmail = ""
    var userName = ""
    var id = ""
    var typeFilter = ["ALL"]
    
    let searchController = UISearchController(searchResultsController: nil)
    var is3DTouchAvailable: Bool {
        return view.traitCollection.forceTouchCapability == .available
    }
    
    
    var ignoreListRef: DatabaseReference!
    
    override func viewDidLoad() {
        Analytics.logEvent("view_park", parameters: ["parkName": parkData.name])
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        print("Show incrementor is \(parkData.incrementorEnabled)")
        super.viewDidLoad()
        hasHaptic = UIDevice.current.value(forKey: "_feedbackSupportLevel") as! Int
        print ("has haptic is ", hasHaptic)
        suggestButton.isUserInteractionEnabled = false
        emptyParkInstructionsLabel.alpha = 0.0
        self.darkenLayer.backgroundColor = UIColor.clear
        animateRow = -1
    
        progressBar.progressTintColor = appGreen
        progressBar.trackTintColor = lightGreyBar
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 10)
        
        rectangleView.backgroundColor = UIColor.clear
        rectangleView.clipsToBounds = true
        VisualEffectsLayer.layer.cornerRadius = 10.0
        VisualEffectsLayer.clipsToBounds = true
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        
        notificationView.layer.shadowOffset = CGSize.zero
        notificationView.layer.shadowRadius = 5
        notificationView.layer.shadowOpacity = 0.3
        notificationView.layer.cornerRadius = 10
        notificationViewBottomConstrant.constant = -64
        
        filterButton.layer.cornerRadius = 7
        clearButton.layer.cornerRadius = 7
        

        
        if is3DTouchAvailable{
            popupGenerator = UIImpactFeedbackGenerator(style: .heavy)
            generator = UIImpactFeedbackGenerator(style: .light)
            popupGenerator.prepare()
            generator.prepare()
        }
        
        downBar.setImage(UIImage(named: "Down Bar"), for: .normal)
        titleName = parkData.name
        parkLabel.text = titleName
        
        if screenSize.width == 320.0{
            ConfigureSmallerLayout().attractionsViewLayout(attractionsView: self)
        }
        
        if screenSize.height == 812.0{
            insets = UIEdgeInsets(top: -4.5, left: 0, bottom: 0, right: 0)
        }
        
        
        self.attractionsTableView.delegate = self
        self.attractionsTableView.dataSource = self
        parkID = parkData.parkID
        print(parkID)
        let urlPath = "http://www.beingpositioned.com/theparksman/attractiondbservice.php?parkid=\(parkID)"
        let dataModel = DataModel()
        // print ("There are ", feedItems.count, " attactions in park ", parkID)
        dataModel.delegate = self
        
        dataModel.downloadData(urlPath: urlPath, dataBase: "attractions", returnPath: "attractions")
        //ignore = ignoreList.array(forKey: "SavedIgnoreListArray")  as? [Int] ?? [Int]()
 
        // Do any additional setup after loading the view, typically from a nib.
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        let userID = Auth.auth().currentUser
        id = (userID?.uid)!
        loginEmail = (userID?.email)!
        userNameRef = Database.database().reference(withPath:"users/details/\(id)/userName") ///userName
        attractionListRef = Database.database().reference(withPath: "attractions-list/\(id)/\(parkData.parkID!)")
        parksListRef = Database.database().reference(withPath: "all-parks-list/\(id)/\(String(parkData.parkID))")
        favoriteListRef = Database.database().reference(withPath: "favorite-parks-list/\(id)/\(String(parkData.parkID))")
        ignoreListRef = Database.database().reference(withPath: "ignore-list/\(id)/\(String(parkData.parkID))")

        
        userNameRef.observe(.value, with: { snapshot in
            if snapshot.exists(){ //hasChild("testJustin"){
                self.userName = (snapshot.value as! String)
                print("Has username")
            }
            else {
                self.userName = ""
                let alertController = UIAlertController(title: "Please enter a user name", message: "When you created an account for LogRide, we did not ask for a username. For future features, we will require all uses to create a username.", preferredStyle: .alert)
                alertController.addTextField { textField in
                    textField.placeholder = "userName"
                }
                let confirmAction = UIAlertAction(title: "Enter", style: .default) { [weak alertController] _ in
                    guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
                    self.userName = String(describing: textField.text!)
                    let userID = Auth.auth().currentUser
                    let id = userID?.uid
                    self.userRef = Database.database().reference(withPath: "users/details")
                    let newUser = UserName(userName: self.userName, userID: id!)
                    let newUserRef = self.userRef.child(id!)
                    newUserRef.setValue(newUser.toAnyObject())
                    //compare the current password and do action here
                }
                alertController.addAction(confirmAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
        print("user name is \(userName)")
        
        
        attractionListRef.observe(.value, with: { snapshot in
            var newAttractions: [AttractionList] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let attractionItem = AttractionList(snapshot: snapshot) {
                    newAttractions.append(attractionItem)
                }
            }
            self.userAttractionDatabase = newAttractions

            //self.attractionsTableView.reloadData()
        })
        
        ignoreListRef.observe(.value, with: { snapshot in
            var newIgnores: [IgnoreList] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let ignoreItem = IgnoreList(snapshot: snapshot) {
                    newIgnores.append(ignoreItem)
                }
            }
            print("new ignore at ride ID: \(self.ignore.count)")
            self.ignore = newIgnores
        })
        // Setup the Search Controller
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchController.searchBar.sizeToFit()
        searchController.searchBar.enablesReturnKeyAutomatically = false
       // searchController.searchBar.showsScopeBar = true
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.attractionsTableView.tableHeaderView = searchController.searchBar
        self.attractionsTableView.contentInset = insets
        searchController.searchBar.inputAccessoryView = toolBarView
       // searchController.inputAccessoryView = toolBarView
        
        
        if firstCheckin{
            welcomeBackNotification()
        }
        
    }

    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        savedItems = items
        suggestButton.isUserInteractionEnabled = true
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
                totalExtinctCount = 0
                
                let maxUserAttractionCount = userAttractionDatabase.count
                for i in 0..<attractionListForTable.count{
                    if userDataBaseIndex < maxUserAttractionCount{
                        
                        if (attractionListForTable[i]).rideID == userAttractionDatabase[userDataBaseIndex].rideID{
                            
                            //The user does have data for this ride
                            // print ("We have ridden ride # ", userAttractionDatabase[userDataBaseIndex].rideID!)
                            attractionListForTable[i].isCheck = true
                            userRidesRidden += 1
                            
                            attractionListForTable[i].numberOfTimesRidden = userAttractionDatabase[userDataBaseIndex].numberOfTimesRidden
                            attractionListForTable[i].dateLastRidden = Date(timeIntervalSince1970: userAttractionDatabase[userDataBaseIndex].lastRideDate)
                            attractionListForTable[i].dateFirstRidden = Date(timeIntervalSince1970: userAttractionDatabase[userDataBaseIndex].firstRideDate)
                            attractionListForTable[i].isIgnored = false
                            
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
                    
                    if attractionListForTable[i].active == 0 && showExtinct{
                        totalNumExtinct += 1
                    }
                    
                    if attractionListForTable[i].active == 0{
                        totalExtinctCount += 1
                    }
                    
                    if attractionListForTable[i].numberOfTimesRidden == nil{
                        print("attraction list at rideID \(attractionListForTable[i].rideID!) found nil")
                        attractionListForTable[i].numberOfTimesRidden = 0
                    }
                    
                    if ignore.count == 0 {
                        attractionListForTable[i].isIgnored = false
                    } //setting the rides to be ignored
                    for j in 0..<ignore.count{
                        if ignore[j].rideID == attractionListForTable[i].rideID && attractionListForTable[i].active == 0 {
                            print ("was opened/hidden, now extinct")
                            ignore.remove(at: j)
                            attractionListForTable[i].isIgnored = false
                            break
                        }
                        
                        if ignore[j].rideID == attractionListForTable[i].rideID{
                            //print ("still here!")
                            attractionListForTable[i].isIgnored = true
                            numIgnore += 1
                            break
                        }
                        else {
                            //print("at the else")
                            attractionListForTable[i].isIgnored = false
                        }
                        
                    }
                }
            }
        }
        //Hide EXTINCT ATTRACTIONS
        //This would work to show defunct attractions for closed parks, but the progress bar gets messed up and treats all attractions as current attractions
        //Uncomment out the if statement to see how it would work
//        if allAttractionsAreDefunt{
//            print("ALL ATTRACTION IN THIS PARK ARE DEFUNCT")
//            showExtinct = 1
//            print(totalNumExtinct)
//            totalNumExtinct = attractionListForTable.count
//            
//        }

        if totalExtinctCount == attractionListForTable.count{
            print("All EXTINCT!")
            showExtinct = true
            totalNumExtinct = attractionListForTable.count
        }
        
        if(!showExtinct){
            for i in 0..<attractionListForTable.count{ //sizeOfList
                if ((attractionListForTable[i - countOfRemove]).active == 0 && !showExtinct && (attractionListForTable[i - countOfRemove]).isCheck == false){
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
        
        if showExtinct || userNumExtinct >= 1 {
            extinctText.isHidden = false
            extinctComplete = String (userNumExtinct)
            // extinctComplete += "/"
            //extinctComplete += String (totalNumExtinct)
            extinctText.text = "Defunct \(extinctComplete)"
        }
        else{
            extinctText.isHidden = true
        }
        
        //rideCountLabel.isHidden  = false
        NumCompleteLabel.isHidden = false
        
        
        if (self.attractionListForTable.count - totalNumExtinct-numIgnore-numExtinctSelected) > parkData.totalRides && segueWithTableViewSelect{
            let numberOfNewParks = attractionListForTable.count-totalNumExtinct-numIgnore-numExtinctSelected-parkData.totalRides
            if numberOfNewParks == 1{
                notificationViewText.text = "1 new attraction is now available."
            } else{
                notificationViewText.text = "\(numberOfNewParks) new attractions are now available."
            }
            animateInNotifcationView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) { // change 2 to desired number of seconds
                // Your code with delay
                self.animateAwayNotificationView()
            }
        }
        
        updatingRideCount(parkID: parkID, userCount: userRidesRidden-userNumExtinct, totNum: attractionListForTable.count - totalNumExtinct-numIgnore-numExtinctSelected)
        
        
       
        
        self.attractionsTableView.reloadData()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        if isFiltering() {
            return filteredAttractions.count
        }
        return attractionListForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var CurrtableView: [AttractionsModel]
        if isFiltering() {
            CurrtableView = filteredAttractions
        }
        else {
            CurrtableView = attractionListForTable
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "rideCell", for: indexPath) as! AttractionsTableViewCell
        cell.delegate = self
        let item: AttractionsModel = CurrtableView[indexPath.row]
        
        if parkData.incrementorEnabled{
            if ((CurrtableView[indexPath.row]).isCheck){
                cell.rideCountViewLeadingConstraint.constant = 3
                cell.attractionButton.setImage(#imageLiteral(resourceName: "Plus Attraction"), for: .normal)
                cell.numberOfRidesLabel.alpha = 1.0
                cell.numberOfRidesLabel.text = String(item.numberOfTimesRidden)
                configureCellIncrementing(cell: cell, item: item)
            } else if CurrtableView[indexPath.row].isIgnored{
                configureCellIgnore(cell: cell, item: item)
            } else{
                configureCellCheck(cell: cell, item: item)
            }
        } else{
            if ((CurrtableView[indexPath.row]).isCheck){
                cell.rideCountViewLeadingConstraint.constant = -1
                cell.attractionButton.setImage(#imageLiteral(resourceName: "green check"), for: .normal)
                cell.numberOfRidesLabel.alpha = 0.0
                cell.numberOfRidesLabel.text = ""
                CurrtableView[indexPath.row].numberOfTimesRidden = 1
                configureCellIncrementing(cell: cell, item: item)
            } else if CurrtableView[indexPath.row].isIgnored{
                configureCellIgnore(cell: cell, item: item)
            } else{
                configureCellCheck(cell: cell, item: item)
            }
        }
        
        if (CurrtableView[indexPath.row]).active == 1 {
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
    
    func welcomeBackNotification() {
        
        
        var numberPrefix = "th"
        if numberOfCheckins == 1{
            numberPrefix = "st"
        } else {
            animateInNotifcationView()
            if numberOfCheckins == 2{
                numberPrefix = "nd"
            
            } else if numberOfCheckins == 3{
                numberPrefix = "rd"
            }
            notificationTitle.text = "Welcome back!"
            let lastVisitDate = Date(timeIntervalSince1970: lastVisit)
            notificationViewText.text = "This is your \(numberOfCheckins)\(numberPrefix) time at \(parkData.name!). Your last visit was \(dateFormatter(date: lastVisitDate))"
        }
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            self.animateAwayNotificationView()
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var CurrtableView: [AttractionsModel]
        if isFiltering() {
            CurrtableView = filteredAttractions
        }
        else {
            CurrtableView = attractionListForTable
        }
        if tableView == self.attractionsTableView {
        if (CurrtableView[indexPath.row]).numberOfTimesRidden != 0{
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
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var CurrtableView: [AttractionsModel]
        if isFiltering() {
            CurrtableView = filteredAttractions
        }
        else {
            CurrtableView = attractionListForTable
        }
        if tableView == self.attractionsTableView {
        if (CurrtableView[indexPath.row]).active == 1 && CurrtableView[indexPath.row].isCheck == false {
            let ignoreAction = UIContextualAction(style: .normal, title: "Ignore", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("ignore button tapped on ride")
                let cell = self.attractionsTableView.cellForRow(at: indexPath) as! AttractionsTableViewCell

                if CurrtableView[indexPath.row].isIgnored == false {
                    
                    //self.ignore.append(self.attractionListForTable[indexPath.row].rideID!)
                    
                    let newIgnore = IgnoreList(rideID: CurrtableView[indexPath.row].rideID!)
                    let newIgnoreRef = self.ignoreListRef.child(String(newIgnore.rideID))
                    newIgnoreRef.setValue(newIgnore.toAnyObject())
                    
                    
                    print("Ignoring ", CurrtableView[indexPath.row].name!)
                    CurrtableView[indexPath.row].isIgnored = true
                    self.numIgnore += 1
                    
                    cell.rideName?.textColor = UIColor.gray
                    cell.attractionButton.setImage(#imageLiteral(resourceName: "Ignore Button"), for: .normal)
                }
                else {
                    let ignoreIdex = self.findIndexOfIgnore(rideID: CurrtableView[indexPath.row].rideID)
                    let ignoreItem = self.ignore[ignoreIdex]
                    ignoreItem.ref?.removeValue()
//                    for i in 0..<(self.ignore.count) {
//                        if self.ignore[i].rideID == self.attractionListForTable[indexPath.row].rideID{
//                            self.ignore.remove(at: i)
//                            break
//                        }
//                    }
                    print ("Unignoring ", CurrtableView[indexPath.row].name!)
                    CurrtableView[indexPath.row].isIgnored = false
                    self.numIgnore -= 1
                    
                    
                    cell.attractionButton.setImage(#imageLiteral(resourceName: "Check Button"), for: .normal)
                    cell.rideName?.textColor = UIColor.black
                }
                //self.ignoreList.set(self.ignore, forKey: "SavedIgnoreListArray")
                
                self.updatingRideCount(parkID: self.parkID, userCount: self.userRidesRidden-self.userNumExtinct, totNum: self.attractionListForTable.count - self.totalNumExtinct-self.numIgnore-self.numExtinctSelected)
                success(true)

                
            })
            
            ignoreAction.title = CurrtableView[indexPath.row].isIgnored ? "Include" : "Exclude"
            ignoreAction.backgroundColor = CurrtableView[indexPath.row].isIgnored ? appGreen : .gray
            let configurations = UISwipeActionsConfiguration(actions: [ignoreAction])
            configurations.performsFirstActionWithFullSwipe = true
            return configurations //UISwipeActionsConfiguration(actions: [ignoreAction])
        }
        else {
            return UISwipeActionsConfiguration.init()
        }
        }
        else {
            return nil
        }
    }
    
    func findIndexOfIgnore(rideID: Int) -> Int{
        var index = -1
        print(ignore.count)
        for i in 0..<ignore.count{
            //print("Ignore ID: \(ignore[i].rideID)")
            if ignore[i].rideID == rideID{
                index = i
            }
        }
        return index
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: "rideCell", for: indexPath) as! AttractionsTableViewCell
//        print("HERe we are, and ride is : \(cell.rideName.text!)")
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func attractionCellTapButton(_ sender: AttractionsTableViewCell) {
        var CurrtableViewList: [AttractionsModel]
        if isFiltering() {
            CurrtableViewList = filteredAttractions
        }
        else {
            CurrtableViewList = attractionListForTable
        }
        print("plus")
        guard let indexPath = attractionsTableView.indexPath(for: sender) else { return }
        
        if (CurrtableViewList[indexPath.row]).isCheck && !parkData.incrementorEnabled{//if increment is off, tap the check button to uncheck it
            print ("uncheck here")
            if (hasHaptic != 0) {
                generator.impactOccurred()
            }
            attractionCellNegativeIncrement(indexPath: indexPath)
        }
        
        else if !CurrtableViewList[indexPath.row].isCheck && !CurrtableViewList[indexPath.row].isIgnored{
            addFirstCheckRide(indexPath: indexPath)
        } else if CurrtableViewList[indexPath.row].isCheck && !CurrtableViewList[indexPath.row].isIgnored{
            positiveIncrementCount(indexPath: indexPath)
        } else{
            print("Can't change it when ignored")
        }
    }
    
    
    func enterAttractionTally(_ sender: AttractionsTableViewCell) {
        var CurrtableViewList: [AttractionsModel]
        if isFiltering() {
            CurrtableViewList = filteredAttractions
            searchController.isActive = false
        }
        else {
            CurrtableViewList = attractionListForTable
        }
        print ("HERE on LONG")
        var newIncrement = 1
        guard let indexPath = attractionsTableView.indexPath(for: sender) else { return }
        let cell = self.attractionsTableView.cellForRow(at: indexPath) as! AttractionsTableViewCell
        cell.rideCellSquare.isUserInteractionEnabled = false
        cell.extendedTappableCheckView.isUserInteractionEnabled = false
        if parkData.incrementorEnabled && CurrtableViewList[indexPath.row].isCheck {
            if (self.hasHaptic == 0) {
                print("no imapct")
            }
            else {
                popupGenerator.impactOccurred()
                print ("impact")
            }
            let enterTallyAlert = UIAlertController(title: "Experience Tally", message: "Please enter the number of times you have experienced this attraction", preferredStyle: UIAlertController.Style.alert)
            let userInput = UIAlertAction(title: "Enter", style: .default) { (alertAction) in
                let textField = enterTallyAlert.textFields![0] as UITextField
                
                if textField.text != ""{
                    cell.numberOfRidesLabel.text = textField.text
                    cell.rideCellSquare.alpha = 1
                    cell.rideCountViewLeadingConstraint.constant = 3
                    cell.attractionButton.setImage(#imageLiteral(resourceName: "Plus Attraction"), for: .normal)
                    newIncrement = Int(textField.text!)!
                }
               
                
             
                CurrtableViewList[indexPath.row].numberOfTimesRidden = newIncrement
                CurrtableViewList[indexPath.row].dateLastRidden = Date()
                self.saveIncrementRideCount(rideID: CurrtableViewList[indexPath.row].rideID, incrementTo: newIncrement, postive: true)
                cell.rideCellSquare.isUserInteractionEnabled = true
                cell.extendedTappableCheckView.isUserInteractionEnabled = true
                
                if textField.text != ""{
                    if Int(textField.text!)! == 0{
                        self.removeAttractionFromList(indexPath: indexPath)
                    }
                }
                
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
                print("cancled")
                cell.rideCellSquare.isUserInteractionEnabled = true
                cell.extendedTappableCheckView.isUserInteractionEnabled = true
            }
            enterTallyAlert.addTextField { (textField) in
                textField.placeholder = "\(cell.numberOfRidesLabel.text!)"
                textField.keyboardType = UIKeyboardType.numberPad
            }
            enterTallyAlert.addAction(userInput)
            enterTallyAlert.addAction(cancel)
            self.present(enterTallyAlert, animated: true, completion:nil)

        }
    }
    
    func endLongPress(_ sender: AttractionsTableViewCell){
        guard let indexPath = attractionsTableView.indexPath(for: sender) else { return }
        let cell = self.attractionsTableView.cellForRow(at: indexPath) as! AttractionsTableViewCell
        cell.rideCellSquare.isUserInteractionEnabled = true
        cell.extendedTappableCheckView.isUserInteractionEnabled = true
    }
   // search functions
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
//        if (searchController.searchBar.text?.isEmpty)! {
//        }
//        return false
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredAttractions = attractionListForTable.filter({(attractionListForTable : AttractionsModel) -> Bool in
            var doesMatchCatagory = false //= (scope == "All")
            for i in 0..<typeFilter.count {
                doesMatchCatagory = doesMatchCatagory || (String(convertRideTypeID(rideTypeID: attractionListForTable.rideType)) == typeFilter[i])
            }
            
            if scope == "ALL"{
                return attractionListForTable.name.lowercased().contains(searchText.lowercased())
            }
            else if searchBarIsEmpty() {
                return doesMatchCatagory
            }
          else {
                return attractionListForTable.name.lowercased().contains(searchText.lowercased()) && doesMatchCatagory
            }
        })
       // print("reload")
        attractionsTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        //print("Filtering")
        if typeFilter[0] == "ALL" {
            isfiltering = searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
            return isfiltering
        }
        else  {
            isfiltering = searchController.isActive && (true || searchBarScopeIsFiltering) //!searchBarIsEmpty()
            return isfiltering

        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        topView.isUserInteractionEnabled = false
        suggestButton.isUserInteractionEnabled = false
        typesFiltered.text = ""
        if typeFilter.count == 1 && typeFilter[0] == "ALL"{
            self.typesFiltered.text! += "Showing all Attractions"
        }
        var j = 0
        if typeFilter[0] == "ALL" {
            j = 1
        }
        for i in j..<typeFilter.count {
            self.typesFiltered.text! += "\(typeFilter[i])   "
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        topView.isUserInteractionEnabled = true
        suggestButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3, animations: ({
            self.searchController.searchBar.backgroundColor = UIColor.white.withAlphaComponent(0.0)
            self.view.layoutIfNeeded()
            
        }))
    }
    
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchController.isActive{
            UIView.animate(withDuration: 0.3, animations: ({
                self.searchController.searchBar.backgroundColor = UIColor.white.withAlphaComponent(0.9)
                self.view.layoutIfNeeded()
                
            }))
        }
    }
    
    @IBAction func clearFilterButton(_ sender: Any) {
        typeFilter.removeAll()
        typeFilter.append("ALL")
        searchController.isActive = true
        DispatchQueue.main.async {
            self.searchController.isActive = true
        }
        typesFiltered.text = "Showing all Attractions"
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            attractionsTableView.contentInset = UIEdgeInsets.zero
        } else {
            
            attractionsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        attractionsTableView.scrollIndicatorInsets = attractionsTableView.contentInset
    }
    
    func addFirstCheckRide(indexPath: IndexPath){
        var CurrtableViewList: [AttractionsModel]
        if isFiltering() {
            CurrtableViewList = filteredAttractions
        }
        else {
            CurrtableViewList = attractionListForTable
        }
        print ("Seclected Attraction is: ", (self.attractionListForTable[indexPath.row]).rideID)
    
        (CurrtableViewList[indexPath.row]).isCheck = true
        CurrtableViewList[indexPath.row].numberOfTimesRidden = 1
        CurrtableViewList[indexPath.row].dateFirstRidden = Date()
        CurrtableViewList[indexPath.row].dateLastRidden = Date()
        
        let newRideID = CurrtableViewList[indexPath.row].rideID
        let newCheck = AttractionList(rideID: newRideID!, numberOfTimesRidden: 1, firstRideDate: Date().timeIntervalSince1970, lastRideDate: Date().timeIntervalSince1970)
        let newAttractionRef = self.attractionListRef.child(String(newRideID!))
        newAttractionRef.setValue(newCheck.toAnyObject())
        
        let cell = self.attractionsTableView.cellForRow(at: indexPath) as! AttractionsTableViewCell

        if (self.hasHaptic == 0) {
        }
        else {
            generator.impactOccurred()
        }
           if parkData.incrementorEnabled{
            cell.numberOfRidesLabel.text = String(CurrtableViewList[indexPath.row].numberOfTimesRidden)
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
        
        if (CurrtableViewList[indexPath.row]).active == 0{
            self.userNumExtinct += 1
        }
        
        self.userRidesRidden += 1
        print ("you have been on this many rides: ", self.userRidesRidden)
        
        //UPDATE RIDES BEEN ON
        self.updatingRideCount(parkID: self.parkID, userCount: self.userRidesRidden-self.userNumExtinct, totNum: self.attractionListForTable.count - self.totalNumExtinct-self.numIgnore-self.numExtinctSelected)
        
        self.extinctComplete = String (self.userNumExtinct)
        // self.extinctComplete += "/"
        // self.extinctComplete += String (self.totalNumExtinct)
        self.extinctText.text = "Defunct: \(self.extinctComplete)"
        
        if CurrtableViewList[indexPath.row].hasScoreCard == 1{
            self.addScoreToCard(selectedRide: CurrtableViewList[indexPath.row])
        }
    }
    
    func attractionCellNegativeIncrement (indexPath: IndexPath) {
        var CurrtableViewList: [AttractionsModel]
        if isFiltering() {
            CurrtableViewList = filteredAttractions
        }
        else {
            CurrtableViewList = attractionListForTable
        }
        if CurrtableViewList[indexPath.row].numberOfTimesRidden == 1{
           removeAttractionFromList(indexPath: indexPath)
        }
        else{
            let newIncrement = CurrtableViewList[indexPath.row].numberOfTimesRidden - 1
            saveIncrementRideCount(rideID:  CurrtableViewList[indexPath.row].rideID, incrementTo: newIncrement, postive: false)
            CurrtableViewList[indexPath.row].numberOfTimesRidden = newIncrement
            let cell = self.attractionsTableView.cellForRow(at: indexPath) as! AttractionsTableViewCell
            cell.numberOfRidesLabel.text = String(newIncrement)
        }
    }
    
    func removeAttractionFromList(indexPath: IndexPath){
        //User is unchecking the ride from their list
        var CurrtableViewList: [AttractionsModel]
        if isFiltering() {
            CurrtableViewList = filteredAttractions
        }
        else {
            CurrtableViewList = attractionListForTable
        }
        let userAttractionDatabaseIndex = getUserAttractionDatabaseIndex(rideID: CurrtableViewList[indexPath.row].rideID)
        let attractionItem = userAttractionDatabase[userAttractionDatabaseIndex]
        attractionItem.ref?.removeValue()
        
        CurrtableViewList[indexPath.row].numberOfTimesRidden = 0
        CurrtableViewList[indexPath.row].isCheck = false
        
        
        self.animateRow = indexPath.row    //"Animate here")
        //self.attractionsTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        
        
        
        if (CurrtableViewList[indexPath.row]).active == 0 {
            userNumExtinct -= 1
        }
        userRidesRidden -= 1
        //UPDATE RIDES BEEN ON
        
        self.updatingRideCount(parkID: self.parkID, userCount: self.userRidesRidden-self.userNumExtinct, totNum: self.attractionListForTable.count - self.totalNumExtinct-self.numIgnore-self.numExtinctSelected)
        
        self.extinctComplete = String (self.userNumExtinct)
        //  self.extinctComplete += "/"
        //  self.extinctComplete += String (self.totalNumExtinct)
        self.extinctText.text = "Defunct: \(self.extinctComplete)"
        
        
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
    
    func positiveIncrementCount(indexPath: IndexPath){
        var CurrtableViewList: [AttractionsModel]
        if isFiltering() {
            CurrtableViewList = filteredAttractions
        }
        else {
            CurrtableViewList = attractionListForTable
        }
        if parkData.incrementorEnabled{
            if (self.hasHaptic == 0) {
            }
            else {
                generator.impactOccurred()
            }
            let cell = self.attractionsTableView.cellForRow(at: indexPath) as! AttractionsTableViewCell
            let newIncrement = CurrtableViewList[indexPath.row].numberOfTimesRidden + 1
            saveIncrementRideCount(rideID:  CurrtableViewList[indexPath.row].rideID, incrementTo: newIncrement, postive: true)
            CurrtableViewList[indexPath.row].numberOfTimesRidden = newIncrement
            CurrtableViewList[indexPath.row].dateLastRidden = Date()
            
            UIView.animate(withDuration: 0.5, animations: ({
                cell.numberOfRidesLabel.text = String(newIncrement)
            }))
        }
        
        if CurrtableViewList[indexPath.row].hasScoreCard == 1{
            addScoreToCard(selectedRide: CurrtableViewList[indexPath.row])
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveIncrementRideCount(rideID: Int, incrementTo: Int, postive: Bool){
        let attractionIndex = getUserAttractionDatabaseIndex(rideID: rideID)
        let attractionItem = userAttractionDatabase[attractionIndex]
        
        if postive{
            attractionItem.ref?.updateChildValues([
                "numberOfTimesRidden": incrementTo,
                "lastRideDate": Date().timeIntervalSince1970
                ])
        } else{
            attractionItem.ref?.updateChildValues([
                "numberOfTimesRidden": incrementTo
                ])
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toParkSettings"{            
            let settingsVC = segue.destination as! ParkSettingsViewController
            settingsVC.parksData = parkData
            settingsVC.favoiteParkList = favoiteParkList
            settingsVC.showDefunct = showExtinct
            settingsVC.attractionViewController = self
            settingsVC.userName = userName
        }
        
        if segue.identifier == "toParkInfo"{
            let infoVC = segue.destination as! ParkInfoViewController
            infoVC.parksData = parkData
        }
        
        if segue.identifier == "toFilter" {
            print("Going to filter")
            self.attractionsTableView.setContentOffset(.zero, animated: false)
            searchController.isActive = false
            let newVC = segue.destination as! FilterViewController
            newVC.typeFilter = typeFilter
            UIView.animate(withDuration: 0.5, animations: ({
                self.darkenLayer.backgroundColor = UIColor.black.withAlphaComponent(0.25)
                self.view.layoutIfNeeded()
            }))
            //self.attractionsTableView.tableHeaderView = searchController.searchBar
            topView.isUserInteractionEnabled = false
            suggestButton.isUserInteractionEnabled = false
            
        }
        if segue.identifier == "ToDetails"{
            let detailsVC = segue.destination as! AttractionsDetailsViewController
            let selectedRide: AttractionsModel
            let selectedIndex = attractionsTableView.indexPathForSelectedRow?.row
            
print ("selected Index is \(selectedIndex!)")
            if isFiltering(){
                selectedRide = filteredAttractions[selectedIndex!]
            }
            else {
                selectedRide = attractionListForTable[selectedIndex!]
            }
        
            rideID = selectedRide.rideID
            rideName = selectedRide.name
            print (rideName)
            detailsVC.selectedRide = selectedRide
            detailsVC.userAttractionDatabase = userAttractionDatabase
            comeFromDetails = true
            detailsVC.titleName = titleName
            detailsVC.favoiteParkList = favoiteParkList
            detailsVC.isfiltering = isfiltering
            detailsVC.userID = userName
            UIView.animate(withDuration: 0.3, animations: ({
                self.darkenLayer.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                self.view.layoutIfNeeded()
            }))
            searchController.isActive = false
        }
        
        if segue.identifier == "toParkList"{
            print("Back to parks list")
            let parkVC = segue.destination as! ViewController
            parkVC.unwindFromAttractions(parkID: parkID)
        }
    
    }
    
    func addScoreToCard(selectedRide: AttractionsModel){
        var title = "How’d You Do?"
        if selectedRide.rideID == 669 || selectedRide.rideID == 826 || selectedRide.rideID == 1389 || selectedRide.rideID == 1892 || selectedRide.rideID == 2356 || selectedRide.rideID == 3086{
            title = "How’d you do, Space Ranger?"
        }
        if selectedRide.rideID == 523 || selectedRide.rideID == 3236 || selectedRide.rideID == 611{
            title = "Fine Shoot’n Partner!"
        }
        let scoreAlert = UIAlertController(title: title, message: "Enter your new score below and view this attraction’s ScoreCard through its details page", preferredStyle: UIAlertController.Style.alert)
        let userInput = UIAlertAction(title: "Add your Score", style: .default) { (alertAction) in
            let textField = scoreAlert.textFields![0] as UITextField
            if textField.text != ""{
                
                let newScore = Int(textField.text!)!
                //Saving score to ScoreCard entity in CoreData
                let userID = Auth.auth().currentUser
                let id = userID?.uid
                self.scoreCardRef = Database.database().reference(withPath: "score-card-list/\(id!)/\(String(self.parkData.parkID))/\(String(selectedRide.rideID))")

                
                let newScoreCard = ScoreCardList(score: newScore, rideID: selectedRide.rideID, date: Date().timeIntervalSince1970)
                let newScoreRef = self.scoreCardRef.child(String(Int(newScoreCard.date)))
                newScoreRef.setValue(newScoreCard.toAnyObject())
        
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
        self.NumCompleteLabel.text = "Progress: \(self.RidesComplete)"
        parkData.totalRides = totNum
        parkData.ridesRidden = userCount
        let percentage = Float(userCount)/Float(totNum)
        
        self.progressBar.setProgress(Float(percentage), animated: true)
        if percentage == 1 {
            progressBar.progressTintColor = goldBar
        }
        else {
            progressBar.progressTintColor = appGreen
        }
        
        parksListRef.updateChildValues([
            "ridesRidden": userCount,
            "totalRides": totNum
            ])
        let favoriteIndex = findIndexFavoritesList(parkID: parkData.parkID)
        if favoriteIndex != -1{
            favoriteListRef.updateChildValues([
                "ridesRidden": userCount,
                "totalRides": totNum
                ])
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
    
    @IBAction func unwindToAttractionsView(sender: UIStoryboardSegue) {
        if sender.source is AttractionsDetailsViewController {
            let rideDetailsVC = sender.source as! AttractionsDetailsViewController
            isfiltering = rideDetailsVC.isfiltering
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UINavigationBar.appearance().tintColor = UIColor.white
        
        print("Back to attractions view")
        if sender.source is FilterViewController || (sender.source is AttractionsDetailsViewController && isfiltering){
            searchController.isActive = true
            typesFiltered.text = ""
            if typeFilter.count == 1 && typeFilter[0] == "ALL"{
                self.typesFiltered.text! += "Showing all Attractions"
            }
            var j = 0
            if typeFilter[0] == "ALL" {
                j = 1
            }
            for i in j..<typeFilter.count {
                self.typesFiltered.text! += "\(typeFilter[i])   "
            }
            //let filterinsets = UIEdgeInsets(top: -4.5, left: 0, bottom: 5.5, right: 0)
            self.attractionsTableView.contentInset = insets

            DispatchQueue.main.async {
                self.searchController.isActive = true
            }
            self.attractionsTableView.tableHeaderView = searchController.searchBar
           searchController.searchBar.becomeFirstResponder()
        }
        if sender.source is ParkSettingsViewController{
            
        }
        UIView.animate(withDuration: 0.3, animations: ({
            self.darkenLayer.backgroundColor = UIColor.clear
            self.view.layoutIfNeeded()
        }))
    }
    
    func updateViewFromSettings(parkDetailVC: ParkSettingsViewController){
        showExtinct = parkDetailVC.showDefunct
        attractionListForTable.removeAll()
        userAttractionDatabase.removeAll()
        updateAttraction()
        attractionsTableView.reloadData()
    }
    
    @IBAction func unwindfromdetails(_ sender: UIStoryboardSegue) {
        print ("Back from deatils")
        UIView.animate(withDuration: 0.3, animations: ({
            self.darkenLayer.backgroundColor = UIColor.clear
            self.view.layoutIfNeeded()
            
        }))
    }

    
    @IBAction func panGestureReconizer(_ sender: UIPanGestureRecognizer) {
        //print("Pressed")
        let touchPoint = (sender as AnyObject).location(in: self.view?.window)
        
        if (sender as AnyObject).state == UIGestureRecognizer.State.began{
            initialToucnPoint = touchPoint
        }
        else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialToucnPoint.y > 0 {
                self.downBar.setImage(UIImage(named: "Flat Bar"), for: .normal)
                
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialToucnPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        }
        else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
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
        //Configure for iPhone X
        if screenSize.height == 812 || UIScreen.main.bounds.height == 896.0{
            //self.notificationViewHeight.constant = 85
        }
        UIView.animate(withDuration: 0.4, animations: ({
            self.view.layoutIfNeeded()
        }))
    }
    
    func animateAwayNotificationView() {
        notificationViewBottomConstrant.constant = -75
        //Configure for iPhone X
        if screenSize.height == 812 || UIScreen.main.bounds.height == 896.0{
            //self.notificationViewHeight.constant = 59
        }
        UIView.animate(withDuration: 0.4, animations: ({
            self.view.layoutIfNeeded()
        }))
    }
 
    func getUserAttractionDatabaseIndex(rideID: Int) -> Int {
        var foundID = 0
        var i = 0
        repeat {
            if userAttractionDatabase[i].rideID == rideID{
                foundID = i
                break
            }
            i += 1
        } while i < userAttractionDatabase.count
        return foundID
    }
    
    func dateFormatter(date: Date) -> String {
        //let date = Date(timeIntervalSince1970: Double (timeToFormat))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMMM d, yyyy" //took off  h:mm Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func updateAttraction(){

//        let userID = Auth.auth().currentUser
//        let id = userID?.uid

        attractionListRef.observeSingleEvent(of: .value, with: { snapshot in
            print("OBSERVING UPDATE ATTRACTIONS AFTER SEGUING FROM PARK INFO. This should not run any other time")
            var attractions: [AttractionList] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let attractionItem = AttractionList(snapshot: snapshot) {
                    attractions.append(attractionItem)
                }
            }
            self.userAttractionDatabase = attractions
            self.countOfRemove = 0
            self.itemsDownloaded(items: self.savedItems, returnPath: "Gettings attraction data")
        })
    }

    
}
extension AttractionsViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
       // let searchBar = searchController.searchBar
        let scope = self.typeFilter[0]
        
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
extension AttractionsViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegata
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
