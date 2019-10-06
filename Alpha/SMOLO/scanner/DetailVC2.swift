//
//  DetailVC2.swift
//  SMOLO
//
//  Created by Alper Maraz on 15.12.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase
import ImageSlideshow
import CoreLocation

class DetailVC2: UIViewController, PageObservation2, CLLocationManagerDelegate{
    
    //vars
    
    var barname = ""
    var bars = [BarInfos]()
    var adresse = String ()
    var bild = String ()
    var parentPageViewController2: PageViewController2!
    
   
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
    
    var picture = String ()
    var parentPageViewController: PageViewController!
    var sdWebImageSource = [SDWebImageSource]()
    

    //Outlets
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var image: UIImageView!
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
    
    @IBOutlet weak var Montag:    UILabel!
    @IBOutlet weak var Dienstag: UILabel!
    @IBOutlet weak var Mittwoch: UILabel!
    @IBOutlet weak var Donnerstag: UILabel!
    @IBOutlet weak var Freitag: UILabel!
    @IBOutlet weak var Samstag: UILabel!
    @IBOutlet weak var Sonntag: UILabel!
    
    
    @IBOutlet weak var maintxt: UILabel!
    
//    @IBOutlet weak var adressebtn: UIButton!
    
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    @IBOutlet weak var topstack: UIStackView!
    
    @IBOutlet weak var bottomstack: UIStackView!
    
    
    
    
//    @IBAction func adresseclick(_ sender: UIButton) {
//
//        parentPageViewController.pos1()
//
//
//        CLGeocoder().geocodeAddressString(self.adresse, completionHandler: { (placemarks, error) -> Void in
//
//            if let placemark = placemarks?[0] {
//                let location = placemark.location!
//                print("location", location)
//                ((self.parent?.parent as? PulleyViewController)?.primaryContentViewController as? LocationVC)?.centerMapOnPin(selectedPin: location)
//            }})
//
//
//
//    }
    

    
    //Pageviewinit
    func getParentPageViewController2(parentRef2: PageViewController2) {
        parentPageViewController2 = parentRef2
    }

    //ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barname = parentPageViewController2.name
        fetchData()
//        self.adressebtn.setTitle(adresse, for: .normal)
        
        self.topstack.spacing = (self.view.frame.width - CGFloat(236.0))/CGFloat(4.0)
        self.bottomstack.spacing = (self.view.frame.width - CGFloat(236.0))/CGFloat(4.0)
        
        fetchPicsCount()
        fetchInfos()
        fetchText()
        fetchTimes()
        slideshow.backgroundColor = UIColor.white
        
        slideshow.slideshowInterval = 0.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor(red: 185.0/255.0, green: 170.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        pageControl.pageIndicatorTintColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.0)
        slideshow.pageIndicator = pageControl
        
        
        
        slideshow.contentScaleMode = UIView.ContentMode.scaleAspectFill
        
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DetailVC.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
  
    
    func fetchText () {

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
        
        var ref: DatabaseReference!
        self.NameLbl.text = self.barname
        ref = Database.database().reference()
        ref.child("BarInfo").child("\(barname)").observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bar = BarInfos(dictionary: dictionary)
                
                self.bars.append(bar)
                print("Adresse", bar.Adresse ?? "")
//                self.adressebtn.setTitle(bar.Adresse, for: .normal)

//                self.adresse = bar.Adresse!
            }} , withCancel: nil)
        
    }
    
    func fetchTimes () {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("BarInfo").child("\(barname)").child("Öffnungszeiten").observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bar = Oeffnungszeiten(dictionary: dictionary)
                
                self.Montag.text = bar.Montag
                self.Dienstag.text = bar.Dienstag
                self.Mittwoch.text = bar.Mittwoch
                self.Donnerstag.text = bar.Donnerstag
                self.Freitag.text = bar.Freitag
                self.Samstag.text = bar.Samstag
                self.Sonntag.text = bar.Sonntag
                
            }} , withCancel: nil)
        
    }
    
    func fetchInfos () {
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        ref.child("BarInfo").child("\(barname)").child("Items").observe(.value, with: {  (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let it = BarItems(dictionary: dictionary)
                
                self.it1.append(it.item1!)
                if self.it1 == "t" {
                    self.icon1.image = #imageLiteral(resourceName: "alkohol")
                }
                if self.it1 == "f" {
                    self.icon1.image = #imageLiteral(resourceName: "alkohol-i")
                }
                self.it2.append(it.item2!)
                if self.it2 == "t" {
                    self.icon2.image = #imageLiteral(resourceName: "essen")
                }
                if self.it2 == "f" {
                    self.icon2.image = #imageLiteral(resourceName: "essen-i")
                }
                self.it3.append(it.item3!)
                if self.it3 == "t" {
                    self.icon3.image = #imageLiteral(resourceName: "wlan")
                }
                if self.it3 == "f" {
                    self.icon3.image = #imageLiteral(resourceName: "wlan-i")
                }
                self.it4.append(it.item4!)
                if self.it4 == "t" {
                    self.icon4.image = #imageLiteral(resourceName: "parken")
                }
                if self.it4 == "f" {
                    self.icon4.image = #imageLiteral(resourceName: "parken-i")
                }
                self.it5.append(it.item5!)
                if self.it5 == "t" {
                    self.icon5.image = #imageLiteral(resourceName: "kartenzahlung")
                }
                if self.it5 == "f" {
                    self.icon5.image = #imageLiteral(resourceName: "kartenzahlung-i")
                }
                self.it6.append(it.item6!)
                if self.it6 == "t" {
                    self.icon6.image = #imageLiteral(resourceName: "spiele")
                }
                if self.it6 == "f" {
                    self.icon6.image = #imageLiteral(resourceName: "spiele-i")
                }
                self.it7.append(it.item7!)
                if self.it7 == "t" {
                    self.icon7.image = #imageLiteral(resourceName: "sporttv")
                }
                if self.it7 == "f" {
                    self.icon7.image = #imageLiteral(resourceName: "sporttv-i")
                }
                self.it8.append(it.item8!)
                if self.it8 == "t" {
                    self.icon8.image = #imageLiteral(resourceName: "shisha")
                }
                if self.it8 == "f" {
                    self.icon8.image = #imageLiteral(resourceName: "shisha-i")
                }
                self.it9.append(it.item9!)
                if self.it9 == "t" {
                    self.icon9.image = #imageLiteral(resourceName: "rauchen")
                }
                if self.it9 == "f" {
                    self.icon9.image = #imageLiteral(resourceName: "rauchen-i")
                }
                self.it10.append(it.item10!)
                if self.it10 == "t" {
                    self.icon10.image = #imageLiteral(resourceName: "terasse")
                }
                if self.it10 == "f" {
                    self.icon10.image = #imageLiteral(resourceName: "terasse-i")
                }
                
            }}, withCancel: nil)
    }
    
    
    
    

   

}
