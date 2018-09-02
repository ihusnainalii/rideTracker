//
//  TopLists.swift
//  rideTrack
//
//  Created by Mark Lawrence on 9/2/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import Foundation

class TopLists: NSObject {
    var name: String!
    var number: Int!
    
    override init() {
    }
    
    init(name: String, number: Int) {
        self.name = name
        self.number = number
    }
}
