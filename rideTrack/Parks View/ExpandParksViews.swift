//
//  ExpandParksViews.swift
//  rideTrack
//
//  Created by Mark Lawrence on 7/31/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ExpandParksView{
    var favoriteExpandHeight:CGFloat = 175
    
    
    func expandOutAllParks(parksView: ViewController){
        parksView.favoitesHeight = 40.0
        parksView.favoritesViewHeightConstrant.constant = parksView.favoitesHeight
        UIView.animate(withDuration: 0.4, animations: ({
            parksView.view.layoutIfNeeded()
            //parksView.favoritesExpandButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            parksView.favoritesTableView.alpha = 0.0
            parksView.favoritesInstructions.alpha = 0.0
            parksView.allParksTableView.alpha = 1.0
            parksView.favoritesExpandButton.transform = CGAffineTransform(rotationAngle: -90 * CGFloat(3.14159/180))
            parksView.allParksExpandButton.transform = CGAffineTransform(rotationAngle: 0 * CGFloat(3.14159/180))
        }))
        parksView.favoritesIsExpanded = false
        parksView.allParksIsExpanded = true
        parksView.allParksIsVisible = true
        parksView.favoritesViewIsVisible = false
    }
    
    func resetToDefault(parksView: ViewController){
        
        parksView.favoitesHeight = parksView.favoritesHeightMax
        parksView.favoritesViewHeightConstrant.constant = parksView.favoitesHeight
        var favoritesTableViewAlpha = 1.0
        var allParksTableViewAlpha = 1.0
        if parksView.favoiteParkList.count == 0{
            parksView.favoritesViewHeightConstrant.constant = 70
            favoritesTableViewAlpha = 0.0
        }
        if parksView.allParksList.count == 0{
            allParksTableViewAlpha = 0.0
        }
        
        UIView.animate(withDuration: 0.4, animations: ({
            parksView.view.layoutIfNeeded()
            //parksView.favoritesExpandButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            parksView.favoritesTableView.alpha = CGFloat(favoritesTableViewAlpha)
            parksView.allParksTableView.alpha = CGFloat(allParksTableViewAlpha)
            parksView.favoritesInstructions.alpha = 1.0
            parksView.allParksInstructions.alpha = 1.0
            parksView.favoritesExpandButton.transform = CGAffineTransform(rotationAngle: -90 * CGFloat(3.14159/180))
            parksView.allParksExpandButton.transform = CGAffineTransform(rotationAngle: -90 * CGFloat(3.14159/180))
        }))
        parksView.favoritesIsExpanded = false
        parksView.allParksIsExpanded = false
        parksView.allParksIsVisible = true
        parksView.favoritesViewIsVisible = true
    }
    
    func expandFavoritesView(parksView: ViewController){
        let favoritesHeight = parksView.screenSize.height - favoriteExpandHeight
        parksView.favoitesHeight = favoritesHeight
        parksView.favoritesViewHeightConstrant.constant = parksView.favoitesHeight
        
        UIView.animate(withDuration: 0.4, animations: ({
            parksView.view.layoutIfNeeded()
            //parksView.favoritesExpandButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            parksView.allParksTableView.alpha = 0.0
            parksView.allParksInstructions.alpha = 0.0
            parksView.favoritesTableView.alpha = 1.0
            parksView.favoritesExpandButton.transform = CGAffineTransform(rotationAngle: 0 * CGFloat(3.14159/180))
            parksView.allParksExpandButton.transform = CGAffineTransform(rotationAngle: -90 * CGFloat(3.14159/180))

        }))
        parksView.favoritesIsExpanded = true
        parksView.allParksIsExpanded = false
        parksView.allParksIsVisible = false
        parksView.favoritesViewIsVisible = true
    }
    
    func setFavoriteExpandHeight(variable: CGFloat){
        favoriteExpandHeight = variable
    }
    
    
}

