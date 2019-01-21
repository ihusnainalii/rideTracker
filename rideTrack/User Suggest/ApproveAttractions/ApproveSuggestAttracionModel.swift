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
    var rideID: Int!
    var YearOpen: Int!
    var YearClose: Int!
    var type: Int!
    var parkName: String!
    var active: Int!
    var seasonal: Int!
    var manufacturer: String!
    var notes: String!
    var id: Int!
    var modify: Int!
    var scoreCard: Int!
    var formerNames: String!
    var model: String!
    var height: Double!
    var speed: Double!
    var length: Double!
    var duration: Int!
    var userName: String!
    var userID: String!
    var token: String!
    var dateAdded: String!
    var key: Int!

override init() {
    
}

    init(parkID: Int, rideName: String, rideID: Int, YearOpen: Int, YearClose: Int, type: Int, parkName: String, active: Int, seasonal: Int, manufacturer: String, id: Int, notes: String, modify: Int, scoreCard: Int, formerNames: String, model: String, height: Double, speed: Double, length: Double, duration: Int, userEmail: String, userID: String, token: String, dateAdded: String, key: Int) {
    
    self.parkID = parkID
    self.rideName = rideName
    self.rideID = rideID
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
    self.formerNames = formerNames
    self.model = model
    self.height = height
    self.speed = speed
    self.length = length
    self.duration = duration
    self.userName = userEmail
    self.userID = userID
    self.token = token
    self.dateAdded = dateAdded
    self.seasonal = seasonal
    self.key = key
}
override var description: String {
    return "parkID: \(parkID), rideName: \(rideName), Year Open: \(YearOpen), Park name: \(parkName)"        
    }
    
}
