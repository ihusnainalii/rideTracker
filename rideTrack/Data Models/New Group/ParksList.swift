//
//  ParkList.swift
//  rideTrack
//
//  Created by Mark Lawrence on 7/22/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct ParksList {
    
    let ref: DatabaseReference?
    let key: String
    
    var parkID: Int!
    var name: String!
    var location: String!
    var favorite: Bool!
    var ridesRidden: Int!
    var totalRides: Int!
    var incrementorEnabled: Bool!
    var showDefunct: Bool!
    
    
    init(parkID: Int, favorite: Bool, ridesRidden: Int, totalRides: Int, incrementorEnabled: Bool, name: String, location: String, showDefunct: Bool, key: String = "") {
        self.ref = nil
        self.key = key
        self.parkID = parkID
        self.favorite = favorite
        self.ridesRidden = ridesRidden
        self.totalRides = totalRides
        self.incrementorEnabled = incrementorEnabled
        self.name = name
        self.location = location
        self.showDefunct = showDefunct
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let parkID = value["parkID"] as? Int,
            let ridesRidden = value["ridesRidden"] as? Int,
            let totalRides = value["totalRides"] as? Int,
            let incrementorEnabled = value["incrementorEnabled"] as? Bool,
            let name = value["name"] as? String,
            let location = value["location"] as? String,
            let favorite = value["favorite"] as? Bool else {
                return nil
        }
        var showDefunct = false
        if let showDefunctCheck = value["showDefunct"] as? Bool{
            showDefunct = showDefunctCheck
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.parkID = parkID
        self.favorite = favorite
        self.ridesRidden = ridesRidden
        self.totalRides = totalRides
        self.incrementorEnabled = incrementorEnabled
        self.name = name
        self.location = location
        self.showDefunct = showDefunct
    }
    
    func toAnyObject() -> Any {
        return [
            "parkID": parkID,
            "favorite": favorite,
            "ridesRidden": ridesRidden,
            "totalRides": totalRides,
            "name": name,
            "location": location,
            "showDefunct": showDefunct,
            "incrementorEnabled": incrementorEnabled
            
        ]
    }
}

