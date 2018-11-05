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
    
    @IBOutlet weak var allListsTableView: UITableView!
    @IBOutlet weak var tableViewBackground: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    var usersLists = [UserCreatedLists]()
    var allParksList = [ParksModel]()
    var userCreatedListsRef: DatabaseReference!
    var user: User!
    var userName = ""
    var editMode = false
    var appGreen = UIColor(red: 81/255.0, green: 164/255.0, blue: 76/255.0, alpha: 1.0)
    
    var newList = false
    var newListTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("view_all_lists", parameters: nil)
        allListsTableView.delegate = self
        allListsTableView.dataSource = self
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().backgroundColor = appGreen
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .medium)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        

        
        tableViewBackground.layer.cornerRadius = 7
        tableViewBackground.layer.shadowOpacity = 0.3
        tableViewBackground.layer.shadowOffset = CGSize.zero
        tableViewBackground.layer.shadowRadius = 5
        tableViewBackground.layer.backgroundColor = UIColor.white.cgColor
 
        
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
                
                self.newListTitle = textField.text!
                self.newList = true
                self.performSegue(withIdentifier: "selectPark", sender: self)
                
                //let newList = UserCreatedLists(listName: textField.text!, listData: ["TEST", "123"], listEntryRideID: [43, 52])
                
                //let newListRef = self.userCreatedListsRef.child(String(textField.text!))
                //newListRef.setValue(newList.toAnyObject())
            }
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            print("cancled")
        }
        newListAlert.addTextField { (textField) in
            textField.placeholder = "List Name"
            textField.autocapitalizationType = .words
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let listItem = self.usersLists[indexPath.row]
            listItem.ref?.removeValue()
            
            //allListsTableView.deleteRows(at: [indexPath], with: .left)
            //allListsTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toList"{
            let listVC = segue.destination as! ListViewController
            let selectedIndex = allListsTableView.indexPathForSelectedRow?.row
            listVC.usersList = usersLists[selectedIndex!]
            listVC.allParksList = allParksList
            listVC.userName = userName
        }
        if segue.identifier == "selectPark"{
            let selectParkVC = segue.destination as! SelectParkViewController
            selectParkVC.newList = true
            selectParkVC.listName = newListTitle
            selectParkVC.allParksList = allParksList
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    @IBAction func didTapEdit(_ sender: Any) {
        if editMode{
            editMode = false
            allListsTableView.isEditing = false
            editButton.setTitle("Edit", for: .normal)
        } else{
            editMode = true
            allListsTableView.isEditing = true
            editButton.setTitle("Done", for: .normal)
        }
        
    }
    @IBAction func unwindToAllLists(segue:UIStoryboardSegue) {
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

