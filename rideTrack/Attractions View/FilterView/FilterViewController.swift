//
//  FilterViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 7/26/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterTableViewCellDelegate {

    var rideTypesforFilter = ["Roller Coaster", "Water Ride", "Children's Ride", "Flat Ride", "Transport Ride", "Dark Ride", "Explore", "Spectacular", "Show", "Film", "Parade", "Play Area", "Upcharge"]
    var typeFilter = [String]()
    var hasHaptic = 0
    var generator: UIImpactFeedbackGenerator!
    var popupGenerator: UIImpactFeedbackGenerator!
    var is3DTouchAvailable: Bool {
        return view.traitCollection.forceTouchCapability == .available
    }
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if is3DTouchAvailable{
            popupGenerator = UIImpactFeedbackGenerator(style: .heavy)
            generator = UIImpactFeedbackGenerator(style: .light)
            popupGenerator.prepare()
            generator.prepare()
        }
        hasHaptic = UIDevice.current.value(forKey: "_feedbackSupportLevel") as! Int
        filterView.layer.cornerRadius = 10.0
        filterView.backgroundColor = UIColor.white
        self.filterTableView.delegate = self
        self.filterTableView.dataSource = self
        var j = 0
        for i in 0..<typeFilter.count-j {
            if typeFilter[i] == "ALL" {
                typeFilter.remove(at: i)
                j += 1
                break
            }
        print ("\(typeFilter[i])")
        }
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideTypesforFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterTableViewCell
        cell.rideTypeLabel.text = rideTypesforFilter[indexPath.row]
        for i in 0..<(typeFilter.count) {
            if cell.rideTypeLabel.text == typeFilter[i] {
                cell.selectButton.image = #imageLiteral(resourceName: "green check")
                break
            }
            else {
                cell.selectButton.image = #imageLiteral(resourceName: "Check Button")
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (hasHaptic != 0) {
            generator.impactOccurred()
        }
        let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
        var checked = false
       // let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterTableViewCell
        print("Selecting type \(cell.rideTypeLabel.text!)")
        if cell.selectButton.image == #imageLiteral(resourceName: "Check Button"){
            print("HERE!")
            cell.selectButton.image = #imageLiteral(resourceName: "green check")
            typeFilter.append(cell.rideTypeLabel.text!)
            checked = true
        }
        if !checked {
        for i in 0..<(typeFilter.count) {
                    if cell.rideTypeLabel.text! == typeFilter[i]{
                        cell.selectButton.image = #imageLiteral(resourceName: "Check Button")
                        typeFilter.remove(at: i)
                        break
                    }
                }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromFilter" {
            let newVC = segue.destination as! AttractionsViewController
            if typeFilter.count == 0 {
                typeFilter.append("ALL")
            }
            newVC.typeFilter = typeFilter
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
