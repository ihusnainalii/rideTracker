//
//  ReportCardLogic.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/12/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import Foundation
import Firebase

protocol ReportCardStatsCalculateDelegate: class{
    func displayData(statsArray: [Stat])
}

class ReportCardLogic {
    
    private var attractionList: [DayInParkAttractionList]!
    private var dayInParkStats: DayInPark!
    private var statsDownloaded = false
    private var attractionsDownloaded = false
    
    var handleAttractions: UInt!
    var handleStats: UInt!
    var calculateOnce:Int = 0
    
    var dayInParkStatsRef: DatabaseReference!
    var dayInParkAttractionsRef: DatabaseReference!
    
    weak var delegate: ReportCardStatsCalculateDelegate?
    
    func getTodaysStatsSorted(userID: String, date: Int){
        dayInParkStatsRef = Database.database().reference(withPath: "day-in-park/\(userID)/\(String(date))")
        dayInParkAttractionsRef = Database.database().reference(withPath: "day-in-park/\(userID)/\(String(date))/todays-attractions")
        
        handleStats = dayInParkStatsRef.observe(.value, with: { snapshot in
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
                if self.calculateOnce == 0{
                    self.calculateStats()
                    self.calculateOnce += 1
                }
            }
        })
 
        handleAttractions = dayInParkAttractionsRef.observe(.value, with: { snapshot in
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
                if self.calculateOnce == 0{
                    self.calculateStats()
                    self.calculateOnce += 1
                }
            }
        })
    }
    
    func calculateStats(){
        var calculatedStats = ReportCardStats()
        for attraction in attractionList{
            if Int(attraction.height) > calculatedStats.maxHeight.stat{
                calculatedStats.maxHeight.setStat(stat: Int(attraction.height!), rideName: attraction.rideName!)
            }
            if Int(attraction.speed) > calculatedStats.maxSpeed.stat{
                calculatedStats.maxSpeed.setStat(stat: Int(attraction.speed!), rideName: attraction.rideName!)
            }
            if attraction.numberOfTimesRiddenToday > calculatedStats.attractionExperiencedMost.stat{
                calculatedStats.attractionExperiencedMost.setStat(stat: attraction.numberOfTimesRiddenToday, rideName: attraction.rideName)
            }
            if attraction.yearOpen < calculatedStats.oldestRide.stat{
                calculatedStats.oldestRide.setStat(stat: attraction.yearOpen, rideName: attraction.rideName)
            }
            
            if attraction.numberOfTimesRiddenTotal == 1{
                calculatedStats.firstTimeExperiences.append(attraction.rideName)
            }
            /*
            if Int(attraction.scoreCardScore) > reportCardCalculatedStats.scoreCardHighest{
                reportCardCalculatedStats.scoreCardHighest = Int(attraction.scoreCardScore)
                reportCardCalculatedStats.scoreCardName = attraction.rideName
            }
 */
            if dayInParkStats.numberOfVisitsToThePark % 5 == 0{
                calculatedStats.numberOfVisitsToThePark.stat = dayInParkStats.numberOfVisitsToThePark
            }
            calculatedStats.totalTrackLength.stat += Int(Int(attraction.length) * attraction.numberOfTimesRiddenToday)
            calculatedStats.uniqueAttractionCount.stat += 1
            calculatedStats.numberOfAttractionsExperienced.stat += attraction.numberOfTimesRiddenToday
            calculatedStats = sortAttractionIntoRideType(reportCardCalculatedStats: calculatedStats, attraction: attraction)
        }

        let arrayOfStats = calculatedStats.createArrayOfStat()

        print("display data")
        dayInParkStatsRef.removeObserver(withHandle: handleStats)
        dayInParkAttractionsRef.removeObserver(withHandle: handleAttractions)
        delegate?.displayData(statsArray: arrayOfStats)

    }
    
    func sortAttractionIntoRideType(reportCardCalculatedStats: ReportCardStats, attraction: DayInParkAttractionList) -> ReportCardStats{
        switch attraction.rideType! {
        case -1:
            print("Unknown ride type")
        case 1:
            reportCardCalculatedStats.numberOfRollerCoasters.stat += 1
        case 2:
            reportCardCalculatedStats.numberOfWaterRides.stat += 1
        case 3:
            reportCardCalculatedStats.numberOfChildrensRides.stat += 1
        case 4:
            reportCardCalculatedStats.numberOfFlatRides.stat += 1
        case 5:
            reportCardCalculatedStats.numberOfTransportRides.stat += 1
        case 6:
            reportCardCalculatedStats.numberOfDarkRides.stat += 1
        case 7:
            reportCardCalculatedStats.numberOfExploreRides.stat += 1
        case 8:
            reportCardCalculatedStats.numberOfSpectaculars.stat += 1
        case 9:
            reportCardCalculatedStats.numberOfShows.stat += 1
        case 10:
            reportCardCalculatedStats.numberOfFilms.stat += 1
        case 11:
            reportCardCalculatedStats.numberOfParades.stat += 1
        case 12:
            reportCardCalculatedStats.numberOfPlayAreas.stat += 1
        case 13:
            reportCardCalculatedStats.numberOfUpcharges.stat += 1
        default:
            print("Unknown stats")
        }
        return reportCardCalculatedStats
    }
    

}
