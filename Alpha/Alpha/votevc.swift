//
//  votevc.swift
//  Alpha
//
//  Created by Alper Maraz on 17.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase
import Pulley

class votevc: UIViewController, PulleyDrawerViewControllerDelegate {
    
    
    var barname = ""
    var vote = [VoteInfos]()
    var quantity = Double ()
    var quality: Double = 0.0
    
    
   
    
    @IBOutlet weak var shisha1: UILabel!
    
    @IBOutlet weak var shisha2: UILabel!
   
    @IBOutlet weak var Note1: UILabel!
    
    @IBOutlet weak var Note2: UILabel!
    
    
    @IBAction func backbtn(_ sender: UIButton) {
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
        let detvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        detvc.barname = barname
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: detvc, animated: true)
        
    }
    
    @IBAction func shisha1plus(_ sender: UIButton) {
        if quality < 5.0 {
            quality += 0.5
            Note1.text = String(quality)
            
        } else {
            print("beste Note erreicht")
        }
    }
    
    @IBAction func shisha1minus(_ sender: UIButton) {
        if quality > 0.0 {
            quality -= 0.5
            Note1.text = String(quality)
        }else {
            print("schlechteste Note erreicht")
        }
    }
    
  
    @IBAction func shisha2plus(_ sender: UIButton) {
    }
    
    @IBAction func shisha2minus(_ sender: UIButton) {
    }
    
    @IBAction func VoteNow(_ sender: UIButton) {
        handlevote()
    }
    
   //viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Note1.text = ""

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // FUNCTIONS
    
    func handlevote() {
        print("irgendwas")
        if Note1.text != "" {
            print("asdad")
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("BarInfo").child("Barracuda").child("Votes").child("Blaubeere").observe(.value, with: { (snapshot) in
                print(snapshot, "snapshot")
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let vote = VoteInfos(dictionary: dictionary)
                    
                    self.quantity = vote.quantity! + 1.0
                    print(self.quantity, "quantity", self.quality, "quality")
                    
                
                }
            }, withCancel: nil)
            
        }
            
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
