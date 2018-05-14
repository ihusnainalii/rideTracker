//
//  UserAttractionProviderer.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/23/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//


import UIKit
import CoreData
import Foundation

class UserAttractionProvider: NSObject {
    //Should these iclude just ID numbers or the actual AttractionsModel and ParksModel classes?

    //Each time a new park is added, a new entry gets added to the 2D array that contains all rides in the park. When a ride is checked, the bool becomes true, else, default to false
    var userAttractions: [NSManagedObject] = []
    var rideID: Int!
    var parkID: Int!
    
    func getContext() -> NSManagedObjectContext {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return managedContext
    }
    
    override init() {
    }
    
    init(rideID: Int, parkID: Int) {
        self.rideID = rideID
        self.parkID = parkID
        
    }
    
    init(parkID: Int) {
        self.parkID = parkID
    }
    /**
     * Insert a new record into the database using NSManagedObjectContext
     *
     * @param rideID the ride ID inserted
     * @param parkID the park ID to be inserted
     * @return noteId the unique Note Id
 
    func insert(rideID: Int, parkID: Int) -> String {
        
        // Get NSManagedObjectContext
        let managedContext = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "RideTrack",
                                                in: managedContext)!
        
        let newPark = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // Set the Note Id
        let newParkID = NSUUID().uuidString
        newPark.setValue(NSDate(), forKeyPath: "creationDate")
        print("New park being created: \(newParkID)")
        
      //  UserAttraction.setValue(newNoteId, forKeyPath: "noteId")
        newPark.setValue(rideID, forKeyPath: "rideID")
        newPark.setValue(parkID, forKeyPath: "parkID")
        let Attraction: RideTrack = RideTrack ()
        
        do {
            try managedContext.save()
            userAttractions.append(newPark)
        } catch let error as NSError {
            print("Could not save note. \(error), \(error.userInfo)")
        }
        print("New park Saved : \(newParkID)")
        return newParkID
    }
    
    /**
     * Update an existing Note using NSManagedObjectContext
     * @param noteId the unique identifier for this note
     * @param noteTitle the note title to be updated
     * @param noteContent the note content to be updated
     */
    func update(rideID: String, parkID: String)  {
        
        // Get NSManagedObjectContext
        let managedContext = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "UserAttraction",
                                                in: managedContext)!
        
        let myAttraction = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        myAttraction.setValue(rideID, forKeyPath: "rideID")
        myAttraction.setValue(parkID, forKeyPath: "parkID")
        myAttraction.setValue(NSDate(), forKeyPath: "updatedDate")
        
        do {
            try managedContext.save()
            userAttractions.append(myAttraction)
        } catch let error as NSError {
            print("Could not save note. \(error), \(error.userInfo)")
        }
       // print("Updated note with NoteId: \(noteId)")
    }
    
    /**
     * Delete note using NSManagedObjectContext and NSManagedObject
     * @param managedObjectContext the managed context for the note to be deleted
     * @param managedObj the core data managed object for note to be deleted
     * @param noteId the noteId to be delete
     */
    public func delete(managedObjectContext: NSManagedObjectContext, managedObj: NSManagedObject)  {
        let context = managedObjectContext
        context.delete(managedObj)
        
        do {
            try context.save()
            //print("Deleted local NoteId: \(noteId)")
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved local delete error \(nserror), \(nserror.userInfo)")
        }
    }
 **/
}


