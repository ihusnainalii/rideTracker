//
//  ScoreCardViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 6/11/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import CoreData

class ScoreCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    var scoreCard: [ScoreCard] = [ScoreCard(score: 5414, date: Date()), ScoreCard(score: 532, date: Date()), ScoreCard(score: 68431, date: Date())]
    
    var scoreCard: [ScoreCardModel] = []
    var selectedRide: AttractionsModel!
    var highScore = 0
    
    var fetchRequest: NSFetchedResultsController<RideTrack>? = nil
    var managedContext: NSManagedObjectContext? = nil
    
   
    
    @IBOutlet weak var rideNameLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        getScoreCardData()

        updateHighScore()
        rideNameLabel.text = selectedRide.name
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreCard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as! ScoreCardTableViewCell
        cell.dateLabel.text = dateFormatter(date: scoreCard[indexPath.row].date)
        cell.scoreLabel.text = String(scoreCard[indexPath.row].score)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            deleteScore(scoreToDelete: scoreCard[indexPath.row].score)
            scoreCard.remove(at: indexPath.row)
            updateHighScore()
            tableView.reloadData()
        }
    }
    
    
    @IBAction func didAddNewScore(_ sender: Any) {
        let alert = UIAlertController(title: "Add  new score", message: "Enter your new score for \(selectedRide.name!) to your score card.", preferredStyle: UIAlertControllerStyle.alert)
        let userInput = UIAlertAction(title: "Add your Score", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != ""{
                self.scoreCard.insert(ScoreCardModel(score: Int(textField.text!)!, date: Date(), rideID: self.selectedRide.rideID), at: 0)
                self.saveNewScore(newScore: Int(textField.text!)!)
                self.updateHighScore()
                self.tableView.reloadData()
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
        dateFormatter.dateFormat = "MMMM d, yyyy h:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func updateHighScore() {
        highScore = 0
        for i in 0..<scoreCard.count{
            if scoreCard[i].score > highScore{
                highScore = scoreCard[i].score
            }
        }
        highScoreLabel.text = "High score: \(highScore)"
    }
    
    func getScoreCardData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ScoreCard")
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            print("Loading new scores")
            let tempCard = try managedContext.fetch(fetchRequest)
            for i in 0..<tempCard.count {
                //Only display the scores from the current rideID
                if tempCard[i].value(forKeyPath: "rideID") as? Int == selectedRide.rideID {
                scoreCard.append(ScoreCardModel(score: tempCard[i].value(forKeyPath: "score") as! Int, date: tempCard[i].value(forKeyPath: "date") as! Date, rideID: tempCard[i].value(forKeyPath: "rideID") as! Int))
                }
            }
        }
        catch _ {
            print("Could not increment")
        }
        tableView.reloadData()
    }
    
    func saveNewScore(newScore: Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ScoreCard", in: managedContext)!
        let newScoreCard = NSManagedObject(entity: entity, insertInto: managedContext)
        
        newScoreCard.setValue(newScore, forKey: "score")
        newScoreCard.setValue(selectedRide.rideID, forKeyPath: "rideID")
        newScoreCard.setValue(Date(), forKeyPath: "date")
        
        do {
            try managedContext.save()
            print("Saved score")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteScore(scoreToDelete: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ScoreCard")
        fetchRequest.predicate = NSPredicate(format: "score = %@", "\(scoreToDelete)")
        do
        {
            let fetchedResults =  try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
            
            for entity in fetchedResults! {
                if entity.value(forKeyPath: "rideID") as? Int == selectedRide.rideID {
                    managedContext.delete(entity)
                    print("Score \(scoreToDelete) has been deleted")
                    try! managedContext.save()
                }
            }
        }
        catch _ {
            print("Could not delete")
            
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
