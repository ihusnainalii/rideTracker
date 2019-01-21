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
    var dayInParkRef: DatabaseReference!
    
    var handle: UInt!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayInParkRef = Database.database().reference(withPath: "day-in-park/\(userID!)")
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let reportCardLogic = ReportCardLogic()
        reportCardLogic.delegate = self

        dayInParkRef.observe(.value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            var dateArray = [Int]()
            var date = Any?("")
            if value != nil{
                for i in 0..<(value?.allKeys.count)!{
                    date = value?.allKeys[i]
                    dateArray.append(Int(date as! String)!)
                }
                if dateArray.count != 0{
                    dateArray.sort()
                    self.date = dateArray[dateArray.count-1]
                    reportCardLogic.getTodaysStatsSorted(userID: self.userID, date: self.date)
                }
            }
        })
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dayInParkRef.removeObserver(withHandle: handle)
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
