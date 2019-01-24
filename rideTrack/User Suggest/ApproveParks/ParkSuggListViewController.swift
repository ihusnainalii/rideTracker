//
//  ParkSuggListViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 10/12/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import Firebase

class ParkSuggListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataModelProtocol {

    @IBOutlet weak var sendNotificationButton: UIButton!
    @IBOutlet weak var suggestedParkTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var listOfSuggestions = [ApproveSuggParksModel]()
    var selectedPark: ApproveSuggParksModel = ApproveSuggParksModel()
    
    var approvedParks: DatabaseReference!
    var pendingNotification: DatabaseReference!
    var sendDBRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlPath = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/UserSuggestDownloadService.php?listName=SuggestPark"
        let dataModel = DataModel()
        dataModel.delegate = self
        dataModel.downloadData(urlPath: urlPath, dataBase: "ParkSuggest", returnPath: "allParks")
        
        approvedParks = Database.database().reference(withPath:"approvedSuggestions")
        pendingNotification = Database.database().reference(withPath:"approvedSuggestions/Parks")
        sendDBRef = Database.database().reference(withPath:"approvedSuggestions/SendPark")

        approvedParks.observe(.value, with: { snapshot in
            if (snapshot.hasChild("Parks")){ self.sendNotificationButton.isEnabled = true }
            else {self.sendNotificationButton.isEnabled = false}
        })
        self.suggestedParkTableView.delegate = self
        self.suggestedParkTableView.dataSource = self
        self.activityIndicator.isHidden = true

        
        // Do any additional setup after loading the view.
    }
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        let arrayOfParks = items as! [ApproveSuggParksModel]
        print ("size of array",arrayOfParks.count)
        for i in 0..<arrayOfParks.count{
            listOfSuggestions.append(arrayOfParks[i])
        }
        listOfSuggestions.sort{ $0.name < $1.name }
        self.suggestedParkTableView.reloadData()
   }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return listOfSuggestions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestedParks", for: indexPath) as! suggestParkTableViewCell
        cell.parkNameLabel.text = listOfSuggestions[indexPath.row].name
        let location = "\(listOfSuggestions[indexPath.row].city!), \(listOfSuggestions[indexPath.row].country!)"
        let tempDate = listOfSuggestions[indexPath.row].date
        let justDate = tempDate!.prefix(10)
        cell.locationLabel.text = location
        cell.usernameLabel.text = listOfSuggestions[indexPath.row].userName
        cell.dateLabel.text = String(justDate)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func sendNotificationButtonPressed(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        approvedParks.updateChildValues(["SendPark": "TRUE"])
        sendNotificationButton.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.pendingNotification.removeValue()
            self.activityIndicator.isHidden = true
            self.sendDBRef.removeValue()
            self.sendNotificationButton.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toApprovePark"{
            let selectedIndex = (suggestedParkTableView.indexPathForSelectedRow?.row)!
            selectedPark = listOfSuggestions[selectedIndex]
            let detailsVC = segue.destination as! ApproveParkViewController
            detailsVC.selectedPark = selectedPark
        }
    }
   
    @IBAction func unwindTosuggParkList(sender: UIStoryboardSegue) {
        print("back to list of parks suggestions")
        for i in 0..<self.listOfSuggestions.count {
            if self.listOfSuggestions[i].tempID! == selectedPark.tempID! {
                self.listOfSuggestions.remove(at: i)
                break
            }
        }
        suggestedParkTableView.reloadData()
        //print("Back to choose what type of attraction/park/photo to approve")
    }
    @IBAction func unwindFromcancelButton(sender: UIStoryboardSegue) {
        print ("back from cancel")
    }
}
