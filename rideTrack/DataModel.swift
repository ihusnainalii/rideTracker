//
//  DataModel.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/14/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit

protocol DataModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class DataModel: NSObject, URLSessionDataDelegate {

    weak var delegate: DataModelProtocol!
    var data = Data()
    
    
    func downloadData(urlPath: String, dataBase: String) {
        let url: URL = URL(string: urlPath)!
        let defaultSessions = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSessions.dataTask(with: url) { (data, response, error)
            in
            if dataBase == "upload"{
                print ("uplaod")
                
            }
            else {
            if error != nil{
                print("Failed to download data")
            }
            else{
                print("Data Downloaded")
                //Able to download data from database, now need to parse it
                self.parseJSON(data!, dataBase: dataBase)
            }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data:Data, dataBase: String) {
        var jsonResult = NSArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
        }
    
        var jsonElement = NSDictionary()
        let dataBaseData = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            
            //There are currently two databases, parks and attractions
            if dataBase == "parks"{
                let park = ParksModel()
                park.parkID = Int(jsonElement["id"] as! String)!
                park.name = jsonElement["Name"] as! String
                park.location = jsonElement["Location"] as! String
                //park.longitude = Double(jsonElement["longitude"] as! String)!
                //park.latitude = Double(jsonElement["latitude"] as! String)!
                
                dataBaseData.add(park)
                
            }
            if dataBase == "attractions"{
                let attraction = AttractionsModel()
                attraction.attractionID = Int (jsonElement["rideID"] as! String)
                attraction.name = jsonElement["Name"] as? String
                attraction.parkID = Int (jsonElement["ParkID"] as! String)
                attraction.active = jsonElement["active"] as? Bool
                attraction.isCheck = false
                dataBaseData.add(attraction)
            }
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsDownloaded(items: dataBaseData)
        })
    }
}
