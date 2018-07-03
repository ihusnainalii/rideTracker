//
//  ApproveSuggestedAttractionViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 7/3/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class ApproveSuggestedAttractionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataModelProtocol {
    
    //var feedItems: NSArray = NSArray()
    var listOfSuggestions = [ApproveSuggestAttracionModel]()
    @IBOutlet weak var ApproveAttractionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlPath = "http://www.beingpositioned.com/theparksman/UserSuggestDownloadService.php"
        let dataModel = DataModel()
        dataModel.delegate = self
        dataModel.downloadData(urlPath: urlPath, dataBase: "Suggest", returnPath: "allParks")
        
        self.ApproveAttractionTableView.delegate = self
        self.ApproveAttractionTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func itemsDownloaded(items: NSArray, returnPath: String) {
        let arrayOfAllRides = items as! [ApproveSuggestAttracionModel]
        print ("size of array",arrayOfAllRides.count)
        for i in 0..<arrayOfAllRides.count{
                print(arrayOfAllRides[i].rideName!)
        listOfSuggestions.append(arrayOfAllRides[i])
        }
        self.ApproveAttractionTableView.reloadData()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("Size is ", listOfSuggestions.count)
        return listOfSuggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestCell", for: indexPath) as! SuggestTableViewCell
        let item: ApproveSuggestAttracionModel = listOfSuggestions[indexPath.row]
        
        cell.parkNameLabel!.text = item.parkName
        cell.rideNameLabel!.text = item.rideName

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
