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
    var sdWebImageSource2 = [SDWebImageSource]()

    let sdWebImageSource = [SDWebImageSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080"), SDWebImageSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080"), SDWebImageSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")]

    func getParentPageViewController(parentRef: PageViewController) {
        parentPageViewController = parentRef
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.barname = parentPageViewController.name
//        fetchPicsCount2()
        fetchPicsCount()
//        fetchpics()
        fetchData()
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 0.0
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
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
        
     // performSegue(withIdentifier: "drawervc", sender: self)
    }
    
//    func fetchPicsCount2(){
//        var refd: DatabaseReference!
//        refd = Database.database().reference()
//        refd.child("BarInfo").child("\(barname)").child("Bilder").observe(.value, with: { (snapshot) in
//            print(snapshot.childrenCount, "SNAPZZZZ")
////            if let dictionary = snapshot.value as? [String: AnyObject]{
////                let counter = Bilder(dictionary: dictionary)
////                    self.counterlink.append(counter.link!)
////
////                print(self.counterlink.count, "COUNTERLINK")
////                //                print(bild, "bild")
////                //                self.bilder.append(bild.link!)
////
////
////            }
//
//        } , withCancel: nil)
//    }
    
    
    
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

                    self.sdWebImageSource2.append(SDWebImageSource(urlString: links)!)

                    self.slideshow.setImageInputs(self.sdWebImageSource2 as [InputSource])
                    
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

                let storageRef = Storage.storage().reference(forURL: "\(self.picture)")
                
//                storageRef.downloadURL(completion: {(url, error) in
//
//                    if error != nil {
//                        print(error?.localizedDescription ?? "error")
//                        return
//                    }
//
//                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//
//                        if error != nil {
//                            print(error ?? "error")
//                            return
//                        }
//
//                        guard let imageData = UIImage(data: data!) else { return }
//
//                        DispatchQueue.main.async {
//                            self.image.image = imageData
//                        }
//
//                }).resume()
//                })
                


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
