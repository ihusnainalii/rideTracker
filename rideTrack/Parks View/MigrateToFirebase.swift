//
//  MigrateToFirebase.swift
//  rideTrack
//
//  Created by Mark Lawrence on 7/23/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class MigrateToFireBase {
    
    var savedParkList: [NSManagedObject] = []
    
    func migrate(arrayOfAllParks: [ParksModel]){
        
        let userID = Auth.auth().currentUser
        let id = userID?.uid
        let parksListRef = Database.database().reference(withPath: "all-parks-list/\(id!)")
        
        //Get ParkList data from CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "parkID", ascending: true)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ParkList")
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            savedParkList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch saved ParkList. \(error), \(error.userInfo)")
        }
        
        if savedParkList.count != 0{
            print("There is data stored in CoreData. Need to migrate")
            
            //Adding to all-parks-list
            for i in 0..<savedParkList.count{
                let parkID = savedParkList[i].value(forKey: "parkID") as! Int
                let favorite = false
                let incrementorEnabled = savedParkList[i].value(forKey: "incrementorEnabled") as! Bool
                let totalRides = savedParkList[i].value(forKey: "totalRides") as! Int
                let ridesRidden = savedParkList[i].value(forKey: "ridesRidden") as! Int
                let index = findIndexInAllParksList(parkID: parkID, arrayOfAllParks: arrayOfAllParks)
                let parkName = arrayOfAllParks[index].name
                let location = arrayOfAllParks[index].city
                
                let newParkModel = ParksList(parkID: parkID, favorite: favorite, ridesRidden: ridesRidden, totalRides: totalRides, incrementorEnabled: incrementorEnabled, name: parkName!, location: location!, showDefunct: false, numberOfCheckIns: 0, lastDayVisited: 0.0, checkedInToday: false)
                let newParkRef = parksListRef.child(String(newParkModel.parkID))
                newParkRef.setValue(newParkModel.toAnyObject())
                
                var savedAttractionsList: [NSManagedObject] = []
                //Setting up coredata for this park's attractions
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return }
                let managedContext = appDelegate.persistentContainer.viewContext
                let sortDescriptor = NSSortDescriptor(key: "parkID", ascending: true)
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RideTrack")
                fetchRequest.sortDescriptors = [sortDescriptor]
                do {
                    savedAttractionsList = try managedContext.fetch(fetchRequest)
                } catch let error as NSError {
                    print("Could not fetch saved ParkList. \(error), \(error.userInfo)")
                }
                print("Before loop parkID \(parkID)")
                for j in 0..<savedAttractionsList.count{
                    let attractionsParkID = savedAttractionsList[j].value(forKey: "parkID") as! Int
                    if attractionsParkID == parkID{
                        let rideID = savedAttractionsList[j].value(forKey: "rideID") as! Int
                        let numberOfTimesRidden = savedAttractionsList[j].value(forKey: "numberOfTimesRidden") as! Int
                        let firstRideDate = savedAttractionsList[j].value(forKey: "firstRideDate") as! Date
                        let lastRideDate = savedAttractionsList[j].value(forKey: "lastRideDate") as! Date
                        
                        let attractionsListRef = Database.database().reference(withPath: "attractions-list/\(id!)/\(parkID)")
                        print("adding ride ID \(rideID) to park ID \(parkID)")
                        
                        let newAttractionModel = AttractionList(rideID: rideID, numberOfTimesRidden: numberOfTimesRidden, firstRideDate: firstRideDate.timeIntervalSince1970, lastRideDate: lastRideDate.timeIntervalSince1970)
                        let newAttractionListRed = attractionsListRef.child(String(newAttractionModel.rideID))
                        newAttractionListRed.setValue(newAttractionModel.toAnyObject())
                    }
                }
                print("After loop parkID \(parkID)")
                deletePark(parkID: parkID)
            }
            
            //            //Deleting data from core data
            //            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ParkList")
            //            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            //            do {
            //                try managedObjectContext.executeRequest(batchDeleteRequest)
            //
            //            } catch {
            //                print("can not delete ")
            //            }
            
            
            
        }
        else{
            print("Already migrated")
        }
        
    }
    
    func deletePark(parkID: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RideTrack")
        fetchRequest.predicate = NSPredicate(format: "parkID = %@", "\(parkID)")
        
        do {
            let fetchedResults =  try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
            for entity in fetchedResults! {
                managedContext.delete(entity)
                do {
                    try managedContext.save()
                } catch {
                    // Do something... fatalerror
                }
            }
        } catch _ {
            print("Could not delete")
        }
        
        let parkFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ParkList")
        parkFetchRequest.predicate = NSPredicate(format: "parkID = %@", "\(parkID)")
        
        do {
            let fetchedResults =  try managedContext.fetch(parkFetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
            for entity in fetchedResults! {
                managedContext.delete(entity)
                print("Deleted parkList \(parkID)")
                do {
                    try managedContext.save()
                } catch {
                    // Do something... fatalerror
                }
            }
        }
        catch _ {
            print("Could not delete")
        }
        
    }
    
    func findIndexInAllParksList(parkID:Int, arrayOfAllParks: [ParksModel]) -> Int{
        var allParksIndex = 0
        for i in 0..<arrayOfAllParks.count{
            if arrayOfAllParks[i].parkID == parkID{
                allParksIndex = i
                break
            }
        }
        return allParksIndex
    }
    
}
