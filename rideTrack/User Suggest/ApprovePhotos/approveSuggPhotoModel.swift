//
//  approveSuggPhotoModel.swift
//  rideTrack
//
//  Created by Justin Lawrence on 10/17/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class approveSuggPhotoModel: NSObject {
    
    var rideID: Int!
    var userName: String!
    var rideName: String!
    var ParkName: String!
    var parkID: Int!
    override init() {
        
    }
    
    init(rideID: Int, parkID: Int, userName: String, rideName: String, parkName: String) {
        
        self.rideID = rideID
        self.userName = userName
        self.rideName = rideName
        self.ParkName = parkName
        self.parkID = parkID
    }
    override var description: String {
        return "ride: \(rideName)"
    }
    
}

