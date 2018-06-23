//
//  ParksCoreData.swift
//  rideTrack
//
//  Created by Mark Lawrence on 6/21/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class ParkCoreData{
    
    
    func saveFavoritesChange(modifyedPark: ParksModel, add: Bool){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ParkList")
        fetchRequest.predicate = NSPredicate(format: "parkID = %@", "\(modifyedPark.parkID!)")
        do {
            let fetchedResults =  try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
            
            for entity in fetchedResults! {
                print("FOUND PARK ID \(modifyedPark.parkID!)")
                if add{
                    print("adding to favorites")
                    entity.setValue(true, forKey: "favorite")
                }
                else{
                    print("removing from favorites")
                    entity.setValue(false, forKey: "favorite")
                }
                try! managedContext.save()
            }
        }
        catch _ {
            print("Could not save favorite")
        }
    }
    
    func save(parkID: Int, rideID: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "RideTrack",
                                                in: managedContext)!
        
        let newPark = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
        
        newPark.setValue(parkID, forKeyPath: "parkID")
        newPark.setValue(rideID, forKeyPath: "rideID")
        newPark.setValue(0, forKey: "numberOfTimesRidden")
        newPark.setValue(Date(), forKey: "firstRideDate")
        newPark.setValue(Date(), forKey: "lastRideDate")
        
        print("Just saved new park: ", parkID)
        do {
            try managedContext.save()
            //userAttractions.append(newPark)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
                print("Deleted park \(parkID)")
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
    
    
    func updatingTotalRideCount(parkID: Int, totalRideCount: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ParkList")
        fetchRequest.predicate = NSPredicate(format: "parkID = %@", "\(parkID)")
        do
        {
            let fetchedResults =  try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
            
            for entity in fetchedResults! {
                print("updating total ride count")
                entity.setValue(totalRideCount, forKey: "totalRides")
                try! managedContext.save()
            }
        } catch _ {
            print("Could not save rideCount")
        }
    
    }
    
    
    func saveNewItemToParkList(parkID: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ParkList", in: managedContext)!
        let newPark = NSManagedObject(entity: entity, insertInto: managedContext)
        
        newPark.setValue(parkID, forKeyPath: "parkID")
        newPark.setValue(false, forKeyPath: "favorite")
        newPark.setValue(0, forKey: "ridesRidden")
        newPark.setValue(0, forKey: "totalRides")
        do {
            try managedContext.save()
            print("Just added park to ParkList: ",parkID)
            
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
}
