//
//  BarDetailVC.swift
//  shisha
//
//  Created by Alper Maraz on 26.07.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Pulley
import Firebase

class BarDetailVC: UIViewController, PulleyDrawerViewControllerDelegate, iCarouselDelegate, iCarouselDataSource {
    
    var barname = ""
    
    var bars = [BarInfos] ()
    
    @IBOutlet weak var LabelName: UILabel!
    
    @IBOutlet weak var carouselView: iCarousel!
    
    var carouselNumbers = [Int]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    
    
    
    @IBAction func BackButton(_ sender: Any) {
        let tableVC:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerContentViewController") as UIViewController
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: tableVC, animated: true)

        
    }
    func collapsedDrawerHeight() -> CGFloat {
        return 102.0
    }
    func partialRevealDrawerHeight() -> CGFloat {
        
        return 340.0
        
        
    }
    func supportedDrawerPositions() -> [PulleyPosition]{
        
        return PulleyPosition.all
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        carouselView.type = .coverFlow2
        
        
    }
    func fetchData(){
        print(barname,12)
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Barliste").child("\(barname)").observe(.value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject]{
                
                let bar = BarInfos(dictionary: dict)
                bar.setValuesForKeys(dict)
                self.bars.append(bar)
                print(self.bars)
                self.LabelName.text = "\(self.barname)"
 
            }
        }
            , withCancel: nil)
    }
    
    
    
    

//     func setupNavigationBar (){
//        let xbar = bars
//        
//        navigationItem.title = xbar.Name
//        //print(xbar.Name!)
//        
//    }
//    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        carouselNumbers = [1,2,3,4]

    }
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return carouselNumbers.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
         let tempView = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 150))
        
        tempView.backgroundColor = UIColor.cyan
            
        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing{
        return value * 1.1
        }
        return value
    }

}

class testseite: UIViewController{
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

}
