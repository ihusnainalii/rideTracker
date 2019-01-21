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
    
    override init() {
    }
    
    init(category: String, weight: Int, minStat: Int, incrementBy: Int) {
        self.category = category
        self.weight = weight
        self.minStat = minStat
        self.incrementBy = incrementBy
        
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
