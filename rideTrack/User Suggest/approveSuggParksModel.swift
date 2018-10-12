//
//  approveSuggParksModel.swift
//  rideTrack
//
//  Created by Justin Lawrence on 10/12/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class ApproveSuggParksModel: NSObject {
    
    var name: String!
    var type: String!
    var city: String!
    var country: String!
    var latitude: Int!
    var longitude: Int!
    var open: Int!
    var closed: Int!
    var defunct: Int!
    var prevName: String!
    var seasonal: Int!
    var website: String!
    var userName: String!
    
    override init() {
        
    }
    
    init(name: String, type: String, city: String, country: String, latitude: Int, longitude: Int, open: Int, closed: Int, defunct: Int, prevName: String, seasonal: Int, website: String, userName: String) {
        
        self.name = name
        self.type = type
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.open = open
        self.closed = closed
        self.defunct = defunct
        self.prevName = prevName
        self.seasonal = seasonal
        self.website = website
        self.userName = userName
    }
    override var description: String {
        return "park: \(name)"
    }
    
}
