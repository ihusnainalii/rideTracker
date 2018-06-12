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
    var scoreCard: Int!
    var isFavorite: Bool!
    var isIgnored: Bool!
    var numberOfTimesRidden: Int!
    var dateFirstRidden: Date!
    var dateLastRidden: Date!
    override init() {
        
    }
    
    init(name: String, rideID: Int, parkID: Int, rideType: Int, yearOpen: Int, yearClosed: Int, active: Int, isCheck: Bool, isFavorite: Bool, numberOfTimesRidden: Int, dateFirstRidden: Date, dateLastRidden: Date, scoreCard: Int) {
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
        self.dateFirstRidden = dateFirstRidden
        self.dateLastRidden = dateLastRidden
        self.scoreCard = scoreCard
    }
    
    init(rideID: Int){
        self.rideID = rideID
    }
    
    
    override var description: String{
        return "Attraction name: \(name)!, Park ID: \(parkID)!"
    }
    
    
}
