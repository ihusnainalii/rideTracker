//
//  SearchMyParksView.swift
//  rideTrack
//
//  Created by Mark Lawrence on 7/7/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import Foundation
import UIKit

class SearchMyParks{
    
    var firstEntry = true
    var park = ParksModel()
    
    func animateIntoSearchView(parksView: ViewController){
        parksView.isSearchingMyParks = true
        parksView.savedMyParksForSearch = parksView.allParksList
        parksView.favoritesViewHeightBeforeAnimating = parksView.favoritesViewHeightConstrant.constant
        parksView.favoritesViewHeightConstrant.constant = 5.0
        parksView.searchParksTextField.text = ""
        let allParksBottomLocation = parksView.allParksView.frame.maxY
        parksView.allParksBottomConstrant.constant = -(parksView.screenSize.height - allParksBottomLocation - 12)
        
        print(allParksBottomLocation)
        UIView.animate(withDuration: 0.4, animations: ({
            parksView.view.layoutIfNeeded()
            parksView.favoritesView.alpha = 0.0
            parksView.myParksLabel.alpha = 0.0
            parksView.searchParksTextField.alpha = 1.0
            parksView.settingsButton.alpha = 0.0
            parksView.searchParkView.alpha = 0.0
            parksView.addParkButton.alpha = 0.0
        }))
        
        parksView.searchParksTextField.becomeFirstResponder()
    }
    
    func animateOutOfParkSearch(parksView: ViewController){
        print("animating out of park search")
        parksView.isSearchingMyParks = false
        parksView.favoritesViewHeightConstrant.constant = parksView.favoritesViewHeightBeforeAnimating
        parksView.allParksBottomConstrant.constant = 5
        parksView.allParksList = parksView.savedMyParksForSearch
        UIView.animate(withDuration: 0.4, animations: ({
            parksView.view.layoutIfNeeded()
            parksView.favoritesView.alpha = 1.0
            parksView.myParksLabel.alpha = 1.0
            parksView.searchParksTextField.alpha = 0.0
            parksView.settingsButton.alpha = 1.0
            parksView.searchParkView.alpha = 1.0
            parksView.addParkButton.alpha = 1.0
        }))
        parksView.searchParkView.isHidden = false
        parksView.searchParksTextField.resignFirstResponder()
        parksView.allParksTableView.reloadData()
    }
    
    func updateSearchResults(parksView: ViewController){
        if parksView.searchParksTextField.text == ""{

            parksView.allParksList = parksView.savedMyParksForSearch
        }
        else{
            parksView.allParksList.removeAll()
            for i in 0..<parksView.savedMyParksForSearch.count {
                park = parksView.savedMyParksForSearch[i]
                firstEntry = true
                if (park.name.lowercased().range(of: parksView.searchParksTextField.text!.lowercased()) != nil){
                    parksView.allParksList.append(park)
                    firstEntry = false
                }
                
                //Not allow you to add duplicates
                if (park.city.lowercased().range(of: parksView.searchParksTextField.text!.lowercased()) != nil) && firstEntry{
                    parksView.allParksList.append(park)
                    firstEntry = false
                }
                if (park.country.lowercased().range(of: parksView.searchParksTextField.text!.lowercased()) != nil) && firstEntry{
                    parksView.allParksList.append(park)
                    firstEntry = false
                }
            }
        }
        parksView.allParksTableView.reloadData()

    }
    
}
