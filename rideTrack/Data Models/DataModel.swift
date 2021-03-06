//
//  DataModel.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/14/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//
import UIKit

protocol DataModelProtocol: class {
    func itemsDownloaded(items: NSArray, returnPath: String)
}

class DataModel: NSObject, URLSessionDataDelegate {
    
    weak var delegate: DataModelProtocol!
    var data = Data()
    
    
    func downloadData(urlPath: String, dataBase: String, returnPath: String) {
        let encoded = urlPath.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        
        //        if let encoded = urlPath.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
        //            let url = URL(string: encoded)
        //        {
        //            print(url)
        //            print("We are here")
        //        }
        //
        
        let url: URL = URL(string: encoded!)!
        //let defaultSessions = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession.init(configuration: config)
        
        let task = session.dataTask(with: url) { (data, response, error)
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
                    //print(data!)
                    //Able to download data from database, now need to parse it
                    self.parseJSON(data!, dataBase: dataBase, returnPath: returnPath)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data:Data, dataBase: String, returnPath: String) {
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
                //Redo these as Bools, like in attractions DB
                park.parkID = Int(jsonElement["id"] as! String)!
                park.name = (jsonElement["Name"] as! String)
                park.city = (jsonElement["City"] as! String)
                park.country = (jsonElement["Country"] as! String)
                park.active = Int(jsonElement["Active"] as! String)!
                park.yearOpen = Int(jsonElement["YearOpen"] as! String)!
                park.yearClosed = Int(jsonElement["YearClosed"] as! String)!
                park.longitude = Double(jsonElement["Longitude"] as! String)!
                park.latitude = Double(jsonElement["Latitude"] as! String)!
                park.seasonal = Int(jsonElement["Active"] as! String)!
                park.perviousNames = (jsonElement["PreviousNames"] as! String)
                park.type = (jsonElement["Type"] as! String)
                
                dataBaseData.add(park)
                
            }
            if dataBase == "attractions"{
                let attraction = AttractionsModel()
                var tempName = ""
                var tempMan = ""
                tempName = jsonElement["Name"] as! String
                tempName = tempName.replacingOccurrences(of: "!A?", with: "&")
                attraction.name = tempName.replacingOccurrences(of: "_", with: " ")
                attraction.rideID = Int (jsonElement["RideID"] as! String)
                attraction.parkID = Int (jsonElement["ParkID"] as! String)
                attraction.rideType = Int (jsonElement["RideType"] as! String)
                attraction.yearOpen = Int (jsonElement["YearOpen"] as! String)
                attraction.yearClosed = Int (jsonElement["YearClosed"] as! String)
                attraction.active = Int (jsonElement["Active"] as! String)
                attraction.hasScoreCard = Int (jsonElement["ScoreCard"] as! String)
                tempMan = jsonElement["Manufacturer"] as! String
                attraction.manufacturer = tempMan.replacingOccurrences(of: "!A?", with: "&")
                attraction.isCheck = false
                attraction.previousNames = (jsonElement["FormerNames"] as! String)
                attraction.model = (jsonElement["model"] as! String)
                attraction.height = Double (jsonElement["height"] as! String)
                attraction.speed = Double (jsonElement["maxSpeed"] as! String)
                attraction.length = Double (jsonElement["length"] as! String)
                attraction.duration = Int (jsonElement["attractionDuration"] as! String)
                attraction.photoArtist = (jsonElement["photoArtist"] as! String)
                attraction.photoLink = (jsonElement["photoLink"] as! String)
                attraction.photoCC = (jsonElement["CCType"] as! String)
                attraction.ridePartner = (jsonElement["attractionLink"] as! String)
                attraction.modifyBy = (jsonElement["modifyBy"] as! String)
                attraction.notes = (jsonElement["Notes"] as! String)
                attraction.seasonal = Int(jsonElement["Seasonal"] as! String)
                dataBaseData.add(attraction)
            }
            if dataBase == "Suggest" {
                let attraction = ApproveSuggestAttracionModel()
                var tempName = ""
                var tempMan = ""
                var tempNotes = ""
                attraction.parkID = Int (jsonElement["ParkID"] as! String)
                tempName = (jsonElement["RideName"] as? String)!
                tempName = tempName.replacingOccurrences(of: "_", with: " ")
                attraction.rideName = tempName.replacingOccurrences(of: "!A?", with: "&")
                attraction.YearOpen = Int (jsonElement["YearOpen"] as! String)
                attraction.rideID = Int(jsonElement["rideID"] as! String)
                attraction.YearClose = Int (jsonElement["YearClose"] as! String)
                attraction.type = Int (jsonElement["Type"] as! String)
                attraction.parkName = jsonElement["Park"] as? String
                attraction.id = Int (jsonElement["id"] as! String)
                attraction.active = Int (jsonElement["Active"] as! String)
                attraction.seasonal = Int(jsonElement["seasonal"] as! String)
                tempMan = (jsonElement["Manufacturer"] as? String)!
                attraction.manufacturer = tempMan.replacingOccurrences(of: "!A?", with: "&")
                tempNotes = (jsonElement["Notes"] as? String)!
                attraction.notes = tempNotes.replacingOccurrences(of: "_", with: " ")
                attraction.modify = Int(jsonElement["modify"] as! String)
                attraction.scoreCard = Int(jsonElement["scoreCard"] as! String)
                attraction.formerNames = jsonElement["formerNames"] as? String
                attraction.model = jsonElement["model"] as? String
                attraction.height = Double(jsonElement["height"] as! String)
                attraction.speed = Double(jsonElement["maxSpeed"] as! String)
                attraction.length = Double(jsonElement["length"] as! String)
                attraction.duration = Int(jsonElement["attractionDuration"] as! String)
                attraction.userName = jsonElement["userEmail"] as? String
                attraction.dateAdded = jsonElement["DateTime_Created"] as? String
                attraction.key = Int(jsonElement["id"] as! String)
                attraction.userID = jsonElement["userID"] as? String
                attraction.token = jsonElement["token"] as? String
                dataBaseData.add(attraction)
                print ("Ride name is: ", attraction.rideName!)
            }
            if dataBase == "ParkSuggest" {
                let suggPark = ApproveSuggParksModel()
                suggPark.name = (jsonElement["name"] as! String)
                suggPark.type = (jsonElement["type"] as! String)
                suggPark.city = (jsonElement["city"] as! String)
                suggPark.country = (jsonElement["country"] as! String)
                suggPark.latitude = Double(jsonElement["latitude"] as! String)
                suggPark.longitude = Double(jsonElement["longitude"] as! String)
                suggPark.open = Int(jsonElement["open"] as! String)
                suggPark.closed = Int(jsonElement["closed"] as! String)
                suggPark.defunct = Int(jsonElement["defunct"] as! String)
                suggPark.prevName = (jsonElement["prevName"] as! String)
                suggPark.seasonal = Int(jsonElement["seasonal"] as! String)
                suggPark.userName = (jsonElement["userName"] as! String)
                suggPark.userID = (jsonElement["userID"] as! String)
                suggPark.token = (jsonElement["token"] as! String)
                suggPark.website = (jsonElement["website"] as! String)
                suggPark.tempID = Int(jsonElement["idKey"] as! String)
                suggPark.date = (jsonElement["DateTime_Created"] as! String)
                dataBaseData.add(suggPark)
            }
            if dataBase == "PhotoSuggest"{
                let suggPhoto = approveSuggPhotoModel()
                suggPhoto.rideID = Int(jsonElement["rideID"] as! String)
                suggPhoto.userName = (jsonElement["photoArtist"] as! String)
                suggPhoto.rideName = (jsonElement["rideName"] as! String)
                suggPhoto.ParkName = (jsonElement["parkName"] as! String)
                suggPhoto.parkID = Int(jsonElement["parkID"] as! String)
                suggPhoto.tempID = Int(jsonElement["keyID"] as! String)
                suggPhoto.date = (jsonElement["DateTime_Created"] as! String)
                dataBaseData.add(suggPhoto)
            }
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsDownloaded(items: dataBaseData, returnPath: returnPath)
        })
    }
}
