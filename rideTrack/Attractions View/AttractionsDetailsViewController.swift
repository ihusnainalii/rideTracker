//
//  AttractionsDetailsViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 5/28/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseStorage

class AttractionsDetailsViewController: UIViewController {
   
    var rememberPasscode = UserDefaults.standard.integer(forKey: "rememberPasscode")
    var typeString = ""
    var selectedRide = AttractionsModel()
    var modifyDate = Date()
    var comeFromDetails = false
    var userAttractionDatabase: [AttractionList]!
    var favoiteParkList: [ParksList]!
    var titleName = ""
    var attractionsListRef: DatabaseReference!
    var user: User!
    var attractionImage: UIImage!
    var imageXCorr: CGFloat = 0.0
    var imageYCorr: CGFloat = 0.0
    var includeHiddenView = false
    let greyColor = UIColor(red: 211/255.0, green: 213/255.0, blue: 215/255.0, alpha: 1.0)
    var isfiltering = false
    var userEmail = ""
    var copyrightType = ""
    var copyrightLinkText = ""
    
    @IBOutlet weak var imageSection: UIView!
    @IBOutlet weak var uiImageView: UIImageView!
    @IBOutlet weak var inspectorButton: UIButton!
    @IBOutlet weak var blankView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var CCView: UIView!
    @IBOutlet weak var manufacturerStack: UIStackView!
    @IBOutlet weak var firstRideStack: UIStackView!
    @IBOutlet weak var LatestRideStack: UIStackView!
    @IBOutlet weak var yearClosedStack: UIStackView!
    @IBOutlet weak var formerNamesStack: UIStackView!
    
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var manufacturText: UILabel!
    @IBOutlet weak var FirstdateModifyButton: UIButton!
    @IBOutlet weak var LatestDateModifyButton: UIButton!
    @IBOutlet weak var rideNameLabel: UILabel!
    @IBOutlet weak var yearCloseLabel: UILabel!
    @IBOutlet weak var yearOpenLabel: UILabel!
    @IBOutlet weak var yearCloseText: UILabel!
    @IBOutlet weak var attractiontype: UILabel!
    @IBOutlet weak var formerNamesLabel: UILabel!
    
    @IBOutlet weak var modifyDateView: UIView!
    @IBOutlet weak var modifyDatePicker: UIDatePicker!
    @IBOutlet weak var scoreCardButton: UIButton!
    
    @IBOutlet weak var extendedDetailsView: UIView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var durrationLabel: UILabel!
    @IBOutlet weak var blankView2: UIView!
    
    @IBOutlet weak var modelView: UIStackView!
    @IBOutlet weak var modelLabel: UILabel!
    
    @IBOutlet weak var speedView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var lengthView: UIView!
    @IBOutlet weak var durationView: UIView!
    
    @IBOutlet weak var photoLinkText: UITextView!
    @IBOutlet weak var photoAuthorName: UILabel!
    @IBOutlet weak var PhotoCCText: UITextView!
    
    @IBOutlet weak var copyrightCenter: NSLayoutConstraint!
    
    @IBOutlet weak var detailViewHeight: NSLayoutConstraint!
  //  @IBOutlet weak var userDatesView: UIView!
    //@IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var OverlayView: UIView!
    var initialToucnPoint : CGPoint = CGPoint(x: 0, y: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        let userID = Auth.auth().currentUser
        let id = userID?.uid
        self.attractionsListRef = Database.database().reference(withPath: "attractions-list/\(id!)/\(String(selectedRide.parkID))/\(String(selectedRide.rideID))")
        
        print ("ride ID: ", self.selectedRide.rideID!)
        

        OverlayView.layer.cornerRadius = 10.0
        OverlayView.backgroundColor = UIColor.white
        
        modifyDatePicker.maximumDate = Date()
        scoreCardButton.isHidden = true
        scoreCardButton.backgroundColor = greyColor
        scoreCardButton.layer.cornerRadius = 6.0
        CCView.isHidden = true
        bottomView.isHidden = false
        
        blankView.isHidden = false
        self.imageSection.isHidden = true

        //dateModifyButton.layer.cornerRadius = 5.0
      //  userDatesView.backgroundColor = greyColor
        //userDatesView.layer.cornerRadius = 10.0
        let tempName = selectedRide.name
        rideNameLabel.text = tempName
        if selectedRide.yearOpen == 0{
            yearOpenLabel.text = "Unknown"
        }
        else{
            yearOpenLabel.text = String(selectedRide.yearOpen)
        }
        if selectedRide.active == 1 {
            yearClosedStack.isHidden = true
        }
        else {
            yearCloseLabel.text = String (selectedRide.yearClosed)
        }
        if selectedRide.isCheck{
            FirstdateModifyButton.setTitle(dateFormatter(date: selectedRide.dateFirstRidden), for: .normal)
            firstRideStack.isHidden = false
            LatestRideStack.isHidden = false
            //Do not show last ride if the user has only ridden the ride once
            if selectedRide.numberOfTimesRidden > 1{
                LatestDateModifyButton.setTitle(dateFormatter(date: selectedRide.dateLastRidden), for: .normal)
            }
            else{
                LatestRideStack.isHidden = true
            }
        }
        else{
            FirstdateModifyButton.isHidden = true
            firstRideStack.isHidden = true
            LatestRideStack.isHidden = true
            //userDatesView.isHidden = true
            
        }
        
        if selectedRide.hasScoreCard == 1{
            scoreCardButton.isHidden = false
        }
        if selectedRide.manufacturer == "" {
            manufacturerStack.isHidden = true
            includeHiddenView = true
        }
        else {
            manufacturerStack.isHidden = false
            manufacturerLabel.text = selectedRide.manufacturer
        }
        
        if selectedRide.previousNames == "" {
            formerNamesStack.isHidden = true
            includeHiddenView = true
        }
        else {
            formerNamesStack.isHidden = false
            formerNamesLabel.text = selectedRide.previousNames
        }
        if includeHiddenView{
            blankView.isHidden = true
        }
        
        if selectedRide.model != "" {
            modelView.isHidden = false
            modelLabel.text = selectedRide.model
        }
        else {
            modelView.isHidden = true
        }
        let height = selectedRide.height
        let speed = selectedRide.speed
        let length = selectedRide.length
        let duration = calculateDuration()
        if height == 0 { heightView.isHidden = true }
        if speed == 0 {speedView.isHidden = true }
        if length == 0 {lengthView.isHidden = true}
        if  selectedRide.duration == 0 {durationView.isHidden = true}
        
        if height != 0 || speed != 0 || length != 0 || selectedRide.duration != 0 {
            extendedDetailsView.isHidden = false
            blankView2.isHidden = true
            heightLabel.text = "\(height!) ft"
            speedLabel.text = "\(speed!) mph"
            lengthLabel.text = "\(length!) ft"
            durrationLabel.text = duration
        }
        else {
            extendedDetailsView.isHidden = true
            blankView2.isHidden = true
        }
        switch selectedRide.rideType {
        case -1:
            typeString = "Unknown"
        case 1:
            typeString = "Roller Coaster"
        case 2:
            typeString = "Water Ride"
        case 3:
            typeString = "Children's Ride"
        case 4:
            typeString = "Flat Ride"
        case 5:
            typeString = "Transport Ride"
        case 6:
            typeString = "Dark Ride"
        case 7:
            typeString = "Explore"
        case 8:
            typeString = "Spectacular"
        case 9:
            typeString = "Show"
        case 10:
            typeString = "Film"
        case 11:
            typeString = "Parade"
        case 12:
            typeString = "Play Area"
        case 13:
            typeString = "Upcharge"
        default:
            typeString = "Unknown"
        }
        if typeString == "Unknown"{
            attractiontype.isHidden = true
        }
        attractiontype.text = typeString

        //photo downloading
        
        
       // let database = Database.database().reference()
        let storage = Storage.storage().reference()
        let imageRef = storage.child("\(selectedRide.parkID!)/\(selectedRide.rideID!).jpg")
        imageRef.getData(maxSize: 1*1000*1000) { (data, error) in
            if error == nil {
                print("image found")
                if self.selectedRide.photoLink != "" {
                    self.setUpCCLinks()
                    self.CCView.isHidden = false
                    self.bottomView.isHidden = true
                    self.imageSection.isHidden = false
                }
                else if self.selectedRide.photoArtist == "Self"{
                    self.CCView.isHidden = true
                    self.bottomView.isHidden = false
                    self.imageSection.isHidden = false
                }
                else {
                    print("WE HAVE A PHOTO WITHOUT CC INFO!!!, the picture will not be shown")
                    self.CCView.isHidden = true
                    self.bottomView.isHidden = false
                    self.imageSection.isHidden = true

                }
                
                self.uiImageView.layer.cornerRadius = 30
                //self.uiImageView.layer.cornerRadius = self.uiImageView.frame.size.height/2
                self.uiImageView.layer.masksToBounds = true
                self.uiImageView.layer.borderWidth = 0
                let Croppedimage = self.cropToSquare(image: UIImage(data: data!)!)
                self.uiImageView.image = Croppedimage //UIImage(data: data!)
                self.attractionImage = Croppedimage
                self.PhotoCCText.isEditable = false
                self.photoLinkText.isEditable = false
                self.PhotoCCText.tintColor = UIColor.lightGray
                self.photoLinkText.tintColor = UIColor.lightGray
                self.photoAuthorName.tintColor = UIColor.lightGray
                self.PhotoCCText.textColor = UIColor.lightGray
            }
            else {
                print(error?.localizedDescription)
                self.imageSection.isHidden = true
            }
        }
        imageXCorr = uiImageView.frame.origin.x
        imageYCorr = uiImageView.frame.origin.y
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AttractionsDetailsViewController.imageTapped(gesture:)))
        uiImageView.addGestureRecognizer(tapGesture)
        uiImageView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIView.animate(withDuration: 0.7, animations: { //Animate Here
           // self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func cropToSquare (image: UIImage) -> UIImage {
        var imageHeight = image.size.height
        var imageWidth = image.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        let size = CGSize(width: imageWidth, height: imageHeight)
        let refWidth : CGFloat = CGFloat(image.cgImage!.width)
        let refHeight : CGFloat = CGFloat(image.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        let imageRef = image.cgImage!.cropping(to: cropRect)
        return UIImage(cgImage: imageRef!, scale: 0, orientation: image.imageOrientation)
        //}
        
     //   return nil
    }
    
    @IBAction func didPressModifyDate(_ sender: Any) {
        FirstdateModifyButton.isEnabled = false
        LatestDateModifyButton.isUserInteractionEnabled = false
        FirstdateModifyButton.isHighlighted = true
        modifyDateView.isHidden = false
        modifyDatePicker.setDate(selectedRide.dateFirstRidden, animated: false)
        UIView.animate(withDuration: 0.3, animations: { //Animate Here
            self.detailViewHeight.constant += 170
         //   self.detailsView.frame.origin.y -= 10
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func modifyLatestRideDate(_ sender: Any) {
        LatestDateModifyButton.isEnabled = false
        FirstdateModifyButton.isUserInteractionEnabled = false
        LatestDateModifyButton.isHighlighted = true
        modifyDateView.isHidden = false
        modifyDatePicker.setDate(selectedRide.dateLastRidden, animated: false)
        UIView.animate(withDuration: 0.3, animations: { //Animate Here
            self.detailViewHeight.constant += 170
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    @IBAction func didModifyDate(_ sender: Any) {
        print("modify")
        if LatestDateModifyButton.isEnabled {
        FirstdateModifyButton.setTitle(dateFormatter(date: modifyDatePicker.date), for: .normal)
        }
        else {
            LatestDateModifyButton.setTitle(dateFormatter(date: modifyDatePicker.date), for: .normal)
        }
        }

    
    @IBAction func pressDownBar(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: { //Animate Here
            // self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func didSaveModifyDate(_ sender: Any) {
        FirstdateModifyButton.isUserInteractionEnabled = true
        LatestDateModifyButton.isUserInteractionEnabled = true
        if LatestDateModifyButton.isEnabled {
            FirstdateModifyButton.isEnabled = true
        FirstdateModifyButton.isHighlighted = false
        modifyDateView.isHidden = true
        FirstdateModifyButton.setTitle(dateFormatter(date: modifyDatePicker.date), for: .normal)
        selectedRide.dateFirstRidden = modifyDatePicker.date
            saveModifyRideDate(firstRide: true, rideID: selectedRide.rideID, RideDate: modifyDatePicker.date)
            UIView.animate(withDuration: 0.3, animations: { //Animate Here
                self.detailViewHeight.constant -= 170
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else {
            LatestDateModifyButton.isEnabled = true
            LatestDateModifyButton.isHighlighted = false
            modifyDateView.isHidden = true
            LatestDateModifyButton.setTitle(dateFormatter(date: modifyDatePicker.date), for: .normal)
            selectedRide.dateLastRidden = modifyDatePicker.date
            saveModifyRideDate(firstRide: false, rideID: selectedRide.rideID, RideDate: modifyDatePicker.date)
            UIView.animate(withDuration: 0.3, animations: { //Animate Here
                self.detailViewHeight.constant -= 170
                self.view.layoutIfNeeded()
            }, completion: nil)
        }

    }
    func calculateDuration () -> String {
        let durationInSeconds = selectedRide.duration
        let minutes = durationInSeconds!/60
        let seconds = durationInSeconds!%60
        print("\(minutes) minutes \(seconds) seconds")
        return "\(minutes)m \(seconds)s"
        
    }
    
    func setUpCCLinks() {
        print("in cc links")
        photoAuthorName.text = "by \(selectedRide.photoArtist!)/"
        
        if selectedRide.photoCC == "CC 2.0"{
            copyrightType = "CC by 2.0"
            copyrightLinkText = "https://creativecommons.org/licenses/by/2.0/"
        }
        else if selectedRide.photoCC == "CC 2.0 by SA" {
            copyrightType = "CC by 2.0 by SA"
            copyrightLinkText = "https://creativecommons.org/licenses/by-sa/2.0/"
            copyrightCenter.constant = -30
        }
        else if selectedRide.photoCC == "Photo courtesy Orange County Archives" {
            copyrightType = "Photo courtesy Orange County Archives"
            copyrightLinkText = "http://www.ocarchives.com"
            photoAuthorName.text = "courtesy Orange County Archives"
            PhotoCCText.isHidden = true
            copyrightCenter.constant = 20
        }
        let linkAttributes: [NSAttributedStringKey: Any] = [
            .link: NSURL(string: copyrightLinkText)!,
            .foregroundColor: UIColor.lightGray, .underlineColor: UIColor.lightGray, .underlineStyle: NSUnderlineStyle.styleSingle.rawValue

        ]
        let attributedString = NSMutableAttributedString(string: copyrightType)
        attributedString.setAttributes(linkAttributes, range: NSMakeRange(0, 6))
        PhotoCCText.isEditable = false
        PhotoCCText.attributedText = attributedString
        PhotoCCText.font = .systemFont(ofSize: 12)
        
        let photoLinkSite = selectedRide.photoLink
        
        let linkAttributes2: [NSAttributedStringKey: Any] = [
            .link: NSURL(string: photoLinkSite!)!,
            .foregroundColor: UIColor.lightGray, .underlineStyle: NSUnderlineStyle.styleSingle.rawValue
        ]
        let attributedString2 = NSMutableAttributedString(string: "Photo")
        attributedString2.setAttributes(linkAttributes2, range: NSMakeRange(0, 5))
        photoLinkText.isEditable = false
        photoLinkText.attributedText = attributedString2
        photoLinkText.font = .systemFont(ofSize: 12)
        photoLinkText.textAlignment = .right
        print("at bottem of CC funcion")
    }
    
    func saveModifyRideDate(firstRide: Bool, rideID: Int, RideDate: Date){
        if firstRide {
        attractionsListRef.updateChildValues([
            "firstRideDate": RideDate.timeIntervalSince1970
            ])
        }
        else {
            attractionsListRef.updateChildValues(["lastRideDate": RideDate.timeIntervalSince1970])
        }
        }
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RideTrack")
//        fetchRequest.predicate = NSPredicate(format: "rideID = %@", "\(rideID)")
//        do {
//            let fetchedResults =  try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
//            for entity in fetchedResults! {
//                entity.setValue(firstRideDate, forKey: "firstRideDate")
//                try! managedContext.save()
//                print("Changing first ride date for ride ID \(rideID) to \(firstRideDate)")
//            }
//        }
//        catch _ {
//            print("Could not increment")
//        }
        
    
    func dateFormatter(date: Date) -> String {
        //let date = Date(timeIntervalSince1970: Double (timeToFormat))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMMM d, yyyy" //took off  h:mm Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
//    @IBAction func tapToExpand(_ sender: UITapGestureRecognizer) {
//        print("TAPED")
//        self.performSegue(withIdentifier: "expandPhoto", sender: self)
//    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
             self.performSegue(withIdentifier: "expandPhoto", sender: self)
        }
    }
    
    @IBAction func tapToExit(_ sender: UITapGestureRecognizer) {
        print ("Tap")
        UIView.animate(withDuration: 0.2, animations: { //Animate Here
            print ("Animating")
            // self.view.layoutIfNeeded()
        }, completion: nil)
        self.performSegue(withIdentifier: "unwindToAttractions", sender: self)
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func panToExit(_ sender: UIPanGestureRecognizer) {
        let touchPoint = (sender as AnyObject).location(in: self.view?.window)
        
        if (sender as AnyObject).state == UIGestureRecognizerState.began{
            initialToucnPoint = touchPoint
            
        }
        else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialToucnPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialToucnPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        }
        else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialToucnPoint.y > 50 {
                self.performSegue(withIdentifier: "unwindToAttractions", sender: self)
                self.dismiss(animated: true, completion: nil)

               
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

    
    
     // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toScoreCard"{
            let newVC = segue.destination as! ScoreCardViewController
            newVC.selectedRide = selectedRide
        }
        if segue.identifier == "toAttractions"{
            print ("Coming back")
            let newVC = segue.destination as! AttractionsViewController
            newVC.comeFromDetails = true
            newVC.parkID = selectedRide.parkID
            newVC.titleName = titleName
            newVC.userAttractionDatabase = userAttractionDatabase
        }
        if segue.identifier == "toModify"{
            let newVC = segue.destination as! ModifyAttractionDetailsViewController
            newVC.selectedAttraction = selectedRide
            newVC.parkName = titleName
            newVC.loginEmail = userEmail
            print("Seguaing now: ride name is ", selectedRide.name!)
            
        }
        if segue.identifier == "expandPhoto" {
            print("expanding")
            let newVC = segue.destination as! fullScreenPhotoViewController
            newVC.attractionImage = attractionImage
            newVC.selectedRide = selectedRide
//            newVC.smallimageXCorr = imageXCorr
//            newVC.smallimageYCorr = imageYCorr
        }
    }
    
    func findIndexFavoritesList(parkID: Int) -> Int{
        var favoritesIndex = -1
        for i in 0..<favoiteParkList.count{
            if favoiteParkList[i].parkID == parkID{
                favoritesIndex = i
                break
            }
        }
        return favoritesIndex
    }
    
    @IBAction func unwindToDetailsView(sender: UIStoryboardSegue) {
        print("Back to attractions view")
    }
    @IBAction func unwindToAttractionsView(sender: UIStoryboardSegue) {
        print("Back to attractions view down here")
    }
}
