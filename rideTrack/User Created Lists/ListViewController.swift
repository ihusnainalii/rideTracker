//
//  ListViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 10/13/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var listNameLabel: UILabel!
    
    let screenSize = UIScreen.main.bounds
    var usersList: UserCreatedLists!
    var userCreatedListsRef: DatabaseReference!
    var editToggle = false
    var allParksList = [ParksModel]()
    var darkenBackground=UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        listNameLabel.text = usersList.listName
        
        darkenBackground=UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        darkenBackground.backgroundColor = UIColor.black
        darkenBackground.alpha = 0.0
        darkenBackground.isUserInteractionEnabled = true
        self.view.addSubview(darkenBackground)
    
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didToggleEditMode(_ sender: Any) {
       
        if !editToggle{
            editToggle = true
            listTableView.isEditing = true
        } else{
            editToggle = false
            listTableView.isEditing = false
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell
        cell.listRankLabel.text = "\(indexPath.row+1))"
        cell.listItemLabel.text = usersList.listEntryNames[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.listEntryNames.count
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            usersList.listEntryNames.remove(at: indexPath.row)
            usersList.listEntryRideID.remove(at: indexPath.row)
            usersList.ref?.updateChildValues([
                "listEntryNames": usersList.listEntryNames,
                "listEntryRideID": usersList.listEntryRideID
                ])
            listTableView.deleteRows(at: [indexPath], with: .left)
            listTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let itemToMove = usersList.listEntryNames[fromIndexPath.row]
        let itemToMoveID = usersList.listEntryRideID[fromIndexPath.row]
        usersList.listEntryNames.remove(at: fromIndexPath.row)
        usersList.listEntryRideID.remove(at: fromIndexPath.row)
        
        usersList.listEntryNames.insert(itemToMove, at: to.row)
        usersList.listEntryRideID.insert(itemToMoveID, at: to.row)
        usersList.ref?.updateChildValues([
            "listEntryNames": usersList.listEntryNames,
            "listEntryRideID": usersList.listEntryRideID
            ])
        listTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let attractionDetailsVC = storyBoard.instantiateViewController(withIdentifier: "attractionDetails") as! AttractionsDetailsViewController
        
        
        //let selectedRide = usersList![indexPath.row]
        let selectedRide = AttractionsModel(name: "Shekra", rideID: 136, parkID: 175, rideType: 1, yearOpen: 2015, yearClosed: 0, active: 1, isCheck: true, isFavorite: true, isIgnored: false, numberOfTimesRidden: 1, dateFirstRidden: Date(), dateLastRidden: Date(), scoreCard: 0, manufacturer: "B and M", previousNames: "", model: "", height: 200, speed: 69, length: 1000, duration: 421, photoArtist: "Walter", photoLink: "https://flic.kr/p/25jnLuf", photoCC: "CC 2.0", modifyBy: "", ridePartner: "")
        
        attractionDetailsVC.selectedRide = selectedRide
        //attractionDetailsVC.userAttractionDatabase = userAttractionDatabase
        //attractionDetailsVC.titleName = titleName
        //attractionDetailsVC.favoiteParkList = favoiteParkList
        attractionDetailsVC.isfiltering = false
        attractionDetailsVC.userID = "test123"
        UIView.animate(withDuration: 0.2, animations: {
            self.darkenBackground.alpha =  0.20
        })
        attractionDetailsVC.modalPresentationStyle = .overCurrentContext
        self.present(attractionDetailsVC, animated: true, completion: nil)

        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @IBAction func unwindToUsersListView(sender: UIStoryboardSegue) {
        print("back in list")
        UIView.animate(withDuration: 0.2, animations: {
            self.darkenBackground.alpha =  0.0
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddNewAttraction"{
            let selectPark = segue.destination as! SelectParkViewController
            selectPark.allParksList = allParksList
        }
        
    }
    
    @IBAction func unwindToListView(segue:UIStoryboardSegue) {
        if let sourceViewController = segue.source as? SelectAttractionViewController, let
            newAttraction = sourceViewController.selectedAttraction{
            
            //Add new attraction to list
            usersList.listEntryNames.append(newAttraction.name)
            usersList.listEntryRideID.append(newAttraction.rideID)
            usersList.ref?.updateChildValues([
                "listEntryNames": usersList.listEntryNames,
                "listEntryRideID": usersList.listEntryRideID
                ])
            listTableView.reloadData()
        }
    
    }
    
}
