//
//  NeverCleariew.swift
//  rideTrack
//
//  Created by Mark Lawrence on 6/29/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import Foundation
import UIKit

//This makes sure that the UIViews in the table view cell do not become transparent when selecting a cell
class NeverClearView: UIView {
    override var backgroundColor: UIColor? {
        didSet {
            if backgroundColor != nil && backgroundColor!.cgColor.alpha == 0 {
                backgroundColor = oldValue
            }
        }
    }
}
