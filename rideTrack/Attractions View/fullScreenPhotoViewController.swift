//
//  fullScreenPhotoViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 8/22/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class fullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var copyrightLink: UITextView!
    @IBOutlet weak var photoLink: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    var attractionImage: UIImage!
    @IBOutlet weak var imageView: UIImageView!
    
    var initialToucnPoint : CGPoint = CGPoint(x: 0, y: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = attractionImage
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
        
        if (sender as AnyObject).state == UIGestureRecognizerState.began{
            initialToucnPoint = touchPoint
            // print ("begun")
        }
        else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialToucnPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialToucnPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        }
        else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialToucnPoint.y > 50 {
                self.performSegue(withIdentifier: "unwindToDetails", sender: self)
                self.dismiss(animated: true, completion: nil)
//            } else {
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    UIView.animate(withDuration: 0.2, animations: { //Animate Here
                        // self.view.layoutIfNeeded()
                    }, completion: nil)
                })
            }
        }
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
