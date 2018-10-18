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

class ViewPhotoViewController: UIViewController {
    @IBOutlet weak var rideNameLabel: UILabel!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
   // @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    var rideName = ""
    var parkName = ""
    var userName = ""
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
        imageRef.getData(maxSize: 1*1000*1000) { (data, error) in
            if error == nil {
                print("image found")
                self.attractionImage = UIImage(data: data!)
                let height = self.attractionImage.size.height
                let heightCons = height/250.0
                let width = self.attractionImage.size.width/heightCons //gets width to match up when height is 150
               // self.imageWidth.constant = width
                //self.imageHeight.constant = 250
                
                self.imageView.image = UIImage(data: data!)

            }
            else{
                print("image not found at \(self.rideID)")
            }
        }
        // Do any additional setup after loading the view.
    }
    
}
