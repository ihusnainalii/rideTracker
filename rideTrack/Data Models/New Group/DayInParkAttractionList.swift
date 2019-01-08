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
    var numberOfTimesRidden: Int!
    var firstRideDate: Double!
    var lastRideDate: Double!
    var rideName: String!
    
    
    
    init(rideID: Int, numberOfTimesRidden: Int, firstRideDate: Double, lastRideDate: Double, rideName: String, key: String = "") {
        self.ref = nil
        self.key = key
        
        self.rideID = rideID
        self.numberOfTimesRidden = numberOfTimesRidden
        self.firstRideDate = firstRideDate
        self.lastRideDate = lastRideDate
        self.rideName = rideName
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let rideID = value["rideID"] as? Int,
            let numberOfTimesRidden = value["numberOfTimesRidden"] as? Int,
            let firstRideDate = value["firstRideDate"] as? Double,
            let rideName = value["rideName"] as? String,
            let lastRideDate = value["lastRideDate"] as? Double else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.rideID = rideID
        self.numberOfTimesRidden = numberOfTimesRidden
        self.firstRideDate = firstRideDate
        self.lastRideDate = lastRideDate
        self.rideName = rideName
    }
    
    func toAnyObject() -> Any {
        return [
            "rideID": rideID,
            "numberOfTimesRidden": numberOfTimesRidden,
            "firstRideDate": firstRideDate,
            "lastRideDate": lastRideDate,
            "rideName": rideName
        ]
    }
}

