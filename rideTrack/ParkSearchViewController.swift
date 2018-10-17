//
//  ParkSearchViewController.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/17/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit

class ParkSearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var parkArray: [ParksModel]!
    var selectedPark: ParksModel?
    var park = ParksModel()
    var firstEntry = true
    var initialToucnPoint : CGPoint = CGPoint(x: 0, y: 0)
    var parksVC: ViewController!
    var savedParks = [ParksList]()
    var SuggestPark = ParksModel()
    var userName = ""
    var searchForPark = SearchForPark()

    //A list of parks searched for, to display in results table
    var searchedParksList: [ParksModel]!
    
    @IBOutlet weak var searchTextFeild: UITextField!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var blurBackgroundView: UIVisualEffectView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var downButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SuggestPark.name = "Park Not Found?"
        SuggestPark.city = "To add it to our database"
        SuggestPark.country = "please suggest it here"
        blurBackgroundView.layer.cornerRadius = 10
        parkArray.sort { $0.name < $1.name }
        searchTextFeild.becomeFirstResponder()
        searchedParksList = parkArray
        
        self.searchTextFeild.delegate = self
        self.resultsTableView.delegate = self
        // Do any additional setup after loading the view.
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            resultsTableView.contentInset = UIEdgeInsets.zero
        } else {
            resultsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        resultsTableView.scrollIndicatorInsets = resultsTableView.contentInset
        
//        let selectedRange = resultsTableView.selectedRange
//        resultsTableView.scrollRangeToVisible(selectedRange)
    }
    
   
    @IBAction func didUpdateText(_ sender: Any) {
        searchedParksList.removeAll()
        
        let searchedString = searchTextFeild.text!.replacingOccurrences(of: "’", with: "'", options: .literal, range: nil)
        searchedParksList = searchForPark.searchParks(searchString: searchedString, parkArray: parkArray)
        searchedParksList.append(SuggestPark) //add option to suggest park at bottom
        self.resultsTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedParksList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let parkName = searchedParksList![indexPath.row].name!
        if parkName != "Park Not Found?" {
            print("run unwind at \(parkName)")
            self.performSegue(withIdentifier: "addNewParkToList", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "suggestPark", sender: self)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchedParkCell", for: indexPath) as! SearchTableViewCell
        let item: ParksModel = searchedParksList[indexPath.row]
        for i in 0..<savedParks.count {
            if item.name == savedParks[i].name {
                cell.greenDot.isHidden = false
                break
            }
            else {cell.greenDot.isHidden = true}
        }
        if savedParks.count == 0 {
            cell.greenDot.isHidden = true
        }
        cell.parkNameLabel.text = item.name
        cell.parkLocationLabel.text = "\(item.city!), \(item.country!)"
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "addNewParkToList") {
            print("here")
            if let indexPath = resultsTableView.indexPathForSelectedRow {
                selectedPark = (searchedParksList[indexPath.row] )
                print("Adding \(selectedPark?.name!)")
            }
            searchTextFeild.resignFirstResponder()
        }
        
        if (segue.identifier == "cancel") {
            print("CANCEL")
            UIView.animate(withDuration: 0.2, animations: {
                self.parksVC.darkenBackground.alpha = 0.0
            })
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: parksVC.allParksBottomInsetValue, right: 0)
            parksVC.allParksTableView.contentInset = insets
            selectedPark = nil
            searchTextFeild.resignFirstResponder()
        }
        if (segue.identifier == "suggestPark"){
            let suggestPark = segue.destination as! SuggestParkViewController
            suggestPark.userName = userName
        }
        
    }
    
    @IBAction func panSeachAway(_ sender: UIPanGestureRecognizer) {
        let touchPoint = (sender as AnyObject).location(in: self.view?.window)
        
        if (sender as AnyObject).state == UIGestureRecognizer.State.began{
            initialToucnPoint = touchPoint
        }
        else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialToucnPoint.y > 0 {
                self.downButton.setImage(UIImage(named: "Flat Bar"), for: .normal)
                
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialToucnPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        }
        else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialToucnPoint.y > 200 {
                self.dismiss(animated: true, completion: nil)
                self.searchTextFeild.resignFirstResponder()
                UIView.animate(withDuration: 0.2, animations: {
                    self.parksVC.darkenBackground.alpha = 0.0
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.downButton.setImage(UIImage(named: "Down Bar"), for: .normal)
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
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


class SearchForPark{
    func searchParks(searchString: String, parkArray: [ParksModel]) -> [ParksModel]{
        var searchedString = searchString
        var park = ParksModel()
        var searchedParksList: [ParksModel] = []
        var firstEntry = true
        
        if searchedString.last == " "{
            searchedString.removeLast()
        }
        if searchedString == ""{
            searchedParksList = parkArray
        }
        
        for i in 0..<parkArray.count {
            park = parkArray[i]
            firstEntry = true
            if (park.name.lowercased().range(of: searchedString.lowercased()) != nil){
                searchedParksList.append(park)
                firstEntry = false
            }
            
            //Not allow you to add duplicates
            if (park.city.lowercased().range(of: searchedString.lowercased()) != nil) && firstEntry{
                searchedParksList.append(park)
                firstEntry = false
            }
            if (park.country.lowercased().range(of: searchedString.lowercased()) != nil) && firstEntry{
                searchedParksList.append(park)
                firstEntry = false
            }
        }
        return searchedParksList
    }
    
}
