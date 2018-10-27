//
//  fullScreenPhotoViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 8/22/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import SafariServices

class fullScreenPhotoViewController: UIViewController, UIScrollViewDelegate, SFSafariViewControllerDelegate {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var ccLable: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var attractionImage: UIImage!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoAuthorNameLabel: UILabel!
    @IBOutlet weak var copyrightCenter: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    let phoneSize = UIScreen.main.bounds

    @IBOutlet weak var imageViewTop: NSLayoutConstraint!
    let screenSize = UIScreen.main.bounds
    var normHieght: CGFloat = 0.0
    var normWidth: CGFloat = 0.0
    var smallHieght: CGFloat = 0.0
    var smallWidth: CGFloat = 0.0
    var heightLocY:CGFloat = 0.0
    var widthLocX:CGFloat = 0.0
    var copyrightType = ""
    var copyrightLinkText = ""
    var selectedRide = AttractionsModel()
    var screenWidth: CGFloat = 375.0
    
    var initialToucnPoint : CGPoint = CGPoint(x: 0, y: 0)
    override func viewDidLoad() {
        imageWidth.constant = screenSize.width
        super.viewDidLoad()
        
        if phoneSize.width == 320 {
            screenWidth = 320
        }
        
        imageView.image = attractionImage
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(1)
       // backgroundView.frame.size.height = screenSize.height*3
        backgroundView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height*2)

  
        if self.selectedRide.photoLink != "" {
            self.ccLable.setTitle("\(String(describing: self.selectedRide.photoCC!))", for: .normal)
            if self.selectedRide.photoCC == "Photo courtesy Orange County Archives" {
                self.photoAuthorNameLabel.text = "Photo courtesy Orange County Archives"
                self.ccLable.isHidden = true
            }
            self.photoAuthorNameLabel.text = "by \(self.selectedRide.photoArtist!)/"
        }
        else if self.selectedRide.photoCC != "" {
            self.ccLable.setTitle("\(String(describing: self.selectedRide.photoCC!))", for: .normal)
            self.photoAuthorNameLabel.text = "by \(self.selectedRide.photoArtist!)/"
        }
        else if self.selectedRide.photoArtist == "Self"{
            photoAuthorNameLabel.isHidden = true
            ccLable.isHidden = true
            photoButton.isHidden = true
            
        }
        else if self.selectedRide.photoCC == "" && self.selectedRide.photoArtist != ""{ //for user submited photos
            self.photoAuthorNameLabel.text = "submitted by \(self.selectedRide.photoArtist!)"
            self.ccLable.isHidden = true
        }
        else {
            print("this shouldnt happen, but just in case, it will display everythnig")
            photoAuthorNameLabel.isHidden = true
            ccLable.isHidden = true
            photoButton.isHidden = true
        }

        imageView.layer.cornerRadius = 0
        imageView.clipsToBounds = true

        smallHieght = imageView.frame.height/2
        smallWidth = imageView.frame.width/2
        
        heightLocY = imageView.frame.origin.y
        widthLocX = imageView.frame.origin.x
        
        // Do any additional setup after loading the view.
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func panToExit(_ sender: UIPanGestureRecognizer) {
        let touchPoint = (sender as AnyObject).location(in: self.view?.window)

        if (sender as AnyObject).state == UIGestureRecognizer.State.began && scrollView.zoomScale == 1{
            initialToucnPoint = touchPoint
        }
        else if sender.state == UIGestureRecognizer.State.changed && scrollView.zoomScale == 1 {
            if touchPoint.y - initialToucnPoint.y > 0 {
                //self.view.frame = CGRect(x: 0, y: touchPoint.y - initialToucnPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
               self.imageView.frame = CGRect(x: 0, y: touchPoint.y - initialToucnPoint.y, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height)
            }
            if touchPoint.y >= 150 && scrollView.zoomScale == 1{
                var percent = ((touchPoint.y+self.initialToucnPoint.y)/touchPoint.y)-1
                    UIView.animate(withDuration: 0.3, animations: { //Animate Here
                        self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(percent)
                        //self.imageView.layer.cornerRadius = 30
                        //self.imageView.clipsToBounds = true
                        self.doneButton.isHidden = true
            }, completion: nil)
            }
            
        }
        else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled && scrollView.zoomScale == 1 {
            if touchPoint.y - initialToucnPoint.y > 50 && scrollView.zoomScale == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
                }, completion: nil)
                self.performSegue(withIdentifier: "unwindToDetails", sender: self)
                self.dismiss(animated: true, completion: nil)
            } else if scrollView.zoomScale == 1 { //retrun
                UIView.animate(withDuration: 0.3, animations: {
                        self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(1)
                        self.doneButton.isHidden = false
                        //self.imageView.layer.cornerRadius = 0
                        //self.imageView.clipsToBounds = true
                        // self.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: { //Animate Here
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.imageView.frame = CGRect(x: self.screenSize.width/4, y: self.screenSize.height/4, width: self.smallWidth, height: self.smallHieght)
            self.imageView.layer.cornerRadius = 30
            self.imageView.clipsToBounds = true
            self.doneButton.isHidden = true
            // self.view.layoutIfNeeded()
        }, completion: nil)
        self.performSegue(withIdentifier: "unwindToDetails", sender: self)
    }
    
    @IBAction func didPressPhotoLink(_ sender: Any) {
        if selectedRide.photoLink != "" {
            let photoLinkSite = selectedRide.photoLink
            let safariVC = SFSafariViewController(url: NSURL(string: photoLinkSite!)! as URL)
            safariVC.delegate = self
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func didPressCCLink(_ sender: Any) {
        if selectedRide.photoCC == "CC 2.0"{
            copyrightLinkText = "https://creativecommons.org/licenses/by/2.0/"
        }
        else if selectedRide.photoCC == "CC 2.0 by SA" {
            copyrightLinkText = "https://creativecommons.org/licenses/by-sa/2.0/"
        }
        else if selectedRide.photoCC == "Photo courtesy Orange County Archives" {
            copyrightLinkText = "http://www.ocarchives.com"
        }
        else if selectedRide.photoCC == "" {
            print("We dont need a copyright notice")
            copyrightLinkText = "https://creativecommons.org/licenses/by/2.0/"
        }
        else {
            copyrightLinkText = "https://creativecommons.org/licenses/by/2.0/"
        }
        let safariVC = SFSafariViewController(url: NSURL(string: copyrightLinkText)! as URL)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
    }
}
