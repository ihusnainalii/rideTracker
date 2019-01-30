//
//  ConfigureSmallerLayout.swift
//  rideTrack
//
//  Created by Mark Lawrence on 7/3/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import Foundation
import UIKit

class ConfigureSmallerLayout{
    
    
    
    func favoriteCellLayout(favoriteCell: FavoritesTableViewCell){
        favoriteCell.parkNameLabel.font = favoriteCell.parkNameLabel.font.withSize(17.0)
        favoriteCell.locationLabel.font = favoriteCell.locationLabel.font.withSize(12.0)
        favoriteCell.fractionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        favoriteCell.progressViewBackground.layer.cornerRadius = 8
        favoriteCell.progressViewBackgroundWidth.constant = 64.5
        favoriteCell.progressViewBackgroundHeight.constant = 25.8
        
    }
    
    func allParksCellLayout(allParksCell: AllParksTableViewCell){
        allParksCell.parkNameLabel.font = allParksCell.parkNameLabel.font.withSize(17.0)
        allParksCell.locationLabel.font = allParksCell.locationLabel.font.withSize(12.0)
        allParksCell.fractionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        allParksCell.fractionView.layer.cornerRadius = 8
        allParksCell.fractionViewWidth.constant = 64.5
        allParksCell.fractionViewHeight.constant = 25.8
    }
   
    func listselectParkCellLayout(selectParkCell: SelectParkTableViewCell){
        selectParkCell.parkNameLabel.font = selectParkCell.parkNameLabel.font.withSize(17.0)
        selectParkCell.locationLabel.font = selectParkCell.locationLabel.font.withSize(12.0)
    }
   
    func listselectAttractionCellLayout(selectAttractionCell: SelectAttractionTableViewCell){
        selectAttractionCell.attractionNameLabel.font = selectAttractionCell.attractionNameLabel.font.withSize(17.0)
        selectAttractionCell.rideTypeLabel.font = selectAttractionCell.rideTypeLabel.font.withSize(12.0)
    }
    
    func configureParksView(parksView: ViewController){
        parksView.favoritesHeightMax = 140.0
        parksView.expandParksView.setFavoriteExpandHeight(variable: 163)
        parksView.favoritesViewHeightConstrant.constant = 140.0
        parksView.addParkHeightConstrant.constant = 55
        //parksView.navBarHeightConstants.constant = 55
        parksView.settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        parksView.doneSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        parksView.doneSearchWidthConstrant.constant = 72
        parksView.doneSearchHeightConstrant.constant = 24
        parksView.favoritesLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        parksView.myParksLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        parksView.currentLocationParkNameLabel.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        parksView.currentLocationLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        parksView.viewAttractionLocationButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        parksView.centerLogoWidthConstrant.constant = 60
    }
    
    func attractionsViewLayout(attractionsView: AttractionsViewController){
        attractionsView.parkLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        attractionsView.NumCompleteLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        attractionsView.extinctText.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        attractionsView.suggestButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    func parkInfoViewLayout(parkInfoView: ParkInfoViewController){
        
    }
    func settingsViewLayout(settingsView: SettingsViewController){
        settingsView.iconWidth.constant = 60
        settingsView.iconHeight.constant = 60
        settingsView.showCameraLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        settingsView.simulateLocationLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        settingsView.showCameraViewHeight.constant = 40
        settingsView.simulateLocViewHieght.constant = 40
        settingsView.logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        settingsView.userNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        settingsView.FAQTopConst.constant = 4
        settingsView.navBarTopConst.constant = 40
        settingsView.doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        settingsView.doneButtonWidth.constant = 55
        settingsView.doneButtonConstBottom.constant = 10
    }
    
    func attractionCellLayout(attractionsCell: AttractionsTableViewCell){
        attractionsCell.rideName.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        attractionsCell.rideTypeLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
    }

}
