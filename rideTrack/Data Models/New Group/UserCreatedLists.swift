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
    var listData: [String]!
    
    
    
    init(listName: String, listData: [String], key: String = "") {
        self.ref = nil
        self.key = key
        self.listName = listName
        self.listData = listData
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let listName = value["listName"] as? String,
            let listData = value["listData"] as? [String] else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.listName = listName
        self.listData = listData
    }
    
    func toAnyObject() -> Any {
        return [
            "listName": listName,
            "listData": listData
        ]
    }
}
