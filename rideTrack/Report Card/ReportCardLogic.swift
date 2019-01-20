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
    func displayData(stringToDisplay: String)
}

class ReportCardLogic {
    
    
    private var attractionList: [DayInParkAttractionList]!
    private var dayInParkStats: DayInPark!
    private var statsDownloaded = false
    private var attractionsDownloaded = false
    
    weak var delegate: ReportCardStatsCalculateDelegate?
    
    func getTodaysStatsSorted(userID: String, date: Int){
        
        let dayInParkStatsRef = Database.database().reference(withPath: "day-in-park/\(userID)/\(String(date))")
        let dayInParkAttractionsRef = Database.database().reference(withPath: "day-in-park/\(userID)/\(String(date))/todays-attractions")
        
        
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
                self.calculateStats()
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
                self.calculateStats()
            }
        })
    }
    
    func calculateStats(){
        var reportCardCalculatedStats = ReportCardStats()
        for attraction in attractionList{
            if attraction.height > reportCardCalculatedStats.maxHeight{
                reportCardCalculatedStats.maxHeight = attraction.height!
                reportCardCalculatedStats.maxHeightName = attraction.rideName!
            }
            if attraction.speed > reportCardCalculatedStats.maxSpeed{
                reportCardCalculatedStats.maxSpeed = attraction.speed
                reportCardCalculatedStats.maxSpeedName = attraction.rideName
            }
            if attraction.numberOfTimesRiddenToday > reportCardCalculatedStats.attractionExperiencedMostCount{
                reportCardCalculatedStats.attractionExperiencedMostCount = attraction.numberOfTimesRiddenToday
                reportCardCalculatedStats.attractionExperiencedMostName = attraction.rideName
            }
            if attraction.yearOpen < reportCardCalculatedStats.oldestRideOpeningYear{
                reportCardCalculatedStats.oldestRideOpeningYear = attraction.yearOpen
                reportCardCalculatedStats.oldestRideName = attraction.rideName
            }
            
            if attraction.numberOfTimesRiddenTotal == 1{
                reportCardCalculatedStats.firstTimeExperiences.append(attraction.rideName)
            }
            /*
            if Int(attraction.scoreCardScore) > reportCardCalculatedStats.scoreCardHighest{
                reportCardCalculatedStats.scoreCardHighest = Int(attraction.scoreCardScore)
                reportCardCalculatedStats.scoreCardName = attraction.rideName
            }
 */
            
            reportCardCalculatedStats.totalTrackLength += Double(Int(attraction.length) * attraction.numberOfTimesRiddenToday)
            reportCardCalculatedStats.numberOfAttractionsExperienced += 1
            reportCardCalculatedStats.uniqueAttractionCount += attraction.numberOfTimesRiddenToday
            reportCardCalculatedStats = sortAttractionIntoRideType(reportCardCalculatedStats: reportCardCalculatedStats, attraction: attraction)
        }

        printTestData(reportCardCalculatedStats: reportCardCalculatedStats)
    }
    
    func sortAttractionIntoRideType(reportCardCalculatedStats: ReportCardStats, attraction: DayInParkAttractionList) -> ReportCardStats{
        print(attraction.rideType!)
        switch attraction.rideType! {
        case -1:
            print("Unknown ride type")
        case 1:
            print("New coaster")
            reportCardCalculatedStats.numberOfRollerCoasters += 1
        case 2:
            reportCardCalculatedStats.numberOfWaterRides += 1
        case 3:
            reportCardCalculatedStats.numberOfChildrensRides += 1
        case 4:
            reportCardCalculatedStats.numberOfFlatRides += 1
        case 5:
            reportCardCalculatedStats.numberOfTransportRides += 1
        case 6:
            reportCardCalculatedStats.numberOfDarkRides += 1
        case 7:
            reportCardCalculatedStats.numberOfExploreRides += 1
        case 8:
            reportCardCalculatedStats.numberOfSpectaculars += 1
        case 9:
            reportCardCalculatedStats.numberOfShows += 1
        case 10:
            reportCardCalculatedStats.numberOfFilms += 1
        case 11:
            reportCardCalculatedStats.numberOfParades += 1
        case 12:
            reportCardCalculatedStats.numberOfPlayAreas += 1
        case 13:
            reportCardCalculatedStats.numberOfUpcharges += 1
        default:
            print("Unknown stats")
        }
        return reportCardCalculatedStats
    }
    
    func printTestData(reportCardCalculatedStats: ReportCardStats){
        let stringToPrint = "Max height: \(reportCardCalculatedStats.maxHeightName!) \(reportCardCalculatedStats.maxHeight!)\n" + "Max Speed: \(reportCardCalculatedStats.maxSpeedName!) \(reportCardCalculatedStats.maxSpeed!)\n" + "Attraction experienced the most: \(reportCardCalculatedStats.attractionExperiencedMostName!) \(reportCardCalculatedStats.attractionExperiencedMostCount!)\n"+"Oldest attraction experienced: \(reportCardCalculatedStats.oldestRideName!) \(reportCardCalculatedStats.oldestRideOpeningYear!)\n"+"Total Track Length: \(reportCardCalculatedStats.totalTrackLength!)\n"+"Total numbers of attractions: \(reportCardCalculatedStats.numberOfAttractionsExperienced!)\n"+"Total unique attraction count: \(reportCardCalculatedStats.uniqueAttractionCount!)\n"+"Attraction experienced Most: \(reportCardCalculatedStats.attractionExperiencedMostName!) \(reportCardCalculatedStats.attractionExperiencedMostCount!)\n"+"Roller Coasters: \(reportCardCalculatedStats.numberOfRollerCoasters!)\n"+"Water rides: \(reportCardCalculatedStats.numberOfWaterRides!)\n"+"Flat ride: \(reportCardCalculatedStats.numberOfFlatRides!)"
        
        delegate?.displayData(stringToDisplay: stringToPrint)
            
        print("Max height: \(reportCardCalculatedStats.maxHeightName!) \(reportCardCalculatedStats.maxHeight!)")
        print("Max Speed: \(reportCardCalculatedStats.maxSpeedName!) \(reportCardCalculatedStats.maxSpeed!)")
        print("Attraction experienced the most: \(reportCardCalculatedStats.attractionExperiencedMostName!) \(reportCardCalculatedStats.attractionExperiencedMostCount!)")
        print("Oldest attraction experienced: \(reportCardCalculatedStats.oldestRideName!) \(reportCardCalculatedStats.oldestRideOpeningYear!)")
        print("Total Track Length: \(reportCardCalculatedStats.totalTrackLength!)")
        print("Total numbers of attractions: \(reportCardCalculatedStats.numberOfAttractionsExperienced!)")
        print("Total unique attraction count: \(reportCardCalculatedStats.uniqueAttractionCount!)")
        print("Attraction experienced Most: \(reportCardCalculatedStats.attractionExperiencedMostName!) \(reportCardCalculatedStats.attractionExperiencedMostCount!)")
        print("Roller Coasters: \(reportCardCalculatedStats.numberOfRollerCoasters!)")
        print("Water rides: \(reportCardCalculatedStats.numberOfWaterRides!)")
        print("ChildrensRides: \(reportCardCalculatedStats.numberOfChildrensRides!)")
        print("Flat ride: \(reportCardCalculatedStats.numberOfFlatRides!)")
        print("Transport ride: \(reportCardCalculatedStats.numberOfTransportRides!)")
        print("First time experiences: ")
        for i in 0..<reportCardCalculatedStats.firstTimeExperiences.count{
            print(reportCardCalculatedStats.firstTimeExperiences[i])
        }



    }
    

}
