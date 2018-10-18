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
    
    var rideName = ""
    var parkName = ""
    var userName = ""
    
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
                self.imageView.image = UIImage(data: data!)

            }
            else{
                print("image not found at \(self.rideID)")
            }
        }
        // Do any additional setup after loading the view.
    }
    
}
