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
        cell.listItemLabel.text = usersList.listData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.listData.count
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            usersList.listData.remove(at: indexPath.row)
            usersList.ref?.updateChildValues([
                "listData": usersList.listData
                ])
            listTableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let itemToMove = usersList.listData[fromIndexPath.row]
        usersList.listData.remove(at: fromIndexPath.row)
        usersList.listData.insert(itemToMove, at: to.row)
        usersList.ref?.updateChildValues([
            "listData": usersList.listData
            ])
        listTableView.reloadData()
    }
    
}
