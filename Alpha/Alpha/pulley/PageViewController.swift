//
//  PageViewController.swift
//  Alpha
//
//  Created by Alper Maraz on 03.12.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Pulley
import CoreLocation

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, PulleyDrawerViewControllerDelegate, CLLocationManagerDelegate {
    
    var name = ""
    var adresse = ""
    var pageControl = UIPageControl()
    
    // MARK: UIPageViewControllerDataSource
    
//    lazy var orderedViewControllers: [UIViewController] = {
//        return [self.newVc(viewController: "DetailVC"),
//                self.newVc(viewController: "SpeisekarteVC")]
//    }()
    
    var orderedViewControllers: [UIViewController] = []
    
    
    override func viewDidLoad() {
        print(name, "hierpageview")
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        let detailvc =  UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        let detvc = detailvc as PageObservation
        detvc.getParentPageViewController(parentRef: self)
        orderedViewControllers.append(detailvc)
        
        let speisevc =  UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "SpeisekarteVC") as! SpeisekarteVC
        let speisvc = speisevc as PageObservation
        speisvc.getParentPageViewController(parentRef: self)
        
        orderedViewControllers.append(speisevc)
        
//        let bestellungVC2 =  UIStoryboard(name: "Main", bundle: nil) .
//            instantiateViewController(withIdentifier: "BestellungVC") as! BestellungVC
//        let bestellVC2 = bestellungVC2 as PageObservation
//        bestellVC2.getParentPageViewController(parentRef: self)
//
//        orderedViewControllers.append(bestellungVC2)
        
       // let speisevc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpeisekarteVC") as! SpeisekarteVC
        
      //  speisevc.barname = name
       
 
        
//        let detvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
//        detvc.barname = name
//        print(detvc.barname, "dhdhfhdah")
//
        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        
            print(name, "hierpageviewwww2")
        }
        
      //  configurePageControl()
        
        // Do any additional setup after loading the view.
    }
    
//    func configurePageControl() {
//        // The total number of pages that are available is based on how many available colors we have.
//        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
//        self.pageControl.numberOfPages = orderedViewControllers.count
//        self.pageControl.currentPage = 0
//        self.pageControl.tintColor = UIColor.black
//        self.pageControl.pageIndicatorTintColor = UIColor.white
//        self.pageControl.currentPageIndicatorTintColor = UIColor.black
//        self.view.addSubview(pageControl)
//    }
//
//    func newVc(viewController: String) -> UIViewController {
//        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
//    }
//
    
    // MARK: Delegate methords
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        let pageContentViewController = pageViewController.viewControllers![0]
//        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
//    }
    
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("hallo1")

        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
           // return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            
             return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("hallo2")

        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
           // return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
             return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    //movePulley
    func pos1 (){
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 1)!, animated: true)
    }

    
    //Back
    func goback(){
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!, animated: true)
        let drawervc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerVC") as! DrawerVC
        
        
        
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: drawervc, animated: true)
    }
    
    // PULLEY
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 102.0
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 240.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    } 

    
}
protocol PageObservation: class {
    func getParentPageViewController(parentRef: PageViewController)
}
