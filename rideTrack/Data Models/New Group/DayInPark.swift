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
    var numberOfVisitsToThePark: Int!
    var parkName: String!
    
    
    init(checkInTime: Double, numberOfVisitsToThePark: Int!, parkName: String, key: String = "") {
        self.ref = nil
        self.key = key
        
        self.checkInTime = checkInTime
        self.numberOfVisitsToThePark = numberOfVisitsToThePark
        self.parkName = parkName
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let checkInTime = value["checkInTime"] as? Double,
            let numberOfVisitsToThePark = value["numberOfVisitsToThePark"] as? Int,
            let parkName = value["parkName"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.checkInTime = checkInTime
        self.numberOfVisitsToThePark = numberOfVisitsToThePark
        self.parkName = parkName
    }
    
    func toAnyObject() -> Any {
        return [
            "checkInTime": checkInTime,
            "numberOfVisitsToThePark": numberOfVisitsToThePark,
            "parkName": parkName
        ]
    }
}

