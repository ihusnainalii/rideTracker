//
//  ScoreCardViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 6/11/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class ScoreCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    var scoreCard: [ScoreCard] = [ScoreCard(score: 5414, date: Date()), ScoreCard(score: 532, date: Date()), ScoreCard(score: 68431, date: Date())]
    
    var scoreCard: [ScoreCardList] = []
    var selectedRide: AttractionsModel!
    var highScore = 0
    var highDate = 0.0
    var parkID: Int!
    
    var fetchRequest: NSFetchedResultsController<RideTrack>? = nil
    var managedContext: NSManagedObjectContext? = nil
    
    var scoreCardRef: DatabaseReference!
    var user: User!
   
    
    @IBOutlet weak var doneButtonTopConstrant: NSLayoutConstraint!
    @IBOutlet weak var scoreCardTopConstrant: NSLayoutConstraint!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var highScoreView: UIView!
    @IBOutlet weak var highScoreTextLabel: UILabel!
    @IBOutlet weak var highScoreDateLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var rideNameLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        //getScoreCardData()
        if UIScreen.main.bounds.height == 812.0{
            scoreCardTopConstrant.constant = 29
            doneButtonTopConstrant.constant = 35
        }
        
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        let userID = Auth.auth().currentUser
        let id = userID?.uid
       scoreCardRef = Database.database().reference(withPath: "score-card-list/\(id!)/\(String(selectedRide.parkID))/\(String(selectedRide.rideID))")
        
        scoreCardRef.observe(.value, with: { snapshot in
            var newScoreCard: [ScoreCardList] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let scoreItem = ScoreCardList(snapshot: snapshot) {
                    newScoreCard.append(scoreItem)
                }
            }
            self.scoreCard = newScoreCard
            self.updateHighScore()
            self.tableView.reloadData()
            if self.highScore == 0 {
                self.highScoreDateLabel.isHidden = true
                self.highScoreLabel.isHidden = true
                self.highScoreTextLabel.text = "No Scores Entered"
            }
        })
        print ("High score is \(highScore) at the top")
        addShadowAndRoundRec(uiView: highScoreView)
        addShadowAndRoundRec(uiView: scoreView)
//        topView.layer.shadowOpacity = 0.5
//        topView.layer.shadowOffset = CGSize.zero
        doneButton.layer.cornerRadius = 6
        rideNameLabel.text = selectedRide.name
        

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreCard.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as! ScoreCardTableViewCell
        cell.dateLabel.text = dateFormatter(date: Date(timeIntervalSince1970: scoreCard[indexPath.row].date))
        //Formate score with commas
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        cell.scoreLabel.text = numberFormatter.string(from: NSNumber(value:scoreCard[indexPath.row].score))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            let scoreCardItem = self.scoreCard[indexPath.row]
            scoreCardItem.ref?.removeValue()
            
//            deleteScore(scoreToDelete: scoreCard[indexPath.row].score)
//            scoreCard.remove(at: indexPath.row)
            updateHighScore()
            tableView.reloadData()
            print("AT tableview, high scire is \(highScore)")
        }
    }
    
    
    @IBAction func didAddNewScore(_ sender: Any) {
        let alert = UIAlertController(title: "Add  new score", message: "Enter your new score for \(selectedRide.name!) to your score card.", preferredStyle: UIAlertController.Style.alert)
        let userInput = UIAlertAction(title: "Add your Score", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != ""{
                
                let newScoreCard = ScoreCardList(score: Int(textField.text!)!, rideID: self.selectedRide.rideID, date: Date().timeIntervalSince1970)
                let newScoreRef = self.scoreCardRef.child(String(Int(newScoreCard.date)))
                newScoreRef.setValue(newScoreCard.toAnyObject())
                
                self.highScoreDateLabel.isHidden = false
                self.highScoreLabel.isHidden = false
                self.highScoreTextLabel.text = "High Score:"
                //self.scoreCard.insert(ScoreCardModel(score: Int(textField.text!)!, date: Date(), rideID: self.selectedRide.rideID), at: 0)
                //self.saveNewScore(newScore: Int(textField.text!)!)
           
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            print("cancled")
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your score"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        alert.addAction(userInput)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion:nil)
    }
    
    
    func dateFormatter(date: Date) -> String {
        //let date = Date(timeIntervalSince1970: Double (timeToFormat))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMMM d, yyyy" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func updateHighScore() {
        print("Finding high score")
        highScore = 0
        for i in 0..<scoreCard.count{
            if scoreCard[i].score > highScore{
                self.highScore = scoreCard[i].score
                highDate = scoreCard[i].date
            }
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        highScoreLabel.text = "\(String(describing: numberFormatter.string(from: NSNumber(value:highScore))!))"
        highScoreDateLabel.text = dateFormatter(date: Date(timeIntervalSince1970: highDate))
        print("High score is right here... \(highScore)")
    }
    
    func addShadowAndRoundRec(uiView: UIView){
        uiView.layer.cornerRadius = 7
        uiView.layer.shadowOpacity = 0.3
        uiView.layer.shadowOffset = CGSize.zero
        uiView.layer.shadowRadius = 5
        uiView.layer.backgroundColor = UIColor.white.cgColor
    }


}
