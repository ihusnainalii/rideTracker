//
//  Stats.swift
//  rideTrack
//
//  Created by Mark Lawrence on 8/15/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct Stats {
    
    let ref: DatabaseReference?
    let key: String
    
    var attractions: Int!
    var extinctAttracions: Int!
    var activeAttractions: Int!
    var parks: Int!
    var parksCompleted: Int!
    var experiences: Int!
    var countries: Int!
    
    var rollerCoasters: Int!
    var waterRides: Int!
    var childrensRides: Int!
    var flatRides: Int!
    var transportRides: Int!
    var darkRides: Int!
    var exploreRides: Int!
    var spectaculars: Int!
    var shows: Int!
    var films: Int!
    var playAreas: Int!
    var upchargeRides: Int!
    
    //Future stats to add:
    //Park visited most frequently (top parks visited, based on number of times visited)
            //To be calculated by adding a lastTimeVisited and numberOfTimesVisited to ParksList
    //Number of park visits
    
    
    init(attractions: Int, extinctAttracions: Int, activeAttractions: Int, parks: Int, parksCompleted: Int, experiences: Int, countries: Int, rollerCoasters: Int, waterRides: Int, childrensRides: Int, flatRides: Int, transportRides: Int, darkRides: Int, exploreRides: Int, spectaculars: Int, shows: Int, films: Int, playAreas: Int, upchargeRides: Int , key: String = "") {
        self.ref = nil
        self.key = key
        
        self.attractions = attractions
        self.extinctAttracions = extinctAttracions
        self.activeAttractions = activeAttractions
        self.parks = parks
        self.parksCompleted = parksCompleted
        self.experiences = experiences
        self.countries = countries
        
        self.rollerCoasters = rollerCoasters
        self.waterRides = waterRides
        self.childrensRides = childrensRides
        self.flatRides = flatRides
        self.transportRides = transportRides
        self.darkRides = darkRides
        self.exploreRides = exploreRides
        self.spectaculars = spectaculars
        self.shows = shows
        self.films = films
        self.playAreas = playAreas
        self.upchargeRides = upchargeRides
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let attractions = value["attractions"] as? Int,
            let extinctAttracions = value["extinctAttracions"] as? Int,
            let activeAttractions = value["activeAttractions"] as? Int,
            let parks = value["parks"] as? Int,
            let parksCompleted = value["parksCompleted"] as? Int,
            let experiences = value["experiences"] as? Int,
            let countries = value["countries"] as? Int,
            
            let rollerCoasters = value["rollerCoasters"] as? Int,
            let waterRides = value["waterRides"] as? Int,
            let childrensRides = value["childrensRides"] as? Int,
            let flatRides = value["flatRides"] as? Int,
            let transportRides = value["transportRides"] as? Int,
            let darkRides = value["darkRides"] as? Int,
            let exploreRides = value["exploreRides"] as? Int,
            let spectaculars = value["spectaculars"] as? Int,
            let shows = value["shows"] as? Int,
            let films = value["films"] as? Int,
            let playAreas = value["playAreas"] as? Int,
            let upchargeRides = value["upchargeRides"] as? Int else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.attractions = attractions
        self.extinctAttracions = extinctAttracions
        self.activeAttractions = activeAttractions
        self.parks = parks
        self.parksCompleted = parksCompleted
        self.experiences = experiences
        self.countries = countries
        
        self.rollerCoasters = rollerCoasters
        self.waterRides = waterRides
        self.childrensRides = childrensRides
        self.flatRides = flatRides
        self.transportRides = transportRides
        self.darkRides = darkRides
        self.exploreRides = exploreRides
        self.spectaculars = spectaculars
        self.shows = shows
        self.films = films
        self.playAreas = playAreas
        self.upchargeRides = upchargeRides
    }
    
    func toAnyObject() -> Any {
        return [
            "attractions": attractions,
            "extinctAttracions": extinctAttracions,
            "activeAttractions": activeAttractions,
            "parks": parks,
            "parksCompleted": parksCompleted,
            "experiences": experiences,
            "countries": countries,
            "rollerCoasters": rollerCoasters,
            "waterRides": waterRides,
            "childrensRides": childrensRides,
            "flatRides": flatRides,
            "transportRides": transportRides,
            "darkRides": darkRides,
            "exploreRides": exploreRides,
            "spectaculars": spectaculars,
            "shows": shows,
            "films": films,
            "playAreas": playAreas,
            "upchargeRides": upchargeRides
        ]
    }
}
