//
//  fullScreenPhotoViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 8/22/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class fullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var copyrightLink: UITextView!
    @IBOutlet weak var photoLink: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    var attractionImage: UIImage!
    @IBOutlet weak var imageView: UIImageView!
    let screenSize = UIScreen.main.bounds
    var smallHieght: CGFloat = 0.0
    var smallWidth: CGFloat = 0.0
    var heightY:CGFloat = 0.0
    var widthX:CGFloat = 0.0
    
    var initialToucnPoint : CGPoint = CGPoint(x: 0, y: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = attractionImage
        backgroundView.backgroundColor = UIColor.white.withAlphaComponent(1)
        smallHieght = imageView.frame.height/2
        smallWidth = imageView.frame.width/2
        
        heightY = imageView.frame.origin.y
        widthX = imageView.frame.origin.x
        
        let copyrightType = "CC by 2.0"
        let copyrightLinkText = "https://creativecommons.org/licenses/by/2.0/"
        let linkAttributes: [NSAttributedStringKey: Any] = [
            .link: NSURL(string: copyrightLinkText)!,
            .foregroundColor: UIColor.blue
        ]
        let attributedString = NSMutableAttributedString(string: copyrightType)
        attributedString.setAttributes(linkAttributes, range: NSMakeRange(0, 6))
        copyrightLink.isEditable = false
        copyrightLink.attributedText = attributedString
        copyrightLink.font = .systemFont(ofSize: 16)

        let photoLinkSite = "https://www.apple.com"
        let linkAttributes2: [NSAttributedStringKey: Any] = [
            .link: NSURL(string: photoLinkSite)!,
            .foregroundColor: UIColor.blue
        ]
        let attributedString2 = NSMutableAttributedString(string: "Photo")
        attributedString2.setAttributes(linkAttributes2, range: NSMakeRange(0, 5))
        photoLink.isEditable = false
        photoLink.attributedText = attributedString2
        photoLink.font = .systemFont(ofSize: 16)
        photoLink.textAlignment = .right
    
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

        if (sender as AnyObject).state == UIGestureRecognizerState.began && scrollView.zoomScale == 1{
            initialToucnPoint = touchPoint
            // print ("begun")
        }
        else if sender.state == UIGestureRecognizerState.changed && scrollView.zoomScale == 1 {
            if touchPoint.y - initialToucnPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialToucnPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
            if touchPoint.y >= 150 && scrollView.zoomScale == 1{
             
                print ("size \(self.imageView.frame.width)")
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
        else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled && scrollView.zoomScale == 1 {
            if touchPoint.y - initialToucnPoint.y > 50 && scrollView.zoomScale == 1 {
                print(touchPoint.y - initialToucnPoint.y)
                self.performSegue(withIdentifier: "unwindToDetails", sender: self)
                self.dismiss(animated: true, completion: nil)
//            } else {
            } else if scrollView.zoomScale == 1 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

                    UIView.animate(withDuration: 0.2, animations: { //Animate Here
                        self.backgroundView.backgroundColor = UIColor.white.withAlphaComponent(1)
                        self.doneButton.isHidden = false
                        self.imageView.frame = CGRect(x: self.widthX, y: self.heightY, width: self.smallWidth*2, height: self.smallHieght*2)
                        self.imageView.layer.cornerRadius = 0
                        self.imageView.clipsToBounds = true
                        // self.view.layoutIfNeeded()
                    }, completion: nil)
                })
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
