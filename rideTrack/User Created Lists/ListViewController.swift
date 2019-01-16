//
//  ListViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 10/13/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataModelProtocol {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableBackgroundView: UIView!
    @IBOutlet weak var addAttractionButton: UIButton!
    
    let screenSize = UIScreen.main.bounds
    var usersList: UserCreatedLists!
    var userCreatedListsRef: DatabaseReference!
    var editToggle = false
    var allParksList = [ParksModel]()
    var darkenBackground=UIView()
    var userName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        self.navigationItem.title = usersList.listName
        editButton.setTitle("Edit", for: .normal)
        darkenBackground=UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        darkenBackground.backgroundColor = UIColor.black
        darkenBackground.alpha = 0.0
        darkenBackground.isUserInteractionEnabled = true
        
        activityIndicator.stopAnimating()
        
        tableBackgroundView.layer.cornerRadius = 7
        tableBackgroundView.layer.shadowOpacity = 0.3
        tableBackgroundView.layer.shadowOffset = CGSize.zero
        tableBackgroundView.layer.shadowRadius = 5
        tableBackgroundView.layer.backgroundColor = UIColor.white.cgColor
        
        addAttractionButton.layer.shadowOpacity = 0.5
        addAttractionButton.layer.shadowOffset = CGSize.zero
        addAttractionButton .layer.shadowRadius = 12
        
        self.view.addSubview(darkenBackground)
    
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didToggleEditMode(_ sender: Any) {
       
        if !editToggle{
            editToggle = true
            listTableView.isEditing = true
            editButton.setTitle("Done", for: .normal)
        } else{
            editToggle = false
            listTableView.isEditing = false
            editButton.setTitle("Edit", for: .normal)
        }
        
    }
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        if items.count == 1{
            let selectedAttractionDetails = items[0] as! AttractionsModel
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let attractionDetailsVC = storyBoard.instantiateViewController(withIdentifier: "attractionDetails") as! AttractionsDetailsViewController
            
            attractionDetailsVC.selectedRide = selectedAttractionDetails
            attractionDetailsVC.isfiltering = false
            attractionDetailsVC.userID = userName
            attractionDetailsVC.fromListVC = true
            
            UIView.animate(withDuration: 0.2, animations: {
                self.darkenBackground.alpha =  0.20
            })
            attractionDetailsVC.modalPresentationStyle = .overCurrentContext
            self.present(attractionDetailsVC, animated: true, completion: nil)
            activityIndicator.stopAnimating()
        }
        else{
            print("ERROR: More than one attraction was returned")
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
        
        activityIndicator.startAnimating()
        
        let selectedRideID = usersList.listEntryRideID[indexPath.row]
        let urlPath = "http://www.beingpositioned.com/theparksman/LogRide/Version1.0.5/getAttractionDetails.php?rideID=\(selectedRideID)"
        let dataModel = DataModel()
        dataModel.delegate = self
        dataModel.downloadData(urlPath: urlPath, dataBase: "attractions", returnPath: "attractions")

        tableView.deselectRow(at: indexPath, animated: false)
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
            
            if checkIfNewAttraction(newAttraction: newAttraction){
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
        if segue.source is AttractionsDetailsViewController {
            print("back in list")
            UIView.animate(withDuration: 0.2, animations: {
                self.darkenBackground.alpha =  0.0
            })
        }
    
    }
    
    func checkIfNewAttraction(newAttraction: AttractionsModel) -> Bool {
        var isNewPark = true
        for i in 0..<usersList.listEntryRideID.count{
            if newAttraction.rideID == usersList.listEntryRideID[i]{
                isNewPark = false
            }
        }
        return isNewPark
    }
    
}
