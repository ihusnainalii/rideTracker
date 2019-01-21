//
//  ReportCardStats.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/12/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import UIKit

class ReportCardStats: NSObject {
    
    var maxHeight: Stat!
    var maxSpeed: Stat!
    var totalTrackLength: Stat!
    var numberOfAttractionsExperienced: Stat!
    var uniqueAttractionCount: Stat!
    var attractionExperiencedMost: Stat!
    var scoreCardHighest: Stat!
    var numberOfVisitsToThePark: Stat!
    var oldestRide: Stat!
    var firstTimeExperiences = [String]()
    
    
    var numberOfRollerCoasters: Stat!
    var numberOfWaterRides: Stat!
    var numberOfChildrensRides: Stat!
    var numberOfFlatRides: Stat!
    var numberOfTransportRides: Stat!
    var numberOfDarkRides: Stat!
    var numberOfExploreRides: Stat!
    var numberOfSpectaculars: Stat!
    var numberOfShows: Stat!
    var numberOfFilms: Stat!
    var numberOfParades: Stat!
    var numberOfPlayAreas: Stat!
    var numberOfUpcharges: Stat!
    
    override init() {
        totalTrackLength = Stat(category: "Total Track Length", weight: 4, minStat: 5280, incrementBy: 2640)
        maxHeight = Stat(category: "Max Height", weight: 5, minStat: 100, incrementBy: 25)
        maxSpeed = Stat(category: "Max Speed", weight: 5, minStat: 50, incrementBy: 5)
        numberOfAttractionsExperienced = Stat(category: "Number of Attractions Experienced", weight: 8, minStat: 7, incrementBy: 3)
        uniqueAttractionCount = Stat(category: "Unique Attraction Count", weight: 6, minStat: 5, incrementBy: 2)
        attractionExperiencedMost = Stat(category: "Attraction Experienced Most", weight: 8, minStat: 2, incrementBy: 1)
        scoreCardHighest = Stat(category: "Score Card", weight: 8, minStat: 1000000, incrementBy: 1000)
        numberOfVisitsToThePark = Stat(category: "Number of Visits to the Park", weight: 5, minStat: 5, incrementBy: 2)
        oldestRide = Stat(category: "Oldest Attraction Experienced", weight: 3, minStat: 1995, incrementBy: -5)
        oldestRide.stat = 3000
        firstTimeExperiences = [String]()
        
        
        numberOfRollerCoasters = Stat(category: "Number of Roller Coasters", weight: 5, minStat: 3, incrementBy: 1)
        numberOfWaterRides = Stat(category: "Number of Water Rides", weight: 4, minStat: 3, incrementBy: 1)
        numberOfChildrensRides = Stat(category: "Number of Childrens Rides", weight: 4, minStat: 3, incrementBy: 1)
        numberOfFlatRides = Stat(category: "Number of Flat Rides", weight: 3, minStat: 2, incrementBy: 1)
        numberOfTransportRides = Stat(category: "Number of Transport Rides", weight: 3, minStat: 3, incrementBy: 1)
        numberOfDarkRides = Stat(category: "Number of Dark Rides", weight: 4, minStat: 3, incrementBy: 1)
        numberOfExploreRides = Stat(category: "Number of Explore Attractions", weight: 3, minStat: 2, incrementBy: 1)
        numberOfSpectaculars = Stat(category: "Number of Spectaculars", weight: 3, minStat: 2, incrementBy: 1)
        numberOfShows = Stat(category: "Number of Shows", weight: 3, minStat: 2, incrementBy: 1)
        numberOfFilms = Stat(category: "Number of Films", weight: 3, minStat: 2, incrementBy: 1)
        numberOfParades = Stat(category: "Number of Parades", weight: 3, minStat: 2, incrementBy: 1)
        numberOfPlayAreas = Stat(category: "Number of Play Areas", weight: 3, minStat: 2, incrementBy: 1)
        numberOfUpcharges = Stat(category: "Number of Upcharges", weight: 3, minStat: 2, incrementBy: 1)
    }
    
    func createArrayOfStat()->[Stat]{
        var arrayOfStats = [Stat]()
        
        maxHeight.calculateScore()
        arrayOfStats.append(maxHeight)
        maxSpeed.calculateScore()
        arrayOfStats.append(maxSpeed)
        totalTrackLength.calculateScore()
        arrayOfStats.append(totalTrackLength)
        numberOfAttractionsExperienced.calculateScore()
        arrayOfStats.append(numberOfAttractionsExperienced)
        uniqueAttractionCount.calculateScore()
        arrayOfStats.append(uniqueAttractionCount)
        attractionExperiencedMost.calculateScore()
        arrayOfStats.append(attractionExperiencedMost)
        scoreCardHighest.calculateScore()
        arrayOfStats.append(scoreCardHighest)
        numberOfVisitsToThePark.calculateScore()
        arrayOfStats.append(numberOfVisitsToThePark)
        if oldestRide.stat != 0{
            oldestRide.calculateScore()
            arrayOfStats.append(oldestRide)
        }
    
        numberOfRollerCoasters.calculateScore()
        arrayOfStats.append(numberOfRollerCoasters)
        numberOfWaterRides.calculateScore()
        arrayOfStats.append(numberOfWaterRides)
        numberOfChildrensRides.calculateScore()
        arrayOfStats.append(numberOfChildrensRides)
        numberOfFlatRides.calculateScore()
        arrayOfStats.append(numberOfFlatRides)
        numberOfTransportRides.calculateScore()
        arrayOfStats.append(numberOfTransportRides)
        numberOfDarkRides.calculateScore()
        arrayOfStats.append(numberOfDarkRides)
        numberOfExploreRides.calculateScore()
        arrayOfStats.append(numberOfExploreRides)
        numberOfSpectaculars.calculateScore()
        arrayOfStats.append(numberOfSpectaculars)
        numberOfShows.calculateScore()
        arrayOfStats.append(numberOfShows)
        numberOfFilms.calculateScore()
        arrayOfStats.append(numberOfFilms)
        numberOfParades.calculateScore()
        arrayOfStats.append(numberOfParades)
        numberOfPlayAreas.calculateScore()
        arrayOfStats.append(numberOfPlayAreas)
        numberOfUpcharges.calculateScore()
        arrayOfStats.append(numberOfUpcharges)
        
        arrayOfStats.sort { $0.calculatedScore > $1.calculatedScore }
        
        return arrayOfStats
    }
}
