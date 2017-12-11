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

class DetailVC: UIViewController, PulleyDrawerViewControllerDelegate, PageObservation {
 
    var barname = ""
    var bars = [BarInfos]()
    var adresse = String ()
    var bild = String ()

    var parentPageViewController: PageViewController!
    func getParentPageViewController(parentRef: PageViewController) {
        parentPageViewController = parentRef
    }
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var topbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barname = parentPageViewController.name
        print(barname, "dfjidfjdijfid")
        fetchData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var Namelbl: UILabel!
    
    @IBAction func bestellung(_ sender: UIButton) {(parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
        let speisekartevc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpeisekarteVC") as! SpeisekarteVC
        
        speisekartevc.barname = barname
        
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: speisekartevc, animated: true)
        
        
    }
    
    @IBAction func votefortrump(_ sender: UIButton) {
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
        let votecv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "votevc") as! votevc
        
        votecv.barname = barname
        
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: votecv, animated: true)
    }
    
    @IBAction func Backbtn(_ sender: UIButton) {
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
        let drawervc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerVC") as! DrawerVC
        
        
        
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: drawervc, animated: true)
        
     // performSegue(withIdentifier: "drawervc", sender: self)
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
                self.bild.append(bar.Bild!)
                print(self.bild)

                let storageRef = Storage.storage().reference(forURL: "\(self.bild)")
                
                storageRef.downloadURL(completion: {(url, error) in
                    
                    if error != nil {
                        print(error?.localizedDescription ?? "error")
                        return
                    }
                    
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            print(error ?? "error")
                            return
                        }
                        
                        guard let imageData = UIImage(data: data!) else { return }
                        
                        DispatchQueue.main.async {
                            self.image.image = imageData
                        }
                        
                }).resume()
                })
                


            }} , withCancel: nil)
        
    }
    
    
//    func loadimage(){
//        let url = URL(string: bild)
//        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response,error) in
//
//            if error != nil{
//                print(error ?? "error")
//                return
//            }
    
//
//                self.image.image = UIImage(data: data!)
//
//        }).resume()
//
//    }
    
        
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
