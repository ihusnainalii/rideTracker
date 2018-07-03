//
//  AttractionsDetailsViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 5/28/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import CoreData

class AttractionsDetailsViewController: UIViewController {
    
    var typeString = ""
    var selectedRide = AttractionsModel()
    var favorites = [Int]()
    let favList = UserDefaults.standard
    var isFavorite = false
    var modifyDate = Date()
    var comeFromDetails = false
    var userAttractionDatabase: [UserAttractionProvider]!
    var titleName = ""

    let greyColor = UIColor(red: 211/255.0, green: 213/255.0, blue: 215/255.0, alpha: 1.0)
    
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var manufacturText: UILabel!
    @IBOutlet weak var dateModifyButton: UIButton!
    @IBOutlet weak var CurrentlyOpenLabel: UILabel!
    @IBOutlet weak var rideNameLabel: UILabel!
    @IBOutlet weak var yearCloseLabel: UITextField!
    @IBOutlet weak var yearOpenLabel: UITextField!
    @IBOutlet weak var yearCloseText: UILabel!
    @IBOutlet weak var attractiontype: UITextField!
    @IBOutlet weak var dateFirstRiddenLabel: UILabel!
    @IBOutlet weak var dateLastRiddenLabel: UILabel!
    @IBOutlet weak var modifyDateView: UIView!
    @IBOutlet weak var modifyDatePicker: UIDatePicker!
    @IBOutlet weak var scoreCardButton: UIButton!
    
    @IBOutlet weak var detailViewHeight: NSLayoutConstraint!
    @IBOutlet weak var userDatesView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var OverlayView: UIView!
    var initialToucnPoint : CGPoint = CGPoint(x: 0, y: 0)
    @IBOutlet weak var darkenLayer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OverlayView.layer.cornerRadius = 10.0

        
        modifyDatePicker.maximumDate = Date()
        scoreCardButton.isHidden = true
        scoreCardButton.backgroundColor = greyColor
        scoreCardButton.layer.cornerRadius = 6.0
        
        dateModifyButton.layer.cornerRadius = 5.0
        dateModifyButton.backgroundColor = UIColor.lightGray
        userDatesView.backgroundColor = greyColor
        userDatesView.layer.cornerRadius = 10.0
        rideNameLabel.text = selectedRide.name
        if selectedRide.yearOpen == 0{
            yearOpenLabel.text = "Unknown"
        }
        else{
            yearOpenLabel.text = String(selectedRide.yearOpen)
        }
        if selectedRide.active == 1 {
            yearCloseLabel.isHidden = true
            yearCloseText.isHidden = true
            
        }
        else {
            yearCloseLabel.text = String (selectedRide.yearClosed)
            CurrentlyOpenLabel.isHidden = true
        }
        if selectedRide.isCheck{
            dateFirstRiddenLabel.text = dateFormatter(date: selectedRide.dateFirstRidden)
            userDatesView.isHidden = false
            //Do not show last ride if the user has only ridden the ride once
            if selectedRide.numberOfTimesRidden > 1{
                dateLastRiddenLabel.text = dateFormatter(date: selectedRide.dateLastRidden)
            }
            else{
                dateLastRiddenLabel.isHidden = true
            }
        }
        else{
            dateFirstRiddenLabel.isHidden = true
            dateLastRiddenLabel.isHidden = true
            dateModifyButton.isHidden = true
            userDatesView.isHidden = true
            
        }
        
        if selectedRide.hasScoreCard == 1{
            scoreCardButton.isHidden = false
        }
        if selectedRide.manufacturer == "" {
            manufacturText.isHidden = true
            manufacturerLabel.isHidden = true
        }
        else {
            manufacturerLabel.isHidden = false
            manufacturText.isHidden = false
            manufacturerLabel.text = selectedRide.manufacturer
        }
        
        switch selectedRide.rideType {                      
        case 1:
            typeString = "Roller Coaster"
        case 2:
            typeString = "Water Ride"
        case 3:
            typeString = "Children's Ride"
        case 4:
            typeString = "Flat Ride"
        case 5:
            typeString = "Transport Ride"
        case 6:
            typeString = "Dark Ride"
        case 7:
            typeString = "Explore"
        case 8:
            typeString = "Spectacular"
        case 9:
            typeString = "Show"
        case 10:
            typeString = "Film"
        case 11:
            typeString = "Parade"
        case 12:
            typeString = "Play Area"
        default:
            typeString = "Unknown"
        }
        if typeString == "Unknown"{
            attractiontype.isHidden = true
        }
        attractiontype.text = typeString

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIView.animate(withDuration: 0.7, animations: { //Animate Here
            self.darkenLayer.backgroundColor = UIColor.black.withAlphaComponent(0.3)
           // self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressModifyDate(_ sender: Any) {
        modifyDateView.isHidden = false
        dateModifyButton.isEnabled = false
        modifyDatePicker.setDate(selectedRide.dateFirstRidden, animated: false)
        UIView.animate(withDuration: 0.3, animations: { //Animate Here
            self.detailViewHeight.constant += 130
            self.detailsView.frame.origin.y -= 10
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func pressDownBar(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: { //Animate Here
            self.darkenLayer.backgroundColor = UIColor.black.withAlphaComponent(0)
            // self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func didSaveModifyDate(_ sender: Any) {
        modifyDateView.isHidden = true
        dateModifyButton.isEnabled = true
        dateFirstRiddenLabel.text = dateFormatter(date: modifyDatePicker.date)
        selectedRide.dateFirstRidden = modifyDatePicker.date
        saveModifyFirstRideDate(rideID: selectedRide.rideID, firstRideDate: modifyDatePicker.date)
        UIView.animate(withDuration: 0.3, animations: { //Animate Here
            self.detailViewHeight.constant -= 130
            self.detailsView.frame.origin.y += 10

            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func saveModifyFirstRideDate(rideID: Int, firstRideDate: Date){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RideTrack")
        fetchRequest.predicate = NSPredicate(format: "rideID = %@", "\(rideID)")
        do {
            let fetchedResults =  try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
            for entity in fetchedResults! {
                entity.setValue(firstRideDate, forKey: "firstRideDate")
                try! managedContext.save()
                print("Changing first ride date for ride ID \(rideID) to \(firstRideDate)")
            }
        }
        catch _ {
            print("Could not increment")
        }
        
    }
    
    func dateFormatter(date: Date) -> String {
        //let date = Date(timeIntervalSince1970: Double (timeToFormat))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMMM d, yyyy" //took off  h:mm Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    @IBAction func tapToExit(_ sender: UITapGestureRecognizer) {
        print ("Tap")
        UIView.animate(withDuration: 0.2, animations: { //Animate Here
            print ("Animating")
            self.darkenLayer.backgroundColor = UIColor.black.withAlphaComponent(0)
            // self.view.layoutIfNeeded()
        }, completion: nil)
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func panToExit(_ sender: UIPanGestureRecognizer) {
        let touchPoint = (sender as AnyObject).location(in: self.view?.window)
        
        if (sender as AnyObject).state == UIGestureRecognizerState.began{
            initialToucnPoint = touchPoint
            
        }
        else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialToucnPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialToucnPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
                UIView.animate(withDuration: 0.2, animations: { //Animate Here
                    self.darkenLayer.backgroundColor = UIColor.black.withAlphaComponent(0)
                    // self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
        else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialToucnPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
               
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    UIView.animate(withDuration: 0.2, animations: { //Animate Here
                        self.darkenLayer.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                        // self.view.layoutIfNeeded()
                    }, completion: nil)
                })
            }
        }
    }

    
    
     // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toScoreCard"{
            let newVC = segue.destination as! ScoreCardViewController
            newVC.selectedRide = selectedRide
        }
        if segue.identifier == "toAttractions"{
            print ("Comeing back")
            let newVC = segue.destination as! AttractionsViewController
            newVC.comeFromDetails = true
            newVC.parkID = selectedRide.parkID
            newVC.titleName = titleName
            newVC.userAttractionDatabase = userAttractionDatabase
        }
    }
    
    @IBAction func unwindToDetailsView(sender: UIStoryboardSegue) {
        print("Back to attractions view")
    }
    @IBAction func unwindToAttractionsView(sender: UIStoryboardSegue) {
        print("Back to attractions view")
    }
}
