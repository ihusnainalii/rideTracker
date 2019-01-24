//
//  ApproveSuggestedAttractionViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 7/3/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import Firebase

class SuggestionstoApproveListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataModelProtocol {
    
    //var feedItems: NSArray = NSArray()
    var listOfSuggestions = [ApproveSuggestAttracionModel]()
    var approvedAttractions: DatabaseReference!
    var pendingNotification: DatabaseReference!
    var sendDBRef: DatabaseReference!

    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    var selectedAttraction: ApproveSuggestAttracionModel = ApproveSuggestAttracionModel()
    
    @IBOutlet weak var sendNotificationButton: UIButton!
    @IBOutlet weak var ApproveAttractionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndecator.isHidden = true
        approvedAttractions = Database.database().reference(withPath:"approvedSuggestions")
        pendingNotification = Database.database().reference(withPath:"approvedSuggestions/Attractions")
        sendDBRef = Database.database().reference(withPath:"approvedSuggestions/Send")
        approvedAttractions.observe(.value, with: { snapshot in
            if (snapshot.hasChild("Attractions")){ self.sendNotificationButton.isEnabled = true }
            else {self.sendNotificationButton.isEnabled = false}
        })
            
        let urlPath = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/UserSuggestDownloadService.php?listName=UserSuggest"
        let dataModel = DataModel()
        dataModel.delegate = self
        dataModel.downloadData(urlPath: urlPath, dataBase: "Suggest", returnPath: "allParks")
        
        self.ApproveAttractionTableView.delegate = self
        self.ApproveAttractionTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        let arrayOfAllRides = items as! [ApproveSuggestAttracionModel]
        print ("size of array",arrayOfAllRides.count)
        for i in 0..<arrayOfAllRides.count{
        listOfSuggestions.append(arrayOfAllRides[i])
        }
     //   listOfSuggestions.sort{ $0.key < $1.key }
        listOfSuggestions.sort { ($1.parkName, $1.rideName) > ($0.parkName, $0.rideName) }

        self.ApproveAttractionTableView.reloadData()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfSuggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestCell", for: indexPath) as! SuggestTableViewCell
        let item: ApproveSuggestAttracionModel = listOfSuggestions[indexPath.row]
        let typeConvert = convertRideTypeID(rideTypeID: Int(item.type))
        let tempDate = item.dateAdded
        let justDate = tempDate!.prefix(10)
        if item.notes == "Notes/Citations" {
            item.notes = ""
        }
        if item.modify == 1{
            cell.modifyLabel!.text = "Modify"
        }
        else {
            cell.modifyLabel!.text = "New"
        }
        cell.parkNameLabel!.text = item.parkName
        cell.rideNameLabel!.text = item.rideName
        cell.userNameLabel!.text = item.userName
        cell.dateLabel!.text = String(justDate)
        cell.typeLabel!.text = typeConvert
    
        return cell
    }
    
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            //code to remove from database****
            print ("Deleting key ", self.listOfSuggestions[indexPath.row].id!)
            let dataModel = DataModel()
            dataModel.delegate = self
           
            let urlPath =  "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/deleteFromList.php?list=UserSuggest&key=id&tempID=\(self.listOfSuggestions[indexPath.row].id!)"
            print (urlPath)
            
            let changes = "NEW RIDE: \(self.listOfSuggestions[indexPath.row].rideName!) opened in \(self.listOfSuggestions[indexPath.row].YearOpen!) and is type \(self.listOfSuggestions[indexPath.row].type!)"
            
            let (urlPath3) = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/uploadToDatabaseLog.php? username=\("username")&changes=\(changes)&status=\("Deleted")" //uploads to suggestion log
            dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
            dataModel.downloadData(urlPath: urlPath3, dataBase: "upload", returnPath: "upload")
            self.listOfSuggestions.remove(at: indexPath.row)
            success(true)
            self.ApproveAttractionTableView.reloadData()
    })
    deleteAction.backgroundColor = UIColor.red
    let configurations = UISwipeActionsConfiguration(actions: [deleteAction])
    configurations.performsFirstActionWithFullSwipe = true
    return configurations
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
            return "Childrens Ride"
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
    
    
    @IBAction func unwindToApproveView(sender: UIStoryboardSegue) {
        print("Back to approve attractions view")
        print ("ID IS ", selectedAttraction.id)
        print ("The deleted ride was ", selectedAttraction.rideName)
        for i in 0..<self.listOfSuggestions.count {
            if self.listOfSuggestions[i].id! == selectedAttraction.id! {
            self.listOfSuggestions.remove(at: i)
                break
            }
        }
        ApproveAttractionTableView.reloadData()
    }
    @IBAction func sendNotification(_ sender: Any) {
        activityIndecator.isHidden = false
        activityIndecator.startAnimating()
        approvedAttractions.updateChildValues(["Send": "TRUE"])
        sendNotificationButton.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.pendingNotification.removeValue()
            self.sendDBRef.removeValue()
            self.activityIndecator.isHidden = true
            self.sendNotificationButton.isHidden = false
        }
        
    }
    
    @IBAction func unwindFromcancelButton(sender: UIStoryboardSegue) {
        print ("back from cancel")
    }
    
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toDetails"{
        let selectedIndex = (ApproveAttractionTableView.indexPathForSelectedRow?.row)!
        selectedAttraction = listOfSuggestions[selectedIndex]
        
        let detailsVC = segue.destination as! SuggestDetailsViewController
    detailsVC.selectedAttraction = selectedAttraction
    }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
