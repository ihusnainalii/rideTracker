//
//  ApprovedSuggestionsList.swift
//  rideTrack
//
//  Created by Justin Lawrence on 1/19/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct ApprovedSuggestiobsList {
    
    let ref: DatabaseReference?

    var expName: String!
    var userToken: String!
    
    
    init(userToken: String, expName: String = "") {
        self.ref = nil
        self.userToken = userToken
        self.expName = expName
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let expName = value["Name"] as? String,
            let userToken = value["Token"] as? String else {
                return nil
        }
    
        
        self.ref = snapshot.ref
        self.userToken = userToken
        self.expName = expName
    }
    
    func toAnyObject() -> Any {
        return [
            "Token": userToken,
            "Name": expName
        ]
    }
}


