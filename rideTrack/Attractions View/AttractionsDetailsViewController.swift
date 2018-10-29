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
import SafariServices

class AttractionsDetailsViewController: UIViewController, SFSafariViewControllerDelegate {
   
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
    var userID = ""
    var copyrightType = ""
    var copyrightLinkText = ""
    var insets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    var needsPhoto = true
    var fromListVC = false

    @IBOutlet weak var ccTypeButton: UIButton!
    let screenSize = UIScreen.main.bounds

    //contraints for new design
    @IBOutlet weak var upperViewHeight: NSLayoutConstraint!
    var totalHeightDetails = 0.0
    @IBOutlet weak var itemsInScrollHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollWidth: NSLayoutConstraint!
    @IBOutlet weak var bottomOfOverlayView: NSLayoutConstraint!
    @IBOutlet weak var parkPartnerView: UIView!
    @IBOutlet weak var partnerStack: UIStackView!
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var greyLine: UIView!
    
    
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageSection: UIView!
    @IBOutlet weak var uiImageView: UIImageView!
    @IBOutlet weak var modifyAttractionButton: UIButton!
    
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
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var durrationLabel: UILabel!
    
    @IBOutlet weak var modelView: UIStackView!
    @IBOutlet weak var modelLabel: UILabel!
    
    @IBOutlet weak var speedView: UIStackView!
    @IBOutlet weak var heightView: UIStackView!
    @IBOutlet weak var lengthView: UIStackView!
    @IBOutlet weak var durationView: UIStackView!
    
    @IBOutlet weak var photoAuthorName: UILabel!
    
    
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
        scoreCardButton.layer.shadowOffset = CGSize.zero
        scoreCardButton.layer.shadowRadius = 5
        scoreCardButton.layer.shadowOpacity = 0.3
        modifyAttractionButton.layer.shadowOffset = CGSize.zero
        modifyAttractionButton.layer.shadowRadius = 5
        modifyAttractionButton.layer.shadowOpacity = 0.3
        
        CCView.isHidden = true
        
        self.imageSection.isHidden = true
    //    scrollView.contentInset = insets

        parkPartnerView.layer.cornerRadius = 10
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
            yearCloseLabel.text = "Currently Operating"
            yearCloseText.font.withSize(10)
            yearCloseText.isHidden = true
            //yearClosedStack.isHidden = true
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
                totalHeightDetails += 30
            }
        }
        else{
            FirstdateModifyButton.isHidden = true
            firstRideStack.isHidden = true
            LatestRideStack.isHidden = true
            totalHeightDetails += 60
            //userDatesView.isHidden = true
            
        }
        
        if selectedRide.hasScoreCard == 1{
            scoreCardButton.isHidden = false
        }
        if selectedRide.manufacturer == "" {
            manufacturerStack.isHidden = true
            includeHiddenView = true
            totalHeightDetails += 30
        }
        else {
            manufacturerStack.isHidden = false
            manufacturerLabel.text = selectedRide.manufacturer
        }
        
        if selectedRide.previousNames == "" {
            formerNamesStack.isHidden = true
            includeHiddenView = true
            totalHeightDetails += 30
        }
        else {
            formerNamesStack.isHidden = false
            formerNamesLabel.text = selectedRide.previousNames
        }
        
        if selectedRide.model != "" {
            modelView.isHidden = false
            modelLabel.text = selectedRide.model
        }
        else {
            modelView.isHidden = true
            totalHeightDetails += 30
        }
        let height = selectedRide.height
        let speed = selectedRide.speed
        let length = selectedRide.length
        let duration = calculateDuration()
        if height == 0 {
            heightView.isHidden = true
            totalHeightDetails += 30
        }
        if speed == 0 {
            speedView.isHidden = true
            totalHeightDetails += 30
        }
        if length == 0 {
            lengthView.isHidden = true
            totalHeightDetails += 30
        }
        if  selectedRide.duration == 0 {
            durationView.isHidden = true
            totalHeightDetails += 30
        }
        
        if height != 0 || speed != 0 || length != 0 || selectedRide.duration != 0 {
            heightLabel.text = "\(height!) ft"
            speedLabel.text = "\(speed!) mph"
            lengthLabel.text = "\(length!) ft"
            durrationLabel.text = duration
        }
        
        if selectedRide.ridePartner != "" {
            print("the org URL is \(selectedRide.ridePartner!)")
            let fullURL = selectedRide.ridePartner!
            let characters = Array(fullURL)
            var startOffset = 0
            var endOffset = 0
            var findEnd = false
            for i in 0..<characters.count{
                if characters[i] == "w" && characters[i+1] == "w" && findEnd == false{
                    startOffset = i
                    findEnd = true
                }
                if characters[i] == "/" && findEnd == true {
                    endOffset = i
                    break;
                }
            }

            let start = fullURL.index(fullURL.startIndex, offsetBy: startOffset)
            let end = fullURL.index(fullURL.endIndex, offsetBy: endOffset-characters.count) //-6
            let range = start..<end
            let website = String(fullURL[range])
            partnerLabel.text = "about this attraction at \(website)"
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
        
        var maxFromTop: CGFloat = 0
        
        let textSize = CGSize(width: CGFloat(rideNameLabel.frame.size.width), height: CGFloat(MAXFLOAT)) //sees how many lines the ride name is to make the view the right height
        let rHeight: Int = lroundf(Float(rideNameLabel.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(rideNameLabel.font.pointSize))
        let numLines = rHeight / charSize
        
        print("screen size is: \(screenSize.height)")
        if screenSize.height > 700 {
            maxFromTop = screenSize.height - 540//540//497
        }
        else if screenSize.height == 568 {
            print("iphone 5 size")
            maxFromTop = 100 //80
        }
        else {
            maxFromTop = 190//170 //200
        }
        //photo downloading
    
        itemsInScrollHeight.constant = CGFloat((270 - totalHeightDetails)) //makes the scroller scroll the righ height based on contents
        
        scrollWidth.constant = screenSize.width - 60
        if numLines != 1 {
        maxFromTop -= CGFloat(numLines*20) //15 -=
            print("two lines")
        }
        if selectedRide.ridePartner == "" {
            partnerStack.isHidden = true
            maxFromTop += 23 //when the size was 45, this was 30
            print("mac from top is: \(maxFromTop)")
        }
        else {
            partnerStack.isHidden = false
            maxFromTop -= 15
        }
        
        let currHeightOfScroll = CGFloat(scrollView.frame.height)
       
        
        var newUpperHeight = Double(maxFromTop + 180 + currHeightOfScroll) //lower top bar MaxFromTop(originalTop) + 150(imageView) + 30 (CCView) + heightOfScrollView - (total keep in scrollView)
        if (270 - totalHeightDetails) < 145 {
            print("only need this much space: \(270 - totalHeightDetails). The height will be \(newUpperHeight - (270 - totalHeightDetails)). CurrHright is \(currHeightOfScroll)")
            
            upperViewHeight.constant = CGFloat(newUpperHeight - (270 - totalHeightDetails))
        }
        else {
            upperViewHeight.constant = (maxFromTop+150)
            
        }
        

        
       // let database = Database.database().reference()
        let storage = Storage.storage().reference()
        var showImage = true
        let imageRef = storage.child("\(selectedRide.parkID!)/\(selectedRide.rideID!).jpg")
        imageRef.getData(maxSize: 1*1000*1000) { (data, error) in
            if error == nil {
                print("image found")
                self.needsPhoto = false
                if self.selectedRide.photoLink != "" {
                    self.CCView.isHidden = false
                    self.imageSection.isHidden = false
                    self.ccTypeButton.setTitle("\(String(describing: self.selectedRide.photoCC!))", for: .normal)
                    if self.selectedRide.photoCC == "Photo courtesy Orange County Archives" {
                        self.photoAuthorName.text = "Photo courtesy Orange County Archives"
                        self.ccTypeButton.isHidden = true
                    }
                    self.photoAuthorName.text = "by \(self.selectedRide.photoArtist!)/"
                    maxFromTop -= 25

                }
                else if self.selectedRide.photoCC != "" {
                    self.CCView.isHidden = false
                    self.imageSection.isHidden = false
                    self.ccTypeButton.setTitle("\(String(describing: self.selectedRide.photoCC!))", for: .normal)
                    self.photoAuthorName.text = "by \(self.selectedRide.photoArtist!)/"
                    maxFromTop -= 25

                }
                else if self.selectedRide.photoArtist == "Self"{
                    self.CCView.isHidden = true
                    self.imageSection.isHidden = false
                }
                else if self.selectedRide.photoCC == "" && self.selectedRide.photoArtist != ""{ //for user submited photos
                    self.CCView.isHidden = false
                    self.imageSection.isHidden = false
                    self.photoAuthorName.text = "submitted by \(self.selectedRide.photoArtist!)"
                    self.ccTypeButton.isHidden = true
                     maxFromTop -= 25
                    showImage = true
                }
                    else {
                        print("this shouldnt happen, so it will display nothing")
                    self.CCView.isHidden = true
                    showImage = false
                    self.imageSection.isHidden = true
                    self.photoAuthorName.text = " by \(self.selectedRide.photoArtist!)/"
                    self.ccTypeButton.isHidden = true
                }
                print("Max height is \(maxFromTop)")
                if showImage {
                    self.uiImageView.layer.cornerRadius = 30
                    self.uiImageView.layer.masksToBounds = true
                    self.uiImageView.layer.borderWidth = 0
                    //let Croppedimage = self.cropToSquare(image: UIImage(data: data!)!)
                    self.attractionImage = UIImage(data: data!)
                        print("size is \(self.attractionImage.size)")
                        let height = self.attractionImage.size.height
                        let heightCons = height/150.0
                        let width = self.attractionImage.size.width/heightCons //gets width to match up when height is 150
                        self.imageWidth.constant = width
                        self.imageHeight.constant = 150
                    self.uiImageView.image = UIImage(data: data!) //UIImage(data: data!)

        
                  //  self.upperViewHeight.constant = (150)
                   if (270 - self.totalHeightDetails) < 145 && self.screenSize.height != 568{
                        maxFromTop += 30
                    }
                   else if self.screenSize.height != 568 {
                        maxFromTop -= 30
                    }
                    if self.selectedRide.ridePartner == "" {
                        self.partnerStack.isHidden = true
                        //maxFromTop += 30
                    }
                    else {
                    self.partnerStack.isHidden = false
                    }
                   
                    newUpperHeight = Double(maxFromTop + currHeightOfScroll)
                    if (270 - self.totalHeightDetails) < 145 {
                        print("with image, but no scroll")
                        
                    self.upperViewHeight.constant = CGFloat(newUpperHeight - (270 - self.totalHeightDetails)) //lower top bar
                    }
                    else {self.upperViewHeight.constant = (maxFromTop)}
                }
            else {
               print("over here")
                print(error?.localizedDescription)
                self.imageSection.isHidden = true
            }
            }
        }
        if 270 - totalHeightDetails == 0 {
            greyLine.isHidden = true
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
         //   self.detailsView.frame.origin.y -= 10
            self.upperViewHeight.constant -= 165
            self.bottomOfOverlayView.constant += 165
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
            self.upperViewHeight.constant -= 165
            self.bottomOfOverlayView.constant += 165
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
        if fromListVC{
            self.performSegue(withIdentifier: "unwindToList", sender: self)
        } else{
            self.performSegue(withIdentifier: "unwindToAttractions", sender: self)
            //self.navigationController?.setNavigationBarHidden(true, animated: true)

        }
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
                self.upperViewHeight.constant += 165
                self.bottomOfOverlayView.constant -= 165
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
                self.upperViewHeight.constant += 165
                self.bottomOfOverlayView.constant -= 165
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
    
    
    @IBAction func didPressPhotoLink(_ sender: Any) {
        if selectedRide.photoLink != "" {
            let photoLinkSite = selectedRide.photoLink
            let safariVC = SFSafariViewController(url: NSURL(string: photoLinkSite!)! as URL)
            safariVC.delegate = self
            self.present(safariVC, animated: true, completion: nil)
        }
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
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
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
    
    @IBAction func openParkPartners(_ sender: Any) {
        let photoLinkSite = selectedRide.ridePartner
        let safariVC = SFSafariViewController(url: NSURL(string: photoLinkSite!)! as URL)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
    }
    
    
    @IBAction func tapToExit(_ sender: UITapGestureRecognizer) {
        print ("Tap")
        UIView.animate(withDuration: 0.2, animations: { //Animate Here
            print ("Animating")
            // self.view.layoutIfNeeded()
        }, completion: nil)
        if fromListVC{
            self.performSegue(withIdentifier: "unwindToList", sender: self)
        } else{
            self.performSegue(withIdentifier: "unwindToAttractions", sender: self)
        }
        
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func panToExit(_ sender: UIPanGestureRecognizer) {
        let touchPoint = (sender as AnyObject).location(in: self.view?.window)
        
        if (sender as AnyObject).state == UIGestureRecognizer.State.began{
            initialToucnPoint = touchPoint
            
        }
        else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialToucnPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialToucnPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        }
        else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialToucnPoint.y > 50 {
                if fromListVC{
                    self.performSegue(withIdentifier: "unwindToList", sender: self)
                } else{
                    self.performSegue(withIdentifier: "unwindToAttractions", sender: self)
                }
                
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
            newVC.userID = userID
            newVC.needsPhoto = needsPhoto
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
extension UIView {
    @IBInspectable var ignoresInvertColors: Bool {
        get {
            if #available(iOS 11.0, *) {
                return accessibilityIgnoresInvertColors
            }
            return false
        }
        set {
            if #available(iOS 11.0, *) {
                accessibilityIgnoresInvertColors = newValue
            }
        }
    }
}
