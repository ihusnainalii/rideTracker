//
//  AllListsViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 10/12/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import Firebase

class AllListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var usersLists = [UserCreatedLists]()
    @IBOutlet weak var allListsTableView: UITableView!
    
    var userCreatedListsRef: DatabaseReference!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allListsTableView.delegate = self
        allListsTableView.dataSource = self
        
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        let userID = Auth.auth().currentUser
        let id = userID?.uid
        self.userCreatedListsRef = Database.database().reference(withPath: "user-created-list/\(id!)")
        
        userCreatedListsRef.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
            var newList: [UserCreatedLists] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let listItem = UserCreatedLists(snapshot: snapshot) {
                    newList.append(listItem)
                }
            }
            self.usersLists = newList
            self.allListsTableView.reloadData()
        })
        
    }
    
    @IBAction func didTapAddNewList(_ sender: Any) {
        let newListAlert = UIAlertController(title: "Create a new list", message: "Enter the name of your new list below", preferredStyle: UIAlertController.Style.alert)
        let userInput = UIAlertAction(title: "Create List", style: .default) { (alertAction) in
            let textField = newListAlert.textFields![0] as UITextField
            if textField.text != ""{
                let newList = UserCreatedLists(listName: textField.text!, listData: ["TEST", "123"])
                
                let newListRef = self.userCreatedListsRef.child(String(textField.text!))
                newListRef.setValue(newList.toAnyObject())
            }
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            print("cancled")
        }
        newListAlert.addTextField { (textField) in
            textField.placeholder = "List Name"
        }
        newListAlert.addAction(userInput)
        newListAlert.addAction(cancel)
        self.present(newListAlert, animated: true, completion:nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allListCell", for: indexPath) as! AllListsTableViewCell
        cell.listNameLabel.text = usersLists[indexPath.row].listName
        
        return cell
    }
    
}
