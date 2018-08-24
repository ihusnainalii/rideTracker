//
//  fullScreenPhotoViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 8/22/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class fullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var copyRightLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var attractionImage: UIImage!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = attractionImage
        let tap = UITapGestureRecognizer(target: self, action: #selector(fullScreenPhotoViewController.tapFunction))
        copyRightLabel.isUserInteractionEnabled = true
        copyRightLabel.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap link")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
