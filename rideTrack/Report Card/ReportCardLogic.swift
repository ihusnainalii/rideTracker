//
//  ReportCardLogic.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/12/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import Foundation
import Firebase

class ReportCardLogic {
    
    
    private var attractionList: [DayInParkAttractionList]!
    private var dayInParkStats: DayInPark!
    private var statsDownloaded = false
    private var attractionsDownloaded = false
    
    
    func getTodaysStatsSorted(userID: String){
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local//OR NSTimeZone.localTimeZone()
        let midnight = calendar.startOfDay(for: Date())
        
        let dayInParkStatsRef = Database.database().reference(withPath: "day-in-park/\(userID)/\(midnight.timeIntervalSince1970)")
        let dayInParkAttractionsRef = Database.database().reference(withPath: "day-in-park/\(userID)/\(midnight.timeIntervalSince1970)/todays-attractions")
        
        
        dayInParkStatsRef.observeSingleEvent(of: .value, with: { snapshot in
            var dayInParkStatsArray: [DayInPark] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let dayInParkItem = DayInPark(snapshot: snapshot) {
                    dayInParkStatsArray.append(dayInParkItem)
                }
            }
            if dayInParkStatsArray.count == 1{
                self.dayInParkStats = dayInParkStatsArray[0]
            }
            self.statsDownloaded = true
            print("Stats Done")
            if self.attractionsDownloaded{
                //Ready to calculate stats
            }
        })
        
        dayInParkAttractionsRef.observeSingleEvent(of: .value, with: { snapshot in
            var dayInParkAttractionList: [DayInParkAttractionList] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let dayInParkItem = DayInParkAttractionList(snapshot: snapshot) {
                    dayInParkAttractionList.append(dayInParkItem)
                }
            }
            self.attractionList = dayInParkAttractionList
            self.attractionsDownloaded = true
            print("Attractions Done")
            if self.statsDownloaded{
                //Ready to calculate stats
            }
        })
    }
    
    

}
