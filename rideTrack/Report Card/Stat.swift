//
//  Stat.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/20/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import UIKit

class Stat: NSObject {
    var stat: Int!
    var rideName: String!
    var category: String!
    
    var weight: Int!
    var minStat: Int!
    var calculatedScore: Int!
    var incrementBy: Int!
    
    var displayType: BoxType!
    var preferedBoxSize: PreferedSize!
    
    override init() {
    }
    
    init(category: String, weight: Int, minStat: Int, incrementBy: Int, displayType: BoxType, preferedBoxSize: PreferedSize) {
        self.category = category
        self.weight = weight
        self.minStat = minStat
        self.incrementBy = incrementBy
        self.displayType = displayType
        self.preferedBoxSize = preferedBoxSize
        
        stat = 0
        calculatedScore = 0
        rideName = ""
    }
    
    func calculateScore(){
        calculatedScore = Int((Double(stat-minStat)/Double(incrementBy))*Double(weight))

    }
    
    func setStat(stat: Int, rideName: String){
        self.stat = stat
        self.rideName = rideName
    }
    
}

enum BoxType {
    case statLabel
    case topRideList
    case statAttractionLabel
}

enum PreferedSize{
    case quarter
    case half
    case threeQuarters
}
