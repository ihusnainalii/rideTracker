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
        print ("Hieght is \(phoneSize.height)")

        super.viewDidLoad()
        
        if phoneSize.width == 320 {
            screenWidth = 320
        }
        
        imageView.image = attractionImage
        backgroundView.backgroundColor = UIColor.white.withAlphaComponent(1)
  
        if self.selectedRide.photoLink != "" {
            self.ccLable.setTitle("\(String(describing: self.selectedRide.photoCC!))", for: .normal)
            if self.selectedRide.photoCC == "Photo courtesy Orange County Archives" {
                self.photoAuthorNameLabel.text = "Photo courtesy Orange County Archives"
                self.ccLable.isHidden = true
            }
            self.photoAuthorNameLabel.text = "by \(self.selectedRide.photoArtist!)/"
        }
        else {
            photoAuthorNameLabel.text = ""
           
        }
     
        
        //imageView.frame = CGRect(x: screenSize.width/4, y: screenSize.height/4, width: smallWidth, height: smallHieght)
            let width = self.attractionImage.size.width
            let widthCons = width/screenWidth
            normHieght = self.attractionImage.size.height/widthCons //gets width to match up when height is 150
            normWidth = screenWidth
            self.imageWidth.constant = normWidth
            self.imageHeight.constant = normHieght
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
       // print ("working")
        let touchPoint = (sender as AnyObject).location(in: self.view?.window)

        if (sender as AnyObject).state == UIGestureRecognizer.State.began && scrollView.zoomScale == 1{
            initialToucnPoint = touchPoint
            // print ("begun")
        }
        else if sender.state == UIGestureRecognizer.State.changed && scrollView.zoomScale == 1 {
            if touchPoint.y - initialToucnPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialToucnPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
            if touchPoint.y >= 150 && scrollView.zoomScale == 1{
                    UIView.animate(withDuration: 0.3, animations: { //Animate Here
                self.backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0)
                self.imageView.frame = CGRect(x: self.screenSize.width/4, y: self.screenSize.height/4, width: self.smallWidth, height: self.smallHieght)
                self.imageView.layer.cornerRadius = 30
                self.imageView.clipsToBounds = true
                self.doneButton.isHidden = true
                // self.view.layoutIfNeeded()
            }, completion: nil)
            }
            
        }
        else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled && scrollView.zoomScale == 1 {
            if touchPoint.y - initialToucnPoint.y > 50 && scrollView.zoomScale == 1 {
                self.performSegue(withIdentifier: "unwindToDetails", sender: self)
                self.dismiss(animated: true, completion: nil)
//            } else {
            } else if scrollView.zoomScale == 1 { //retrun
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    print("returning back here")
                        self.backgroundView.backgroundColor = UIColor.white.withAlphaComponent(1)
                        self.doneButton.isHidden = false
                        self.imageView.frame = CGRect(x: self.widthLocX, y: self.heightLocY, width: self.normWidth, height: self.normHieght)
                    //self.imageWidth.constant = self.normWidth
                    //self.imageHeight.constant = self.normHieght
                        self.imageView.layer.cornerRadius = 0
                        self.imageView.clipsToBounds = true
                        // self.view.layoutIfNeeded()
                    }, completion: nil)
                //})
            }
        }
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: { //Animate Here
            self.backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0)
            self.imageView.frame = CGRect(x: self.screenSize.width/4, y: self.screenSize.height/4, width: self.smallWidth, height: self.smallHieght)
            self.imageView.layer.cornerRadius = 30
            self.imageView.clipsToBounds = true
            self.doneButton.isHidden = true
            // self.view.layoutIfNeeded()
        }, completion: nil)
        self.performSegue(withIdentifier: "unwindToDetails", sender: self)
    }
    
    @IBAction func didPressPhotoLink(_ sender: Any) {
        let photoLinkSite = selectedRide.photoLink
        let safariVC = SFSafariViewController(url: NSURL(string: photoLinkSite!)! as URL)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
