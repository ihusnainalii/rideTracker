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
    var hasScoreCard: Int!
    var isFavorite: Bool!
    var isIgnored: Bool!
    var numberOfTimesRidden: Int!
    var dateFirstRidden: Date!
    var dateLastRidden: Date!
    var manufacturer: String!
    var previousNames: String!
    var model: String!
    var height: Int!
    var speed: Int!
    var length: Int!
    var duration: Int!
    var photoArtist: String!
    var photoLink: String!
    var photoCC: String!
    var modifyBy: String!
    var ridePartner: String!
    var notes: String!
     
    
    override init() {
        
    }
    
    init(name: String, rideID: Int, parkID: Int, rideType: Int, yearOpen: Int, yearClosed: Int, active: Int, isCheck: Bool, isFavorite: Bool, isIgnored: Bool, numberOfTimesRidden: Int, dateFirstRidden: Date, dateLastRidden: Date, scoreCard: Int, manufacturer: String, previousNames: String, model: String, height: Int, speed: Int, length: Int, duration: Int, photoArtist: String, photoLink: String, photoCC: String,modifyBy: String, ridePartner: String, notes: String) {
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
        self.hasScoreCard = scoreCard
        self.manufacturer = manufacturer
        self.previousNames = previousNames
        self.model = model
        self.height = height
        self.speed = speed
        self.length = length
        self.duration = duration
        self.photoArtist = photoArtist
        self.photoLink = photoLink
        self.photoCC = photoCC
        self.modifyBy = modifyBy
        self.ridePartner = ridePartner
        self.notes = notes
    
    }
    
    init(rideID: Int){
        self.rideID = rideID
    }
    
    
    override var description: String{
        return "Attraction name: \(name)!, Park ID: \(parkID)!"
    }
    
    
}
