//
//  ParkMap.swift
//  rideTrack
//
//  Created by Mark Lawrence on 8/14/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import MapKit

class ParkMap: NSObject, MKAnnotation {
    let parkName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(parkName: String, longitude: Double, latitude: Double) {
        self.parkName = parkName
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        super.init()
    }
    
    var subtitle: String? {
        return parkName
    }
}
