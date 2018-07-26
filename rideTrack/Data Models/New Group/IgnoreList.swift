//
//  IgnoreList.swift
//  rideTrack
//
//  Created by Mark Lawrence on 7/26/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct IgnoreList {
    
    let ref: DatabaseReference?
    let key: String
    
    var rideID: Int!
 
    
    
    init(rideID: Int, key: String = "") {
        self.ref = nil
        self.key = key
        self.rideID = rideID
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let rideID = value["rideID"] as? Int else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.rideID = rideID
    }
    
    func toAnyObject() -> Any {
        return [
            "rideID": rideID
        ]
    }
}

