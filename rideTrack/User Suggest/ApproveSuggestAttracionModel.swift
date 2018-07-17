//
//  ApproveSuggestAttracionModel.swift
//  rideTrack
//
//  Created by Justin Lawrence on 7/3/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class ApproveSuggestAttracionModel: NSObject {

    var parkID: Int!
    var rideName: String!
    var YearOpen: Int!
    var YearClose: Int!
    var type: Int!
    var parkName: String!
    var active: Int!
    var manufacturer: String!
    var notes: String!
    var id: Int!
    var modify: Int!
    var scoreCard: Int!

override init() {
    
}

    init(parkID: Int, rideName: String, YearOpen: Int, YearClose: Int, type: Int, parkName: String, active: Int, manufacturer: String, id: Int, notes: String, modify: Int, scoreCard: Int) {
    
    self.parkID = parkID
    self.rideName = rideName
    self.YearOpen = YearOpen
    self.YearClose = YearClose
    self.type = type
    self.parkName = parkName
    self.active = active
    self.id = id
    self.manufacturer = manufacturer
    self.notes = notes
    self.modify = modify
    self.scoreCard = scoreCard
}
override var description: String {
    return "parkID: \(parkID), rideName: \(rideName), Year Open: \(YearOpen), Park name: \(parkName)"        
    }
    
}
