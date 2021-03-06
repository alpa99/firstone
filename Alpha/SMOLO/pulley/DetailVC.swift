//
//  DetailVC.swift
//  SMOLO
//
//  Created by Alper Maraz on 15.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Pulley
import Firebase
import ImageSlideshow
import CoreLocation

class DetailVC: UIViewController, PulleyDrawerViewControllerDelegate, PageObservation, CLLocationManagerDelegate{
    
    
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
    var telnummer = String()
    

    func getParentPageViewController(parentRef: PageViewController) {
        parentPageViewController = parentRef
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topstack.spacing = (self.view.frame.width - CGFloat(236.0))/CGFloat(4.0)
        self.bottomstack.spacing = (self.view.frame.width - CGFloat(236.0))/CGFloat(4.0)

        
        self.adressebtn.setTitle(adresse, for: .normal)

        self.barname = parentPageViewController.name
        fetchPicsCount()
        fetchData()
        fetchInfos()
        fetchText()
        fetchTimes()
        slideshow.backgroundColor = UIColor.clear

        slideshow.slideshowInterval = 0.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor(red: 185.0/255.0, green: 170.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        pageControl.pageIndicatorTintColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.0)
        slideshow.pageIndicator = pageControl
        
        
        slideshow.contentScaleMode = UIView.ContentMode.scaleAspectFill
        
       
        print(sdWebImageSource, "source111")
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DetailVC.didTap))
        slideshow.addGestureRecognizer(recognizer)
        
        self.icon1.image = #imageLiteral(resourceName: "alkohol")
        self.icon2.image = #imageLiteral(resourceName: "essen")
        self.icon3.image = #imageLiteral(resourceName: "wlan")
        self.icon4.image = #imageLiteral(resourceName: "parken")
        self.icon5.image = UIImage(named: "kartenzahlung")
        self.icon6.image = #imageLiteral(resourceName: "spiele")
        self.icon7.image = #imageLiteral(resourceName: "sporttv")
        self.icon8.image = #imageLiteral(resourceName: "shisha")
        self.icon9.image = UIImage(named: "rauchen")
        self.icon10.image = #imageLiteral(resourceName: "terasse")
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
    
    @IBAction func adresseclick(_ sender: UIButton) {
        
        parentPageViewController.pos1()
        
    
        CLGeocoder().geocodeAddressString(self.adresse, completionHandler: { (placemarks, error) -> Void in
            
            if let placemark = placemarks?[0] {
                let location = placemark.location!
                print("location", location)
                ((self.parent?.parent as? PulleyViewController)?.primaryContentViewController as? LocationVC)?.centerMapOnPin(selectedPin: location)
            }})


        
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
    
    
    @IBOutlet weak var Montag: UILabel!
    @IBOutlet weak var Dienstag: UILabel!
    @IBOutlet weak var Mittwoch: UILabel!
    @IBOutlet weak var Donnerstag: UILabel!
    @IBOutlet weak var Freitag: UILabel!
    @IBOutlet weak var Samstag: UILabel!
    @IBOutlet weak var Sonntag: UILabel!
    
    @IBOutlet weak var maintxt: UILabel!
    
    @IBOutlet weak var adressebtn: UIButton!
    
    @IBOutlet weak var tel: UIButton!
    
    @IBOutlet weak var topstack: UIStackView!
    
    @IBOutlet weak var bottomstack: UIStackView!
    
   
    @IBAction func telcall(_ sender: Any) {

        telnummer.makeAColl()
    }
    
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
        
        var ref: DatabaseReference!
        self.Namelbl.text = self.barname
        ref = Database.database().reference()
        ref.child("BarInfo").child("\(barname)").observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bar = BarInfos(dictionary: dictionary)
                
                self.bars.append(bar)
                self.adressebtn.setTitle(bar.Adresse, for: .normal)
                self.tel.setTitle(bar.telnum, for: .normal)
                self.adresse = bar.Adresse!
                self.telnummer = bar.telnum!
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
        
        print("INFOS", barname)
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        ref.child("BarInfo").child("\(barname)").child("Items").observe(.value, with: {  (snapshot) in
            
        if let dictionary = snapshot.value as? [String: AnyObject]{
            let it = BarItems(dictionary: dictionary)
            
            self.it1.append(it.item1!)
            if self.it1 == "t" {
                self.icon10.alpha = 1.0
            }
            if self.it1 == "f" {
                self.icon10.alpha = 0.2
            }
            self.it2.append(it.item2!)
            if self.it2 == "t" {
                self.icon10.alpha = 1.0
            }
            if self.it2 == "f" {
                self.icon10.alpha = 0.2
            }
            self.it3.append(it.item3!)
            if self.it3 == "t" {
                self.icon10.alpha = 1.0
            }
            if self.it3 == "f" {
                self.icon10.alpha = 0.2
            }
            self.it4.append(it.item4!)
            if self.it4 == "t" {
                self.icon4.alpha = 1.0
            }
            if self.it4 == "f" {
                self.icon4.alpha = 0.2
            }
            self.it5.append(it.item5!)
            if self.it5 == "t" {
                self.icon10.alpha = 1.0
            }
            if self.it5 == "f" {
                self.icon10.alpha = 0.2
            }
            self.it6.append(it.item6!)
            if self.it6 == "t" {
                self.icon10.alpha = 1.0
            }
            if self.it6 == "f" {
                self.icon10.alpha = 0.2
            }
            self.it7.append(it.item7!)
            if self.it7 == "t" {
                self.icon10.alpha = 1.0
            }
            if self.it7 == "f" {
                self.icon10.alpha = 0.2
            }
            self.it8.append(it.item8!)
            if self.it8 == "t" {
                self.icon10.alpha = 1.0
            }
            if self.it8 == "f" {
                self.icon10.alpha = 0.2
            }
            self.it9.append(it.item9!)
            if self.it9 == "t" {
                self.icon9.alpha = 1.0
            }
            if self.it9 == "f" {
                self.icon9.alpha = 0.2
            }
            self.it10.append(it.item10!)
            if self.it10 == "t" {
                self.icon10.alpha = 1.0
            }
            if self.it10 == "f" {
                self.icon10.alpha = 0.2
            }
            
        }}, withCancel: nil)
    }
        
    // Pulley
        
        
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
extension String {
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func makeAColl() {
        if isValid(regex: .phone) {
            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
