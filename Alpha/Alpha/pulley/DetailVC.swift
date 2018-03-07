//
//  DetailVC.swift
//  Alpha
//
//  Created by Alper Maraz on 15.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Pulley
import Firebase
import ImageSlideshow

class DetailVC: UIViewController, PulleyDrawerViewControllerDelegate, PageObservation{
 
    var barname = ""
    var bars = [BarInfos]()
    var bilder = [String]()
    
    var counterlink = [String]()

    var adresse = String ()
    var picture = String ()
    var parentPageViewController: PageViewController!
    var sdWebImageSource = [SDWebImageSource]()

    
    func getParentPageViewController(parentRef: PageViewController) {
        parentPageViewController = parentRef
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.barname = parentPageViewController.name
        self.Namelbl.text = self.barname

        fetchPicsCount()
        fetchData()
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 0.0
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor(red: 185.0/255.0, green: 170.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        slideshow.pageControl.pageIndicatorTintColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.0)
   
        
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
       
       
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DetailVC.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var Namelbl: UILabel!
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    @IBAction func Backbtn(_ sender: UIButton) {
       parentPageViewController.goback()
        
    }
    
    
    func fetchPicsCount(){
        var refd: DatabaseReference!
        refd = Database.database().reference()
        refd.child("BarInfo").child("\(barname)").child("Bilder").observe(.value, with: { (snapshot) in
            self.fetchpics(bilderCount: snapshot.childrenCount)
        } , withCancel: nil)
    }
        
    func fetchpics (bilderCount: UInt) {
        var refd: DatabaseReference!
        refd = Database.database().reference()
        refd.child("BarInfo").child("\(barname)").child("Bilder").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bild = Bilder(dictionary: dictionary)

                if self.bilder.contains(bild.link!) == false {
                self.bilder.append(bild.link!)
                }
                
                if self.bilder.count == bilderCount{

                for links in self.bilder{

                    self.sdWebImageSource.append(SDWebImageSource(urlString: links)!)

                    self.slideshow.setImageInputs(self.sdWebImageSource as [InputSource])
                    
                    }
                }
                
            }} , withCancel: nil)
        
        
    }
        
    
    
    func fetchData () {
        
        print("vgv", barname)
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("BarInfo").child("\(barname)").observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bar = BarInfos(dictionary: dictionary)
                
                self.bars.append(bar)

            }} , withCancel: nil)
        
    }
    

        
    // Pulley
        
        
        func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
            return 102.0
        }
        
        func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
            return 340.0
        }
        
        func supportedDrawerPositions() -> [PulleyPosition] {
            return PulleyPosition.all
        }
        
    
    
    
}
