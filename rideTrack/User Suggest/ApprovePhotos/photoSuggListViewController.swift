//
//  ApprovePhotoListViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 10/17/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class photoSuggListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataModelProtocol {
    
    @IBOutlet weak var submitedPhotosTableView: UITableView!
    
    var listOfSuggestions = [approveSuggPhotoModel]()
    var selectedPark: approveSuggPhotoModel = approveSuggPhotoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlPath = "http://www.beingpositioned.com/theparksman/photoSuggDownload.php"
        print(urlPath)
        let dataModel = DataModel()
        dataModel.delegate = self
        dataModel.downloadData(urlPath: urlPath, dataBase: "PhotoSuggest", returnPath: "allParks")
        
        submitedPhotosTableView.delegate = self
        submitedPhotosTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        let arrayOfPhotos = items as! [approveSuggPhotoModel]
        print ("size of array",arrayOfPhotos.count)
        for i in 0..<arrayOfPhotos.count{
            listOfSuggestions.append(arrayOfPhotos[i])
        }
        self.submitedPhotosTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfSuggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "submitedPhotos", for: indexPath)
        //        cell.textLabel?.text = listOfSuggestions[indexPath.row].rideName
        //        cell.textLabel?.text = listOfSuggestions[indexPath.row].ParkName
        print("here")
        let cell = tableView.dequeueReusableCell(withIdentifier: "submitedPhotos", for: indexPath) as! suggPhotosTableViewCell
        cell.rideNameLabel.text? = listOfSuggestions[indexPath.row].rideName
        cell.parkNameLabel.text? = listOfSuggestions[indexPath.row].ParkName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewPhoto"{
            print("going to approve")
            let selectedIndex = (submitedPhotosTableView.indexPathForSelectedRow?.row)!
            let selectedPhoto = listOfSuggestions[selectedIndex]
            let photoVC = segue.destination as! ViewPhotoViewController
            photoVC.rideName = selectedPhoto.rideName!
            photoVC.parkName = selectedPhoto.ParkName!
            photoVC.rideID = selectedPhoto.rideID!
            photoVC.parkID = selectedPhoto.parkID!
            photoVC.userName = selectedPhoto.userName!
        }
    }
}
