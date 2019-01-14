//
//  ReportCardViewController.swift
//  
//
//  Created by Mark Lawrence on 1/12/19.
//

import UIKit

class ReportCardViewController: UIViewController {

    var userID: String!
    var reportCardLogic = ReportCardLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportCardLogic.getTodaysStatsSorted(userID: userID)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
