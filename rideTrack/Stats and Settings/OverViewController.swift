//
//  OverViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 8/31/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class OverViewController: UIViewController {

    @IBOutlet weak var parkLabel: UILabel!
    @IBOutlet weak var attractionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    func updateLabels(stats: Stats){
        parkLabel.text = String(stats.parks)
        attractionLabel.text = String(stats.attractions)
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
