//
//  SelectParkViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 10/13/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class SelectParkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

 
    @IBOutlet weak var allParkTableView: UITableView!
    @IBOutlet weak var parkSearchTextFeild: UITextField!
    
    var searchedParksList: [ParksModel]!
    var allParksList = [ParksModel]()
    var searchForPark = SearchForPark()
    
    var newList = false
    var listName = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        allParkTableView.delegate = self
        allParkTableView.dataSource = self
        parkSearchTextFeild.delegate = self
        allParksList.sort { $0.name < $1.name }
        searchedParksList = allParksList
        print("All list array is \(allParksList.count)")
        
        // Do any additional setup after loading the view.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func didUpdateText(_ sender: Any) {
        searchedParksList.removeAll()
        let searchedString = parkSearchTextFeild.text!.replacingOccurrences(of: "’", with: "'", options: .literal, range: nil)
        searchedParksList = searchForPark.searchParks(searchString: searchedString, parkArray: allParksList)
        self.allParkTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedParksList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectPark", for: indexPath) as! SelectParkTableViewCell
        cell.parkNameLabel.text = searchedParksList[indexPath.row].name
        cell.locationLabel.text = searchedParksList[indexPath.row].city
        return cell

    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            allParkTableView.contentInset = UIEdgeInsets.zero
        } else {
            allParkTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        allParkTableView.scrollIndicatorInsets = allParkTableView.contentInset
        
        //        let selectedRange = resultsTableView.selectedRange
        //        resultsTableView.scrollRangeToVisible(selectedRange)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSelectAttraction"{
            let selectAttractionVC = segue.destination as! SelectAttractionViewController
            let selectedIndex = allParkTableView.indexPathForSelectedRow?.row
            selectAttractionVC.selectedPark = searchedParksList[selectedIndex!]
            if newList{
                selectAttractionVC.firstItemInList = newList
                selectAttractionVC.listName = listName
            }
           
        }
        
    }

}
