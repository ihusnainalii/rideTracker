//
//  ParksModel.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/15/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit
import CoreLocation

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
    var perviousNames: String!
    var type: String!
    
    var favorite: Bool!
    var ridesRidden: Int!
    var totalRides: Int!
    

    
    override init() {
    }
    
    init(parkID: Int, name: String, city: String, country: String, active: Int, yearOpen: Int, yearClosed: Int, latitude: Double, longitude: Double, seasonal: Int, favorite: Bool, ridesRidden: Int, totalRides: Int, perviousNames: String, type: String) {
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
        self.perviousNames = perviousNames
        self.type = type
        
        self.favorite = favorite
        self.ridesRidden = ridesRidden
        self.totalRides = totalRides
    }
    
    func getLocation() -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
  
    
    override var description: String{
        return "Park name: \(name), Park ID: \(parkID)"
    }
}
