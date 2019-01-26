//
//  ReportCardViewController.swift
//  
//
//  Created by Mark Lawrence on 1/12/19.
//

import UIKit
import Firebase

class ReportCardViewController: UIViewController, ReportCardStatsCalculateDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    var userID = UserDefaults.standard.string(forKey: "userID")
    var date = 0
    var arrayOfStats = [Stat]()
    var doneButtonVisible = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        
        let reportCardLogic = ReportCardLogic()
        reportCardLogic.delegate = self
        reportCardLogic.getTodaysStatsSorted(userID: userID!, date: date)
        doneButton.isHidden = true
        if doneButtonVisible{
            doneButton.isHidden = false
        }
    }

    func displayData(statsArray: [Stat]) {
        print("DISPLAY DATA")
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMMM d, yyyy"
        dayTimePeriodFormatter.timeZone = NSTimeZone.local
        
        let dateString = dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(date)))
        dateLabel.text = "\(dateString)"
        arrayOfStats = statsArray
        tableview.reloadData()
    }
    @IBAction func didTapDone(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "parksVC") as! ViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
}

extension ReportCardViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfStats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCardCell", for: indexPath) as! ReportCardTableViewCell
        cell.statLabel.text = String(arrayOfStats[indexPath.row].stat)
        cell.rideNameLabel.text = arrayOfStats[indexPath.row].rideName
        cell.categoryLabel.text = arrayOfStats[indexPath.row].category
        return cell
    }
    
    
}
