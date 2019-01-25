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
    
    var userID: String!
    var date = 0
    var arrayOfStats = [Stat]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        
        let reportCardLogic = ReportCardLogic()
        reportCardLogic.delegate = self
        reportCardLogic.getTodaysStatsSorted(userID: userID, date: date)
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
