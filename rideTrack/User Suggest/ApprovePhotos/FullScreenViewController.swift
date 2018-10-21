//
//  FullScreenViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 10/18/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    var attractionImage: UIImage!
    let screenSize = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = attractionImage
        imageWidth.constant = screenSize.width
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 6
        // Do any additional setup after loading the view.
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
