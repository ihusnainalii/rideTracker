//
//  ScoreCard.swift
//  rideTrack
//
//  Created by Mark Lawrence on 6/11/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class ScoreCardModel: NSObject {
    
    var score: Int!
    var date: Date!
    var rideID: Int!
    
    override init() {
    }
    
    init(score: Int, date: Date, rideID: Int){
        self.date = date
        self.score = score
        self.rideID = rideID
    }
    
}
