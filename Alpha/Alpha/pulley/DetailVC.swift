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
    var items = [BarItems]()
    var counterlink = [String]()
    var maintext = String ()
    
    var it1 = String ()
    var it2 = String ()
    var it3 = String ()
    var it4 = String ()
    var it5 = String ()
    var it6 = String ()
    var it7 = String ()
    var it8 = String ()
    var it9 = String ()
    var it10 = String ()

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
        fetchPicsCount()
        fetchData()
        fetchInfos()
        fetchText()
        slideshow.backgroundColor = UIColor.white
 
        slideshow.slideshowInterval = 0.0
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor(red: 185.0/255.0, green: 170.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        slideshow.pageControl.pageIndicatorTintColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.0)
   
        
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
       
        print(sdWebImageSource, "source111")
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
    
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var icon3: UIImageView!
    @IBOutlet weak var icon4: UIImageView!
    @IBOutlet weak var icon5: UIImageView!
    @IBOutlet weak var icon6: UIImageView!
    @IBOutlet weak var icon7: UIImageView!
    @IBOutlet weak var icon8: UIImageView!
    @IBOutlet weak var icon9: UIImageView!
    @IBOutlet weak var icon10: UIImageView!
    
    @IBOutlet weak var maintxt: UILabel!
    
    func fetchText () {
        print("fetchtext")
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("BarInfo").child("\(barname)").observe(.value, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bar = BarInfos(dictionary: dictionary)
                self.maintext.append(bar.Text!)
                self.maintxt.text = self.maintext
            }} , withCancel: nil)
        
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
        self.Namelbl.text = self.barname
        ref = Database.database().reference()
        ref.child("BarInfo").child("\(barname)").observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bar = BarInfos(dictionary: dictionary)
                
                self.bars.append(bar)
                self.picture.append(bar.Bild!)
                print(self.picture)

            }} , withCancel: nil)
        
    }
    
    func fetchInfos () {
        
        print("INFOS", barname)
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        ref.child("BarInfo").child("\(barname)").child("Items").observe(.value, with: {  (snapshot) in
            
        if let dictionary = snapshot.value as? [String: AnyObject]{
            let it = BarItems(dictionary: dictionary)
            
            self.it1.append(it.item1!)
            if self.it1 == "t" {
                self.icon1.image = #imageLiteral(resourceName: "Tabrechts")
            }
            if self.it1 == "f" {
                self.icon1.image = #imageLiteral(resourceName: "Tablinks")
            }
            self.it2.append(it.item2!)
            if self.it2 == "t" {
                self.icon2.image = #imageLiteral(resourceName: "Tabrechts")
            }
            if self.it2 == "f" {
                self.icon2.image = #imageLiteral(resourceName: "Tablinks")
            }
            self.it3.append(it.item3!)
            if self.it3 == "t" {
                self.icon3.image = #imageLiteral(resourceName: "Tabrechts")
            }
            if self.it3 == "f" {
                self.icon3.image = #imageLiteral(resourceName: "Tablinks")
            }
            self.it4.append(it.item4!)
            if self.it4 == "t" {
                self.icon4.image = #imageLiteral(resourceName: "Tabrechts")
            }
            if self.it4 == "f" {
                self.icon4.image = #imageLiteral(resourceName: "Tablinks")
            }
            self.it5.append(it.item5!)
            if self.it5 == "t" {
                self.icon5.image = #imageLiteral(resourceName: "Tabrechts")
            }
            if self.it5 == "f" {
                self.icon5.image = #imageLiteral(resourceName: "Tablinks")
            }
            self.it6.append(it.item6!)
            if self.it6 == "t" {
                self.icon6.image = #imageLiteral(resourceName: "Tabrechts")
            }
            if self.it6 == "f" {
                self.icon6.image = #imageLiteral(resourceName: "Tablinks")
            }
            self.it7.append(it.item7!)
            if self.it7 == "t" {
                self.icon7.image = #imageLiteral(resourceName: "Tabrechts")
            }
            if self.it7 == "f" {
                self.icon7.image = #imageLiteral(resourceName: "Tablinks")
            }
            self.it8.append(it.item8!)
            if self.it8 == "t" {
                self.icon8.image = #imageLiteral(resourceName: "Tabrechts")
            }
            if self.it8 == "f" {
                self.icon8.image = #imageLiteral(resourceName: "Tablinks")
            }
            self.it9.append(it.item9!)
            if self.it9 == "t" {
                self.icon9.image = #imageLiteral(resourceName: "Tabrechts")
            }
            if self.it9 == "f" {
                self.icon9.image = #imageLiteral(resourceName: "Tablinks")
            }
            self.it10.append(it.item10!)
            if self.it10 == "t" {
                self.icon10.image = #imageLiteral(resourceName: "Tabrechts")
            }
            if self.it10 == "f" {
                self.icon10.image = #imageLiteral(resourceName: "Tablinks")
            }
            
        }}, withCancel: nil)
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
