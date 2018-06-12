//
//  ScoreCard.swift
//  rideTrack
//
//  Created by Mark Lawrence on 6/11/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class ScoreCard: NSObject {
    
    var score: Int!
    var date: Date!
    
    override init() {
    }
    
    init(score: Int, date: Date){
        self.date = date
        self.score = score
    }
    
}
