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
    var usersList: UserCreatedLists!
    var userCreatedListsRef: DatabaseReference!
    var editToggle = false
    var allParksList = [ParksList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        listNameLabel.text = usersList.listName
    
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
