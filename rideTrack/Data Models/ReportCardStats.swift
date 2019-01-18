//
//  ReportCardStats.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/12/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import UIKit

class ReportCardStats: NSObject {
    
    var maxHeight: Double!
    var maxHeightName: String!
    
    var maxSpeed: Double!
    var maxSpeedName: String!
    
    var totalTrackLength: Double!
    var numberOfAttractionsExperienced: Int!
    var uniqueAttractionCount: Int!
    var attractionExperiencedMostName: String!
    var attractionExperiencedMostCount: Int!
    var manufactureExperiencedMostName: String!
    var manufactureExperiencedMostCount: Int!
    var scoreCardHighest: Int!
    var scoreCardName: String!
    var numberOfVisitsToThePark: Int!
    var oldestRideName: String!
    var oldestRideOpeningYear: Int!
    var firstTimeExperiences = [String]()
    
    
    var numberOfRollerCoasters: Int!
    var numberOfWaterRides: Int!
    var numberOfChildrensRides: Int!
    var numberOfFlatRides: Int!
    var numberOfTransportRides: Int!
    var numberOfDarkRides: Int!
    var numberOfExploreRides: Int!
    var numberOfSpectaculars: Int!
    var numberOfShows: Int!
    var numberOfFilms: Int!
    var numberOfParades: Int!
    var numberOfPlayAreas: Int!
    var numberOfUpcharges: Int!
    
    override init() {
        maxHeight = 0.0
        maxHeightName = ""
        totalTrackLength = 0.0
        maxSpeed = 0.0
        maxSpeedName = ""
        numberOfAttractionsExperienced = 0
        uniqueAttractionCount = 0
        attractionExperiencedMostName = ""
        attractionExperiencedMostCount = 0
        manufactureExperiencedMostName = ""
        manufactureExperiencedMostCount = 0
        scoreCardHighest = 0
        scoreCardName = ""
        numberOfVisitsToThePark = 0
        oldestRideName = ""
        oldestRideOpeningYear = 3000
        firstTimeExperiences = [String]()
        
        
        numberOfRollerCoasters = 0
        numberOfWaterRides = 0
        numberOfChildrensRides = 0
        numberOfFlatRides = 0
        numberOfTransportRides = 0
        numberOfDarkRides = 0
        numberOfExploreRides = 0
        numberOfSpectaculars = 0
        numberOfShows = 0
        numberOfFilms = 0
        numberOfParades = 0
        numberOfPlayAreas = 0
        numberOfUpcharges = 0
    }
}




    

