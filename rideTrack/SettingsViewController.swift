//
//  SettingsViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 5/24/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class SettingsViewController: UIViewController {
    var usersParkList: NSMutableArray = NSMutableArray()
    var downloadIncrementor = 0
   // var showExtinct : Int?
    var showExtinct = 0
    var resetPressed : Int?

    @IBOutlet weak var showExtinctSwitch: UISwitch!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        resetPressed = 0
        print("Show extinct is ", showExtinct)
        if showExtinct == 0{
            showExtinctSwitch.isOn = false
        }
        else{
            showExtinctSwitch.isOn = true
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func resetData(_ sender: Any) {
        deleteRecords()
        usersParkList = []
        downloadIncrementor = 0
        resetPressed = 1
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deleteRecords() -> Void {
        let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RideTrack")
        
        let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [RideTrack]
        
        for object in resultData {
            moc.delete(object)
        }
        
        do {
            try moc.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
        @IBAction func showExtinct(_ sender: Any) {
        if (showExtinctSwitch.isOn){
            showExtinct = 1
            print("Showing extinct rides")
        }
        else{
            showExtinct = 0
            print("Hiding extinct rides")
    }
    UserDefaults.standard.set(showExtinct, forKey: "showExtinct")

}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toParkList"{
            let listVC = segue.destination as! ViewController
            listVC.showExtinct = showExtinct
        }
    }
}
