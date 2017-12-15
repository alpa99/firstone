//
//  PageViewController2.swift
//  Alpha
//
//  Created by Alper Maraz on 11.12.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit

class PageViewController2: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var name = "Barracuda"
    
    var pageControl = UIPageControl()
    
    
    var orderedViewControllers: [UIViewController] = []
    
    
    override func viewDidLoad() {
        print(name, "hierpageview")
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        let detailvc =  UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "DetailVC2") as! DetailVC2
        let detvc = detailvc as PageObservation2
        detvc.getParentPageViewController2(parentRef2: self)
        orderedViewControllers.append(detailvc)

        let speisevc =  UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "SpeisekarteVC2") as! SpeisekarteVC2
        let speisvc = speisevc as PageObservation2
        speisvc.getParentPageViewController2(parentRef2: self)

        orderedViewControllers.append(speisevc)

       
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            
            
        }
        
    }
    
        

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
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
}

protocol PageObservation2: class {
    func getParentPageViewController2(parentRef2: PageViewController2)
}
