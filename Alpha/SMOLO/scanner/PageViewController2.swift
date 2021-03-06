//
//  PageViewController2.swift
//  SMOLO
//
//  Created by Alper Maraz on 11.12.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase

class PageViewController2: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var name = " "
    var adresse = " "
    var tischnummer = 0
    var KellnerID = ""
    var barname = ""
    
    var pageControl = UIPageControl()
    
    
    var orderedViewControllers: [UIViewController] = []
    
    
    override func viewDidLoad() {
        navigationController?.navigationBar.tintColor = UIColor.white

        self.navigationItem.title = barname
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
//        let detailvc =  UIStoryboard(name: "Main", bundle: nil) .
//            instantiateViewController(withIdentifier: "DetailVC2") as! DetailVC2
//        let detvc = detailvc as PageObservation2
//        detvc.getParentPageViewController2(parentRef2: self)
//        orderedViewControllers.append(detailvc)


        let bestellvc =  UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "BestellungVC2") as! BestellungVC2
        let bestvc = bestellvc as PageObservation2
        bestvc.getParentPageViewController2(parentRef2: self)
        orderedViewControllers.append(bestellvc)
       
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            
            
        }
        
    }
    func fetchData () {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("BarInfo").child("\(name)").observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bar = BarInfos(dictionary: dictionary)
                
               self.navigationItem.title = bar.Name!
                self.name = bar.Name!
                
            }} , withCancel: nil)
        
    }
    
        

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
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
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
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
}

protocol PageObservation2: class {
    func getParentPageViewController2(parentRef2: PageViewController2)
}
