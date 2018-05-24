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
    var city: String!
    var country: String!
    var active: Int!
    var yearOpen: Int!
    var yearClosed: Int!
    var latitude: Double!
    var longitude: Double!
    var seasonal: Int!
    
    override init() {
    }
    
    init(parkID: Int, name: String, city: String, country: String, active: Int, yearOpen: Int, yearClosed: Int, latitude: Double, longitude: Double, seasonal: Int) {
        self.parkID = parkID
        self.name = name
        self.city = city
        self.country = country
        self.active = active
        self.yearOpen = yearOpen
        self.yearClosed = yearClosed
        self.latitude = latitude
        self.longitude = longitude
        self.seasonal = seasonal
    }
    
    override var description: String{
        return "Park name: \(name), Park ID: \(parkID)"
    }
}
