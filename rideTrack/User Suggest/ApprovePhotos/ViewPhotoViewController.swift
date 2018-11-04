//
//  ViewPhotoViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 10/17/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ViewPhotoViewController: UIViewController, DataModelProtocol {
    func itemsDownloaded(items: NSArray, returnPath: String) {
    }
    
    @IBOutlet weak var rideNameLabel: UILabel!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
   // @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    var rideName = ""
    var parkName = ""
    var userName = ""
    var tempID = 0
    var attractionImage: UIImage!

    var rideID = 0
    var parkID = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        rideNameLabel.text = rideName
        parkNameLabel.text = parkName
        userNameLabel.text = "submited by \(userName)"
        let storage = Storage.storage().reference()
        let imageRef = storage.child("UserSubmit/\(rideID).jpg")
        imageRef.getData(maxSize: 1*5000*5000) { (data, error) in
            if error == nil {
                print("image found")
                self.attractionImage = UIImage(data: data!)
                let height = self.attractionImage.size.height
                let heightCons = height/250.0
                let width = self.attractionImage.size.width/heightCons //gets width to match up when height is 150
               // self.imageWidth.constant = width
                //self.imageHeight.constant = 250
                
               // self.imageView.image = UIImage(data: data!)
                self.imageView.image = self.attractionImage
            }
            else{
                print("image not found at \(self.rideID)")
            }
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewPhotoViewController.imageTapped(gesture:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            self.performSegue(withIdentifier: "ToFullScreen", sender: self)
        }
    }
    @IBAction func approveButtonTapped(_ sender: Any) {
        let dataModel = DataModel()
        dataModel.delegate = self
        let urlPath = "http://www.beingpositioned.com/theparksman/addPhotoToAttraction.php?id=\(rideID)&photoArtist=\(userName)"
        print(urlPath)
        dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
        
        let storage = Storage.storage().reference()
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        //let tempImageREf = storage.child("\(parkID)/\(rideID).jpg")
        let path = "\(parkID)/\(rideID).jpg"
        print(path)
        let tempImageREf = storage.child(path)

        tempImageREf.putData(attractionImage.jpegData(compressionQuality: 0.25)!, metadata: metadata) { (Data, Error) in
            if Error == nil { print("successfully added photo")}
            else { print("ERROR adding photo") }
        }
        let changes = "Photo added to \(rideName) at \(parkName)"
        let (urlPath3) = "http://www.beingpositioned.com/theparksman/uploadToDatabaseLog.php? username=\(userName)&changes=\(changes)&status=\("Approved")" //uploads to suggestion log
        dataModel.downloadData(urlPath: urlPath3, dataBase: "upload", returnPath: "upload")
        
        deletePhotoFromList()
        self.performSegue(withIdentifier: "toSuggestPhotoLost", sender: self)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        deletePhotoFromList()
        self.performSegue(withIdentifier: "toSuggestPhotoLost", sender: self)

    }
    
    func deletePhotoFromList () {
        let dataModel = DataModel()
        dataModel.delegate = self
        let urlPath = "http://www.beingpositioned.com/theparksman/deleteFromPhotoSuggest.php?tempID=\(tempID)"
        print(urlPath)
        dataModel.downloadData(urlPath: urlPath, dataBase: "upload", returnPath: "upload")
        
        // Create a reference to the file to delete
        let storage = Storage.storage().reference()
        let imageRef = storage.child("UserSubmit/\(rideID).jpg")
        
        // Delete the file
        imageRef.delete { error in
            if error != nil {
                print("there has been an error!")
            } else {
                print("deleted successfully")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToFullScreen"{
            print("fullscreen")
            let photoVC = segue.destination as! FullScreenViewController
            photoVC.attractionImage = attractionImage
        }
    }
    @IBAction func unwindFromcancelButton(sender: UIStoryboardSegue) {
        print ("back from cancel")
    }
}
