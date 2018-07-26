//
//  ParkList.swift
//  rideTrack
//
//  Created by Mark Lawrence on 7/26/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct ScoreCardList {
    
    let ref: DatabaseReference?
    let key: String
    
    var score: Int!
    var rideID: Int!
    var date: Double!

    
    
    init(score: Int, rideID: Int, date: Double, key: String = "") {
        self.ref = nil
        self.key = key
        self.rideID = rideID
        self.score = score
        self.date = date
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let rideID = value["rideID"] as? Int,
            let score = value["score"] as? Int,
            let date = value["date"] as? Double else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.rideID = rideID
        self.score = score
        self.date = date
        
    }
    
    func toAnyObject() -> Any {
        return [
            "rideID": rideID,
            "score": score,
            "date": date
        ]
    }
}

