//
//  DayInParkAttractionList.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/8/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct DayInParkAttractionList {
    
    let ref: DatabaseReference?
    let key: String
    
    var rideID: Int!
    var numberOfTimesRiddenToday: Int!
    var rideName: String!
    
    var rideType: Int!
    var yearOpen: Int!
    
    var numberOfTimesRiddenTotal: Int!
    var manufacturer: String!
    var height: Double!
    var speed: Double!
    var length: Double!
    var duration: Int!
    var scoreCardScore: Double!
    
    
    init(rideID: Int, numberOfTimesRiddenToday: Int, rideName: String, rideType: Int, yearOpen: Int, numberOfTimesRiddenTotal: Int!, manufacturer: String, height: Double, speed: Double, length: Double, duration: Int!, scoreCardScore: Double, key: String = "") {
        self.ref = nil
        self.key = key
        
        self.rideID = rideID
        self.numberOfTimesRiddenToday = numberOfTimesRiddenToday
        self.rideName = rideName
        self.rideType = rideType
        self.yearOpen = yearOpen
        self.numberOfTimesRiddenTotal = numberOfTimesRiddenTotal
        self.manufacturer = manufacturer
        self.height = height
        self.speed = speed
        self.length = length
        self.duration = duration
        self.scoreCardScore = scoreCardScore
    }
    
    init?(snapshot: DataSnapshot) {
        
        let value = snapshot.value as? [String: AnyObject]
        let rideID = value!["rideID"] as? Int
        let numberOfTimesRiddenToday = value!["numberOfTimesRiddenToday"] as? Int
        let rideName = value!["rideName"] as? String
        let rideType = value!["rideType"] as? Int
        let yearOpen = value!["yearOpen"] as? Int
        let numberOfTimesRiddenTotal = value!["numberOfTimesRiddenTotal"] as? Int
        let manufacturer = value!["manufacturer"] as? String
        let height = value!["height"] as? Double
        let speed = value!["speed"] as? Double
        let length = value!["length"] as? Double
        let duration = value!["duration"] as? Int
        let scoreCardScore = value!["scoreCardScore"] as? Double
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.rideID = rideID
        self.numberOfTimesRiddenToday = numberOfTimesRiddenToday
        self.rideName = rideName
        self.rideType = rideType
        self.yearOpen = yearOpen
        self.numberOfTimesRiddenTotal = numberOfTimesRiddenTotal
        self.manufacturer = manufacturer
        self.height = height
        self.speed = speed
        self.length = length
        self.duration = duration
        self.scoreCardScore = scoreCardScore
    }
    
    func toAnyObject() -> Any {
        return [
            "rideID": rideID,
            "numberOfTimesRiddenToday": numberOfTimesRiddenToday,
            "rideName": rideName,
            "rideType": rideType,
            "yearOpen": yearOpen,
            "numberOfTimesRiddenTotal": numberOfTimesRiddenTotal,
            "manufacturer": manufacturer,
            "height": height,
            "speed": speed,
            "length": length,
            "duration": duration,
            "scoreCardScore": scoreCardScore
        ]
    }
}

