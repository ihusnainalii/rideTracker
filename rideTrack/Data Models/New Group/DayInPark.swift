//
//  DayInPark.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/8/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct DayInPark {
    
    let ref: DatabaseReference?
    let key: String
    
    var checkInTime: Double!
    var maxHeight: Double!
    var totalTrackLength: Double!
    var lastRideTime: Double!
    var topSpeed: Double!
    var scoreCardHighest: Int!
    var numberOfVisitsToThePark: Int!
    //var nameOfFirstExperiences: [String?]
    var oldestRide: String!
    var newestRide: String!
    
    
    
    
    init(checkInTime: Double, maxHeight: Double, totalTrackLength: Double, lastRideTime: Double, topSpeed: Double, scoreCardHighest: Int, numberOfVisitsToThePark: Int!, oldestRide: String, newestRide: String, key: String = "") {
        self.ref = nil
        self.key = key
        
        self.checkInTime = checkInTime
        self.maxHeight = maxHeight
        self.totalTrackLength = totalTrackLength
        self.lastRideTime = lastRideTime
        self.topSpeed = topSpeed
        self.scoreCardHighest = scoreCardHighest
        self.numberOfVisitsToThePark = numberOfVisitsToThePark
        //self.nameOfFirstExperiences = nameOfFirstExperiences
        self.oldestRide = oldestRide
        self.newestRide = newestRide
        
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let checkInTime = value["checkInTime"] as? Double,
            let maxHeight = value["maxHeight"] as? Double,
            let totalTrackLength = value["totalTrackLength"] as? Double,
            let lastRideTime = value["lastRideTime"] as? Double,
            let topSpeed = value["topSpeed"] as? Double,
            let scoreCardHighest = value["scoreCardHighest"] as? Int,
            let numberOfVisitsToThePark = value["numberOfVisitsToThePark"] as? Int,
            //let nameOfFirstExperiences = value["nameOfFirstExperiences"] as? [String],
            let oldestRide = value["oldestRide"] as? String,
            let newestRide = value["newestRide"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.checkInTime = checkInTime
        self.maxHeight = maxHeight
        self.totalTrackLength = totalTrackLength
        self.lastRideTime = lastRideTime
        self.topSpeed = topSpeed
        self.scoreCardHighest = scoreCardHighest
        self.numberOfVisitsToThePark = numberOfVisitsToThePark
        //self.nameOfFirstExperiences = nameOfFirstExperiences
        self.oldestRide = oldestRide
        self.newestRide = newestRide
    }
    
    func toAnyObject() -> Any {
        return [
            "checkInTime": checkInTime,
            "maxHeight": maxHeight,
            "totalTrackLength": totalTrackLength,
            "lastRideTime": lastRideTime,
            "topSpeed": topSpeed,
            "scoreCardHighest": scoreCardHighest,
            "numberOfVisitsToThePark": numberOfVisitsToThePark,
            //"nameOfFirstExperiences": nameOfFirstExperiences,
            "oldestRide": oldestRide,
            "newestRide": newestRide
        ]
    }
}

