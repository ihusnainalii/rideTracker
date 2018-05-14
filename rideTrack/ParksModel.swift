//
//  ParksModel.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/15/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit

class ParksModel: NSObject {

    var parkID: Int!
    var name: String!
    var location: String!
    var latitude: Double!
    var longitude: Double!
    
    override init() {
    }
    
    init(parkID: Int, name: String, location: String, latitude: Double, longitude: Double) {
        self.parkID = parkID
        self.name = name
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
    }
    
    override var description: String{
        return "Park name: \(name), Park ID: \(parkID)"
    }
}
