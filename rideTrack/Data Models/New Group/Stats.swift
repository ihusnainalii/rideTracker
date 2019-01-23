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
    var checkIns: Int!
    
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
    var parades: Int!
    
    var rollerCoasterExperience: Int!
    var waterExperience: Int!
    var childrensRideExperience: Int!
    var flatRideExperience: Int!
    var transportExperience: Int!
    var darkRidesExperience: Int!
    var exploreExperience: Int!
    var spectacularExperince: Int!
    var showExperience: Int!
    var filmsExperience: Int!
    var playAreaExperience: Int!
    var upchargeExperience: Int!
    var paradesExperience: Int!
    
    //Future stats to add:
    //Park visited most frequently (top parks visited, based on number of times visited)
            //To be calculated by adding a lastTimeVisited and numberOfTimesVisited to ParksList
    //Number of park visits
    
    
    init(attractions: Int, extinctAttracions: Int, activeAttractions: Int, parks: Int, parksCompleted: Int, experiences: Int, countries: Int, rollerCoasters: Int, waterRides: Int, childrensRides: Int, flatRides: Int, transportRides: Int, darkRides: Int, exploreRides: Int, spectaculars: Int, shows: Int, films: Int, playAreas: Int, upchargeRides: Int, rollerCoasterExperience: Int, waterExperience: Int, childrensRideExperience: Int, flatRideExperience: Int, transportExperience: Int, darkRidesExperience: Int, exploreExperience: Int, spectacularExperince: Int, showExperience: Int, filmsExperience: Int, playAreaExperience: Int, upchargeExperience: Int, paradesExperience: Int, parades: Int, checkIns: Int, key: String = "") {
        self.ref = nil
        self.key = key
        
        self.attractions = attractions
        self.extinctAttracions = extinctAttracions
        self.activeAttractions = activeAttractions
        self.parks = parks
        self.parksCompleted = parksCompleted
        self.experiences = experiences
        self.countries = countries
        self.checkIns = checkIns
        
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
        self.parades = parades
        
        self.rollerCoasterExperience = rollerCoasterExperience
        self.waterExperience = waterExperience
        self.childrensRideExperience = childrensRideExperience
        self.flatRideExperience = flatRideExperience
        self.transportExperience = transportExperience
        self.darkRidesExperience = darkRidesExperience
        self.exploreExperience = exploreExperience
        self.spectacularExperince = spectacularExperince
        self.showExperience = showExperience
        self.filmsExperience = filmsExperience
        self.playAreaExperience = playAreaExperience
        self.upchargeExperience = upchargeExperience
        self.paradesExperience = paradesExperience
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
        var rollerCoasterExperience = 0
        if let rollerCoasterExperienceCheck = value["rollerCoasterExperience"] as? Int{
            rollerCoasterExperience = rollerCoasterExperienceCheck
        }
        var waterExperience = 0
        if let waterExperienceCheck = value["waterExperience"] as? Int{
            waterExperience = waterExperienceCheck
        }
        var childrensRideExperience = 0
        if let childrensRideExperienceCheck = value["childrensRideExperience"] as? Int{
            childrensRideExperience = childrensRideExperienceCheck
        }
        var flatRideExperience = 0
        if let flatRideExperienceCheck = value["flatRideExperience"] as? Int{
            flatRideExperience = flatRideExperienceCheck
        }
        var transportExperience = 0
        if let transportExperienceCheck = value["transportExperience"] as? Int{
            transportExperience = transportExperienceCheck
        }
        var darkRidesExperience = 0
        if let darkRidesCheck = value["darkRidesExperience"] as? Int{
            darkRidesExperience = darkRidesCheck
        }
        var exploreExperience = 0
        if let exploreRidesCheck = value["exploreExperience"] as? Int{
            exploreExperience = exploreRidesCheck
        }
        var spectacularExperince = 0
        if let spectacularExperinceCheck = value["spectacularExperince"] as? Int{
            spectacularExperince = spectacularExperinceCheck
        }
        var showExperience = 0
        if let showExperienceCheck = value["showExperience"] as? Int{
            showExperience = showExperienceCheck
        }
        var filmsExperience = 0
        if let filmsExperienceCheck = value["filmsExperience"] as? Int{
            filmsExperience = filmsExperienceCheck
        }
        var playAreaExperience = 0
        if let playAreaExperienceCheck = value["playAreaExperience"] as? Int{
            playAreaExperience = playAreaExperienceCheck
        }
        var upchargeExperience = 0
        if let upchargeExperienceCheck = value["upchargeExperience"] as? Int{
            upchargeExperience = upchargeExperienceCheck
        }
        var paradesExperience = 0
        if let paradesExperienceCheck = value["paradesExperience"] as? Int{
            paradesExperience = paradesExperienceCheck
        }
        var parades = 0
        if let paradesCheck = value["parades"] as? Int{
            parades = paradesCheck
        }
        var checkIns = 0
        if let checkInsCheck = value["checkIns"] as? Int{
            checkIns = checkInsCheck
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
        self.checkIns = checkIns
        
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
        self.parades = parades
        
        self.rollerCoasterExperience = rollerCoasterExperience
        self.waterExperience = waterExperience
        self.childrensRideExperience = childrensRideExperience
        self.flatRideExperience = flatRideExperience
        self.transportExperience = transportExperience
        self.darkRidesExperience = darkRidesExperience
        self.exploreExperience = exploreExperience
        self.spectacularExperince = spectacularExperince
        self.showExperience = showExperience
        self.filmsExperience = filmsExperience
        self.playAreaExperience = playAreaExperience
        self.upchargeExperience = upchargeExperience
        self.paradesExperience = paradesExperience
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
            "checkIns": checkIns,
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
            "upchargeRides": upchargeRides,
            "parades": parades,
            
            "rollerCoasterExperience": rollerCoasterExperience,
            "waterExperience": waterExperience,
            "childrensRideExperience": childrensRideExperience,
            "flatRideExperience": flatRideExperience,
            "transportExperience": transportExperience,
            "darkRidesExperience": darkRidesExperience,
            "exploreExperience": exploreExperience,
            "spectacularExperince": spectacularExperince,
            "showExperience": showExperience,
            "filmsExperience": filmsExperience,
            "playAreaExperience": playAreaExperience,
            "upchargeExperience": upchargeExperience,
            "paradesExperience": paradesExperience
        ]
    }
}
