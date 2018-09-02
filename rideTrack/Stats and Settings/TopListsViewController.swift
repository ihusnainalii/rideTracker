//
//  TopListsViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 8/31/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class TopListsViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var attraction1: UILabel!
    @IBOutlet weak var attraction2: UILabel!
    @IBOutlet weak var attraction3: UILabel!
    @IBOutlet weak var attraction4: UILabel!
    @IBOutlet weak var attraction5: UILabel!
    @IBOutlet weak var experience1: UILabel!
    @IBOutlet weak var experience2: UILabel!
    @IBOutlet weak var experience3: UILabel!
    @IBOutlet weak var experience4: UILabel!
    @IBOutlet weak var experience5: UILabel!
    
    
    var stats: Stats!
    var topRides = [TopLists]()
    var viewAlreadyLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 7
        backgroundView.layer.shadowOpacity = 0.3
        backgroundView.layer.shadowOffset = CGSize.zero
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.backgroundColor = UIColor.white.cgColor
        
        viewAlreadyLoaded = true
        if topRides.count != 0{
            updateLables()
        }
        // Do any additional setup after loading the view.
    }

    func updateLables(){
        if topRides.count > 4{
        attraction1.text = topRides[0].name
        attraction2.text = topRides[1].name
        attraction3.text = topRides[2].name
        attraction4.text = topRides[3].name
        attraction5.text = topRides[4].name
        
        experience1.text = String(topRides[0].number)
        experience2.text = String(topRides[1].number)
        experience3.text = String(topRides[2].number)
        experience4.text = String(topRides[3].number)
        experience5.text = String(topRides[4].number)
        }
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
