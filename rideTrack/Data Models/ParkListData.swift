//
//  ParkListData.swift
//  rideTrack
//
//  Created by Mark Lawrence on 5/28/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class ParkListData: NSObject {
    
    var parkID: Int!
    var favorite: Bool!
    var numberOfRides: Int!
    var numberOfCheckedRides: Int!
    
    init(parkID: Int, favorite: Bool, numberOfRides: Int, numberOfCheckedRides: Int) {
        self.parkID = parkID
        self.favorite = favorite
        self.numberOfRides = numberOfRides
        self.numberOfCheckedRides = numberOfCheckedRides
    }
}
