//
//  AttractionsModel.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/14/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit

class AttractionsModel: NSObject {

    var name: String!
    var rideID: Int!
    var parkID: Int!
    var rideType: Int!
    var yearOpen: Int!
    var yearClosed: Int!
    var active: Int!
    var isCheck: Bool!
    var isFavorite: Bool!
    var isIgnored: Bool!
    var numberOfTimesRidden: Int!
    override init() {
        
    }
    
    init(name: String, rideID: Int, parkID: Int, rideType: Int, yearOpen: Int, yearClosed: Int, active: Int, isCheck: Bool, isFavorite: Bool, isIgnored: Bool, numberOfTimesRidden: Int) {
        self.name = name
        self.rideID = rideID
        self.parkID = parkID
        self.rideType = rideType
        self.yearOpen = yearOpen
        self.yearClosed = yearClosed
        self.active = active
        self.isCheck = isCheck
        self.isFavorite = isFavorite
        self.isIgnored = isIgnored
        self.numberOfTimesRidden = numberOfTimesRidden
    }
    
    init(rideID: Int){
        self.rideID = rideID
    }
    
    
    override var description: String{
        return "Attraction name: \(name)!, Park ID: \(parkID)!"
    }
    
    
}
