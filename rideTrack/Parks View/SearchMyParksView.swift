//
//  SearchMyParksView.swift
//  rideTrack
//
//  Created by Mark Lawrence on 7/7/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SearchMyParks{
    
    var firstEntry = true
    var park: ParksList!
    var allParksTableViewAlpha = 1.0
    var favoritesTableViewAlpha = 1.0
    
    func animateIntoSearchView(parksView: ViewController){
        allParksTableViewAlpha = Double(parksView.allParksTableView.alpha)
        favoritesTableViewAlpha = Double(parksView.favoritesTableView.alpha)
        
        parksView.allParksExpandButton.isHidden = true
        parksView.tapExpandAllParksView.isEnabled = false
        parksView.savedMyParksForSearch = parksView.allParksList
        parksView.favoritesViewHeightBeforeAnimating = parksView.favoritesViewHeightConstrant.constant
        parksView.favoritesViewHeightConstrant.constant = 5.0
        parksView.searchParksTextField.text = ""
        let allParksBottomLocation = parksView.allParksView.frame.maxY
        parksView.allParksBottomConstrant.constant = -(parksView.screenSize.height - allParksBottomLocation - 12)
        parksView.isSearchingMyParks = true
        print(allParksBottomLocation)
        UIView.animate(withDuration: 0.4, animations: ({
            parksView.view.layoutIfNeeded()
            parksView.favoritesView.alpha = 0.0
            parksView.myParksLabel.alpha = 0.0
            parksView.searchParksTextField.alpha = 1.0
            parksView.settingsButton.alpha = 0.0
            parksView.searchParkView.alpha = 0.0
            parksView.addParkButton.alpha = 0.0
            parksView.allParksTableView.alpha = 1.0
        }))
        if parksView.allParksList.count != 0{
            parksView.allParksTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
        }
        parksView.searchParksTextField.becomeFirstResponder()
        parksView.parksListRef.removeAllObservers()
    }
    
    func animateOutOfParkSearch(parksView: ViewController){
        print("animating out of park search")
        print("PRINTING OUT INSTRUCTION ALPHA \(parksView.favoritesInstructions.alpha)")
        parksView.allParksExpandButton.isHidden = false
        parksView.tapExpandAllParksView.isEnabled = true
        parksView.isSearchingMyParks = false
        parksView.favoritesViewHeightConstrant.constant = parksView.favoritesViewHeightBeforeAnimating
        parksView.favoitesHeight = parksView.favoritesViewHeightBeforeAnimating
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
            parksView.allParksTableView.alpha = CGFloat(self.allParksTableViewAlpha)
            parksView.favoritesTableView.alpha = CGFloat(self.favoritesTableViewAlpha)
        }))
        parksView.searchParkView.isHidden = false
        parksView.searchParksTextField.resignFirstResponder()
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: parksView.allParksBottomInsetValue, right: 0)
        parksView.allParksTableView.contentInset = insets
        parksView.allParksTableView.reloadData()
        
//        if parksView.firstItemsToFavorites{
//            parksView.favoritesViewHeightConstrant.constant = parksView.favoitesHeight
//            UIView.animate(withDuration: 0.6, animations: {
//                parksView.favoritesTableView.alpha = CGFloat(self.favoritesTableViewAlpha)
//                parksView.view.layoutIfNeeded()
//            })
//        }
        
        parksView.parksListRef.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
            var newParks: [ParksList] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let parkItem = ParksList(snapshot: snapshot) {
                    newParks.append(parkItem)
                }
            }
            print("Gettings all-parks-list")
            parksView.allParksList = newParks
            parksView.allParksTableView.reloadData()
            parksView.configureAllParksView()
        })
        
        parksView.firstItemsToFavorites = false
    }
    
    
    func updateSearchResults(parksView: ViewController){
        if parksView.searchParksTextField.text == ""{
            parksView.allParksList = parksView.savedMyParksForSearch
        }
        else{
            parksView.allParksList.removeAll()
            var searchedString = parksView.searchParksTextField.text!.replacingOccurrences(of: "’", with: "'", options: .literal, range: nil)
            if searchedString.last == " "{
                searchedString.removeLast()
            }

            for i in 0..<parksView.savedMyParksForSearch.count {
                park = parksView.savedMyParksForSearch[i]
                firstEntry = true
                if (park.name.lowercased().range(of: searchedString.lowercased()) != nil){
                    parksView.allParksList.append(park)
                    firstEntry = false
                }
                
                //Not allow you to add duplicates
                if (park.location.lowercased().range(of: searchedString.lowercased()) != nil) && firstEntry{
                    parksView.allParksList.append(park)
                    firstEntry = false
                }
            }
        }
        parksView.allParksTableView.reloadData()

    }
    
}
