//
//  AttractionsModel.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/14/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit

class AttractionsModel: NSObject {

    var attractionID: Int!
    var name: String!
    var parkID: Int!
    var active: Bool!
    var isCheck: Bool!
    
    override init() {
        
    }
    
    init(attractionID: Int, name: String, parkID: Int, active: Bool, isCheck: Bool) {
        self.attractionID = attractionID
        self.name = name
        self.parkID = parkID
        self.active = active
        self.isCheck = isCheck
    
    }
    init(attractionID: Int){
        self.attractionID = attractionID
    }
    
    
    override var description: String{
        return "Attraction name: \(name)!, Park ID: \(parkID)!"
    }
}
