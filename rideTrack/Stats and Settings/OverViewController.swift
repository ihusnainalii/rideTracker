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
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var countiesLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var expierencesLabel: UILabel!
    @IBOutlet weak var defunctLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var completedView: UIView!
    @IBOutlet weak var checkedInView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var activeView: UIView!
    @IBOutlet weak var expierencesView: UIView!
    @IBOutlet weak var defunctView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShadowAndRoundRec(uiView: backgroundView)
        addShadowAndRoundRec(uiView: completedView)
        addShadowAndRoundRec(uiView: checkedInView)
        addShadowAndRoundRec(uiView: countryView)
        addShadowAndRoundRec(uiView: activeView)
        addShadowAndRoundRec(uiView: expierencesView)
        addShadowAndRoundRec(uiView: defunctView)
        
        // Do any additional setup after loading the view.
    }

    
    func addShadowAndRoundRec(uiView: UIView){
        uiView.layer.cornerRadius = 7
        uiView.layer.shadowOpacity = 0.3
        uiView.layer.shadowOffset = CGSize.zero
        uiView.layer.shadowRadius = 5
        uiView.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func updateLabels(stats: Stats){
        parkLabel.text = String(stats.parks)
        attractionLabel.text = String(stats.attractions)
        completedLabel.text = String(stats.parksCompleted)
        //checkInLabel.text = String(stats.)
        countiesLabel.text = String(stats.countries)
        activeLabel.text = String(stats.activeAttractions)
        expierencesLabel.text = String(stats.experiences)
        defunctLabel.text = String(stats.extinctAttracions)
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
