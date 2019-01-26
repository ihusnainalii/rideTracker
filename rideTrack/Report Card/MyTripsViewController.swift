//
//  MyTripsViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/24/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import UIKit
import Firebase

class MyTripsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    var userID = UserDefaults.standard.string(forKey: "userID")
    var dayInParkRef: DatabaseReference!
    let dayTimePeriodFormatter = DateFormatter()
    var myTripsArray = [MyTrips]()
    
    var handle: UInt!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayInParkRef = Database.database().reference(withPath: "day-in-park/\(userID!)")
        tableView.delegate = self
        tableView.dataSource = self

        backgroundView.layer.cornerRadius = 7
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = UIColor.blue
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        //self.navigationController?.setNavigationBarHidden(false, animated: true)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = dayInParkRef.observe(.value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            var date = Any?("")
            if value != nil{
                self.myTripsArray = []
                for i in 0..<(value?.allKeys.count)!{
                    date = value?.allKeys[i]
                    let parkName = value?.value(forKeyPath: "\(date as! String).todays-stats.parkName")
                    print(parkName!)
                    self.myTripsArray.append(MyTrips(parkName: parkName as! String, date: Int(date as! String)!))
                }
            }
            self.myTripsArray.sort{ $0.date > $1.date }
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReportCard"{
            let reportCardVC = segue.destination as! ReportCardViewController
            let selectedIndex = (tableView.indexPathForSelectedRow?.row)!
            reportCardVC.date = myTripsArray[selectedIndex].date

        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dayInParkRef.removeObserver(withHandle: handle)
    }
    
    func convertDate(date: Int)->String{
        dayTimePeriodFormatter.dateFormat = "MMMM d, yyyy"
        dayTimePeriodFormatter.timeZone = NSTimeZone.local
        
        let dateString = dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(date)))
        return dateString
    }
    
}

extension MyTripsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTripsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTripCell", for: indexPath) as! MyTripsTableViewCell
        cell.dateLabel.text = convertDate(date: myTripsArray[indexPath.row].date)
        cell.parkNameLabel.text = myTripsArray[indexPath.row].parkName
        return cell
    }
}

struct MyTrips {
    let parkName: String!
    let date: Int!
    
    init(parkName: String, date: Int) {
        self.parkName = parkName
        self.date = date
    }
}
