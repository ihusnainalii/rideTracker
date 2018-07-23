//
//  AttractionList.swift
//  rideTrack
//
//  Created by Mark Lawrence on 7/22/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct AttractionList {
    
    let ref: DatabaseReference?
    let key: String
    
    var rideID: Int!
    var numberOfTimesRidden: Int!
    var firstRideDate: Double!
    var lastRideDate: Double!
    
    
    
    init(rideID: Int, numberOfTimesRidden: Int, firstRideDate: Double, lastRideDate: Double, key: String = "") {
        self.ref = nil
        self.key = key

        self.rideID = rideID
        self.numberOfTimesRidden = numberOfTimesRidden
        self.firstRideDate = firstRideDate
        self.lastRideDate = lastRideDate
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let rideID = value["rideID"] as? Int,
            let numberOfTimesRidden = value["numberOfTimesRidden"] as? Int,
            let firstRideDate = value["firstRideDate"] as? Double,
            let lastRideDate = value["lastRideDate"] as? Double else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.rideID = rideID
        self.numberOfTimesRidden = numberOfTimesRidden
        self.firstRideDate = firstRideDate
        self.lastRideDate = lastRideDate
    }
    
    func toAnyObject() -> Any {
        return [
            "rideID": rideID,
            "numberOfTimesRidden": numberOfTimesRidden,
            "firstRideDate": firstRideDate,
            "lastRideDate": lastRideDate,
        ]
    }
}

