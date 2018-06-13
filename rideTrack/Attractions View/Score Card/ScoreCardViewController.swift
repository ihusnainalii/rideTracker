//
//  ScoreCardViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 6/11/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class ScoreCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var scoreCard: [ScoreCard] = [ScoreCard(score: 5414, date: Date()), ScoreCard(score: 532, date: Date()), ScoreCard(score: 68431, date: Date())]
    var selectedRide: AttractionsModel!
    var highScore = 0
    
    @IBOutlet weak var rideNameLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        
        
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
            scoreCard.remove(at: indexPath.row)
            updateHighScore()
            tableView.reloadData()
        }
    }
    
    
    @IBAction func didAddNewScore(_ sender: Any) {
        let alert = UIAlertController(title: "Add  new score", message: "Enter your new score for \(selectedRide.name!) to your score card.", preferredStyle: UIAlertControllerStyle.alert)
        let userInput = UIAlertAction(title: "Add your Score", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            //Do we want newest scores at the top or bottom??
            self.scoreCard.insert(ScoreCard(score: Int(textField.text!)!, date: Date()), at: 0)
            self.updateHighScore()
            self.tableView.reloadData()
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
        highScore = 0
        for i in 0..<scoreCard.count{
            if scoreCard[i].score > highScore{
                highScore = scoreCard[i].score
            }
        }
        highScoreLabel.text = "High score: \(highScore)"
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
