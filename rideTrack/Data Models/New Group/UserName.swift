//
//  UserName.swift
//  rideTrack
//
//  Created by Mark Lawrence on 9/3/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct UserName {
    
    let ref: DatabaseReference?
    let key: String
    
    var userName: String!
    var userID: String!
    
    
    
    init(userName: String, userID: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.userName = userName
        self.userID = userID
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let userID = value["userID"] as? String,
            let userName = value["userName"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.userName = userName
        self.userID = userID
    }
    
    func toAnyObject() -> Any {
        return [
            "userName": userName,
            "userID": userID
        ]
    }
}
