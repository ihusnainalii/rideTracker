//
//  SelectAttractionViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 10/13/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import Firebase

class SelectAttractionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DataModelProtocol {

    @IBOutlet weak var selectAttractionTableView: UITableView!
    @IBOutlet weak var searchAttractionsTextFeidl: UITextField!
    
    var attractionList = [AttractionsModel]()
    var selectedAttraction: AttractionsModel!
    var selectedPark: ParksModel!
    var searchAttractionList = [AttractionsModel]()
    var userCreatedListsRef: DatabaseReference!
    var user: User!
    
    var firstItemInList = false
    var listName = ""
    
     let screenSize = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectAttractionTableView.dataSource = self
        selectAttractionTableView.delegate = self
        searchAttractionsTextFeidl.delegate = self
        
        self.navigationItem.title = "Select An Attraction"
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .medium)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        let userID = Auth.auth().currentUser
        let id = userID?.uid
        self.userCreatedListsRef = Database.database().reference(withPath: "user-created-list/\(id!)")

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let urlPath = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/attractiondbservice.php?parkid=\(selectedPark.parkID!)"
        let dataModel = DataModel()
        dataModel.delegate = self
        
        dataModel.downloadData(urlPath: urlPath, dataBase: "attractions", returnPath: "attractions")
        // Do any additional setup after loading the view.
    }
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        for i in 0..<items.count{
            attractionList.append(items[i] as! AttractionsModel)
        }
        attractionList.sort { ($0.active, $1.name) > ($1.active, $0.name)}
        searchAttractionList = attractionList
        selectAttractionTableView.reloadData()
        
    }
    
    @IBAction func didUpdateText(_ sender: Any) {
        searchAttractionList.removeAll()
        var searchedString = searchAttractionsTextFeidl.text!.replacingOccurrences(of: "’", with: "'", options: .literal, range: nil)
        //searchedParksList = searchForPark.searchParks(searchString: searchedString, parkArray: allParksList)
        var attraction = AttractionsModel()
        var firstEntry = true
        
        if searchedString.last == " "{
            searchedString.removeLast()
        }
        if searchedString == ""{
            searchAttractionList = attractionList
        }
        
        for i in 0..<attractionList.count {
            attraction = attractionList[i]
            firstEntry = true
            if (attraction.name.lowercased().range(of: searchedString.lowercased()) != nil){
                searchAttractionList.append(attraction)
                firstEntry = false
            }
            
            //Not allow you to add duplicates
            if (convertRideTypeID(rideTypeID: attraction.rideType).lowercased().range(of: searchedString.lowercased()) != nil) && firstEntry{
                searchAttractionList.append(attraction)
                firstEntry = false
            }
        }
        self.selectAttractionTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchAttractionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectAttraction", for: indexPath) as! SelectAttractionTableViewCell
        cell.attractionNameLabel.text = searchAttractionList[indexPath.row].name
        cell.rideTypeLabel.text = convertRideTypeID(rideTypeID: searchAttractionList[indexPath.row].rideType)
        
        if screenSize.width == 320.0{
            ConfigureSmallerLayout().listselectAttractionCellLayout(selectAttractionCell: cell)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAttraction = searchAttractionList[indexPath.row]
        
        if firstItemInList{
            Analytics.logEvent("creat_new_list", parameters: ["listName": listName])
            let newList = UserCreatedLists(listName: listName, listData: [selectedAttraction.name], listEntryRideID: [selectedAttraction.rideID])
            
            let newListRef = self.userCreatedListsRef.child(String(listName))
            newListRef.setValue(newList.toAnyObject())
            self.performSegue(withIdentifier: "toAllLists", sender: self)
        } else{
            self.performSegue(withIdentifier: "toListView", sender: self)
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
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            selectAttractionTableView.contentInset = UIEdgeInsets.zero
        } else {
            selectAttractionTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        selectAttractionTableView.scrollIndicatorInsets = selectAttractionTableView.contentInset
        
        //        let selectedRange = resultsTableView.selectedRange
        //        resultsTableView.scrollRangeToVisible(selectedRange)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "addNewAttractionToList") {
            if let indexPath = selectAttractionTableView.indexPathForSelectedRow {
                selectedAttraction = (attractionList[indexPath.row] )
            }
        }
        
    }

}
