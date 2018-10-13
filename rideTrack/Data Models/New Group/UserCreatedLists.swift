//
//  File.swift
//  rideTrack
//
//  Created by Mark Lawrence on 10/12/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct UserCreatedLists {
    
    let ref: DatabaseReference?
    let key: String
    
    var listName: String!
    var listEntryNames: [String]!
    var listEntryRideID: [Int]!
    
    
    
    init(listName: String, listData: [String], listEntryRideID: [Int], key: String = "") {
        self.ref = nil
        self.key = key
        self.listName = listName
        self.listEntryNames = listData
        self.listEntryRideID = listEntryRideID
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let listName = value["listName"] as? String,
            let listEntryRideID = value["listEntryRideID"] as? [Int],
            let listEntryNames = value["listEntryNames"] as? [String] else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.listName = listName
        self.listEntryNames = listEntryNames
        self.listEntryRideID = listEntryRideID
    }
    
    func toAnyObject() -> Any {
        return [
            "listName": listName,
            "listEntryRideID": listEntryRideID,
            "listEntryNames": listEntryNames
        ]
    }
}
