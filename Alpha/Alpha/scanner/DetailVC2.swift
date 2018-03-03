//
//  DetailVC2.swift
//  Alpha
//
//  Created by Alper Maraz on 15.12.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit

import Firebase

class DetailVC2: UIViewController, PageObservation2{
    
    //vars
    
    var barname = ""
    var bars = [BarInfos]()
    var adresse = String ()
    var bild = String ()
    var parentPageViewController2: PageViewController2!

    //Outlets
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
    //Pageviewinit
    func getParentPageViewController2(parentRef2: PageViewController2) {
        parentPageViewController2 = parentRef2
    }

    //ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barname = parentPageViewController2.name
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Firebase
    
    func fetchData () {
        
        print("vgv2", barname)
        var ref: DatabaseReference!
//        self.NameLbl.text = self.barname
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
    

   

}
