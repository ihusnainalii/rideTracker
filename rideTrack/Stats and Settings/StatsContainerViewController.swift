//
//  StatsPageViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 8/30/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class StatsContainerViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var allParksList = [ParksList]()
    var arrayOfAllParks = [ParksModel]()
    
    var statsViewController: StatsViewController!
    var overViewController: OverViewController!
    var topListViewController: TopListsViewController!
    var rideTypeViewController: RideTypeViewController!
    var mapViewController: MapViewController!
    
    var stats: Stats!
    let screenSize = UIScreen.main.bounds
    
    var pageControl = UIPageControl()
    
    // MARK: UIPageViewControllerDataSource
    
    lazy var orderedViewControllers: [UIViewController] = {
        overViewController = UIStoryboard(name: "StatsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "overViewController") as! OverViewController
        topListViewController = UIStoryboard(name: "StatsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "topListViewController") as! TopListsViewController
        rideTypeViewController = UIStoryboard(name: "StatsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "rideTypeViewController") as! RideTypeViewController
        mapViewController = UIStoryboard(name: "StatsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
    
        
        mapViewController.allParksList = allParksList
        mapViewController.arrayOfAllParks = arrayOfAllParks
        
        return [self.overViewController,
                self.topListViewController,
                self.rideTypeViewController,
                self.mapViewController]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        
        
        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        configurePageControl()
        
        // Do any additional setup after loading the view.
    }
    
    func updateAllStats(stats: Stats){
        overViewController.updateLabels(stats: stats)
        
        
        rideTypeViewController.stats = stats
        if rideTypeViewController.viewAlreadyLoaded{
            rideTypeViewController.updateLabels()
        }
    }
    
    func updateTopLists(topRides: [TopLists], topParks: [ParksList]){
        print("updating list")
        topListViewController.stats = stats
        topListViewController.topRides = topRides
        topListViewController.topParks = topParks
        if topListViewController.viewAlreadyLoaded{
            topListViewController.updateLables()
        }
    }
    

    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 35,width: UIScreen.main.bounds.width,height: 50))
        
        if screenSize.height == 812.0{
            pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 55,width: UIScreen.main.bounds.width,height: 50))
        }

        
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        self.statsViewController.view.addSubview(pageControl)
    }
    
//    func newVc(viewController: String) -> UIViewController {
//        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
//    }
    
    
    // MARK: Delegate methords
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
//        if pageContentViewController is OverViewController{
//            overViewController.updateLabels(stats: stats)
//        } else if pageContentViewController is RideTypeViewController{
//            rideTypeViewController.updateLabels(stats: stats)
//        }
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
   
   
    
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            //return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
}

