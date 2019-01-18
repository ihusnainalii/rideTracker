//
//  ReportCardViewController.swift
//  
//
//  Created by Mark Lawrence on 1/12/19.
//

import UIKit
import Firebase

class ReportCardViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    
    var userID: String!
    var reportCardLogic = ReportCardLogic()
    var date = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //reportCardLogic.getTodaysStatsSorted(userID: userID)
        
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local//OR NSTimeZone.localTimeZone()
        let midnight = calendar.startOfDay(for: Date())
        
        print(userID!)
        
        let dayInParkRef = Database.database().reference(withPath: "day-in-park/\(userID!)")
        
        dayInParkRef.observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            //print(value)
            for i in 0..<(value?.allKeys.count)!{
                let date = value?.allKeys[i]
                print(date!)
                let dateString = date as! String
                if self.date == 0{
                    self.date = Int(dateString)!
                    self.self.reportCardLogic.getTodaysStatsSorted(userID: self.userID, date: self.date)
                }
            }
            
            self.updateLabels()
        })
        
        
    }

    func updateLabels(){
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM-dd-yyyy"
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
//        //let date: NSDate? = dateFormatter.date(from: "2016-02-29 12:24:26") as! NSDate
//        let dateToFormat = Date.init(timeIntervalSince1970: TimeInterval(date))
//
        

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMMM d, yyyy"
        dayTimePeriodFormatter.timeZone = NSTimeZone.local
        
        let dateString = dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(date)))
        dateLabel.text = dateString
        //print(date)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
