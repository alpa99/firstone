//
//  BestellungVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 22.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import Pulley

class BestellungVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate, PulleyDrawerViewControllerDelegate, BestellenCellDelegate {

    // VARS

    private var selectedItems = [String]()
    var barname = ""
    
    var bestellungsText = "noch keine Bestellung"
    
    var bars = [BarInfos]()
    var adresse = String ()
    
    var shishas = [String]()
    var shishasPreise = [Int]()
    var getränke = [String]()
    var getränkePreise = [Int]()
    var sections = [ExpandTVSection]()
    
    var count = 0
    var cellIndexPathSection = 0
    var cellIndexPathRow = 0
    var i = Int()
    
    var bestellteShishas  = [String: Int]()
    var bestellteGetränke  = [String: Int]()
    
    var effect: UIVisualEffect!

    
    @IBOutlet weak var label: UILabel!

    
    // OUTLETS
    
    @IBOutlet var bestellungVCView: UIView!
    
    @IBOutlet var addItemView: UIView!
    @IBOutlet weak var itemNameLbl: UILabel!

    @IBOutlet weak var itemCountLbl: UILabel!
    
    
    @IBOutlet weak var bestellungTextfield: UITextView!
    @IBOutlet weak var bestellungTableView: UITableView!

    

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var dismissPopUp: UIButton!
    
    // ACTIONS
    
    
    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
    }


    @IBAction func Back(_ sender: Any) {
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
        let drawervc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerVC") as! DrawerVC
        
        
        
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: drawervc, animated: true)
    }
    
    @IBAction func sendToFirebase(_ sender: Any) {
        handleBestellung()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showBarDetail" {
//            let KVC = segue.destination as! DetailVC
//            KVC.barname = barname
//
//        }
//    }
//
    @IBAction func bardetail(_ sender: UIButton) {
        
        (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
        let detvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        detvc.barname = barname
        
        
        
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: detvc, animated: true)
        //segueToKellnerVC()
    }
    
//    func segueToKellnerVC(){
//        performSegue(withIdentifier: "showBarDetail", sender: self)
//
//    }
    
    
//    @IBAction func swiperight(_ sender: UISwipeGestureRecognizer) {
//        segueToKellnerVC()
//
//    }
    
    

    // FUNCTIONS
    func fetchSpeisekarte(){
        var z = [String: Int]()
        var datref: DatabaseReference!
        datref = Database.database().reference()
        
        datref.child("Speisekarten").child("\(self.barname)").observe(.childAdded, with: { (snapshot) in
            
            z.updateValue(Int(snapshot.childrenCount), forKey: snapshot.key)
            print(z, "AFDSFSDF")
            
            
            datref.child("Speisekarten").child("\(self.barname)").child("Shishas").observe(.childAdded, with: { (snapshot) in
                self.label.text = self.barname
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let shisha = SpeisekarteInfos(dictionary: dictionary)
                    self.shishas.append(shisha.Name!)
                    self.shishasPreise.append(shisha.Preis!)
                    
                    
                }
                if self.shishas.count == z["Shishas"]{
                    self.setSections(genre: "Shishas", items: self.shishas, preise: self.shishasPreise)
                }
                
            }, withCancel: nil)
            
            datref.child("Speisekarten").child("\(self.barname)").child("Getränke").observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let getränk = SpeisekarteInfos(dictionary: dictionary)
                    self.getränke.append(getränk.Name!)
                    self.getränkePreise.append(getränk.Preis!)
                }
                if self.getränke.count == z["Getränke"]{
                    self.setSections(genre: "Getränke", items: self.getränke, preise: self.getränkePreise)
                }
                
            }, withCancel: nil)
            
            
        }, withCancel: nil)
        
        
    }
    
    
//
//    func cellItemBtnTapped(sender: BestellenCell) {
//
//
//        let indexPath = self.bestellungTableView.indexPathForRow(at: sender.center)!
//        let selectedItems = "\(sections[indexPath.section].items[indexPath.row])"
//        let cell = bestellungTableView.cellForRow(at: indexPath) as! BestellenCell
//        if count > 0 && cell.countLbl.text != "Count"{
//            if indexPath.section == 0{
//        bestellteShishas.updateValue(Int(cell.countLbl.text!)!, forKey: selectedItems)
//            } else {
//
//                bestellteGetränke.updateValue(Int(cell.countLbl.text!)!, forKey: selectedItems)
//
//            }
//        } else {
//
//            print("Bitte Stückzahl auswählen")
//        }
//        print(bestellteGetränke, "getränke")
//        print(bestellteShishas, "shishas")
//
//        bestellungTextfield.text = bestellteShishas.description + bestellteGetränke.description
//
//    }
    
    func cellItemAddTapped(sender: BestellenCell){
        i = 0
        itemCountLbl.text = "\(i)"
        let indexPath = self.bestellungTableView.indexPathForRow(at: sender.center)!
        cellIndexPathRow = indexPath.row
        cellIndexPathSection = indexPath.section
        animateIn()
        
    }
    

    @IBAction func funcItemPlusTapped(_ sender: Any) {
        i = i+1
        itemCountLbl.text = "\(i)"
        
    }
    
    @IBAction func funcItemMinusTapped(_ sender: Any) {
        if i > 0{
        i = i-1
            itemCountLbl.text = "\(i)" }

    }
    
    
    
    func handleBestellung(){
        
        var ref: DatabaseReference!

        if bestellungTextfield.text != nil{
            let timestamp = Double(NSDate().timeIntervalSince1970)
            let values = ["shishas": bestellteShishas, "getränke": bestellteGetränke, "toKellnerID": "Kellner1", "tischnummer": "3", "fromUserID": FBSDKAccessToken.current().userID, "timeStamp": timestamp] as [String : Any]
            
            ref = Database.database().reference().child("Users").child("\(FBSDKAccessToken.current().userID!)").child("Bestellungen")
            let childReff = ref?.childByAutoId()
            ref = Database.database().reference().child("Bestellungen")
            let childRef = ref?.childByAutoId()
            if bestellteGetränke.count != 0 || bestellteShishas.count != 0{
            childReff?.updateChildValues(values)
            childRef?.updateChildValues(values)
                print(Date(timeIntervalSince1970: timestamp)) }
            else {
                let alert = UIAlertController(title: "Deine Bestellung ist leer", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func animateIn(){
        itemNameLbl.text = "\(sections[cellIndexPathSection].items[cellIndexPathRow])"
        self.view.addSubview(addItemView)
        addItemView.center = self.view.center
        addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addItemView.alpha = 0
        UIView.animate(withDuration: 1) {
            self.visualEffectView.isHidden = false

            self.visualEffectView.effect = self.effect

            self.addItemView.alpha = 1
            self.addItemView.transform = CGAffineTransform.identity
        }
        
    }
    
    func animateOut(){
    
        UIView.animate(withDuration: 0.5, animations: {
            self.addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addItemView.alpha = 0
            self.visualEffectView.effect = nil

        }){ (success:Bool) in
        self.addItemView.removeFromSuperview()
            self.visualEffectView.isHidden = true

        }
        
        if i > 0 && cellIndexPathSection == 0 {
            bestellteShishas.updateValue(i, forKey: itemNameLbl.text!)
        } else if i > 0 && cellIndexPathSection == 1 {
            bestellteGetränke.updateValue(i, forKey: itemNameLbl.text!)
        } else if i == 0{
            bestellteGetränke.removeValue(forKey: itemNameLbl.text!)
            bestellteShishas.removeValue(forKey: itemNameLbl.text!)
            
        }
        bestellungTextfield.text = "\(bestellteShishas) \(bestellteGetränke)"
        
//        visualEffectView.isHidden = true
        
    }
    
    

    // PULLEY
    
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 102.0
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 340.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
    
    


    // TABLEVIEW FUNCTIONS
    
    func setSections(genre: String, items: [String], preise: [Int]){
        self.sections.append(ExpandTVSection(genre: genre, items: items, preise: preise, expanded: false))
        self.bestellungTableView.reloadData()
    }
  


    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (sections[indexPath.section].expanded){
            return 71
        }
        else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections[section].genre, section: section, delegate: self as ExpandableHeaderViewDelegate)
        return header
    }
    
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("BestellenCell", owner: self, options: nil)?.first as! BestellenCell
        cell.delegate = self
        if (sections[indexPath.section].expanded){
            cell.itemNameLbl.text = "\(sections[indexPath.section].items[indexPath.row])"
            cell.itemPreisLbl.text = "\(sections[indexPath.section].preise[indexPath.row]) €"
        }
        else {
            cell.itemNameLbl.isHidden = true
            cell.itemPreisLbl.isHidden = true
            cell.itemAddBtn.isHidden = true
        }
   
        return cell
    }
    
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        bestellungTableView.beginUpdates()
        for i in 0..<sections[section].items.count{
            bestellungTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        bestellungTableView.endUpdates()
        
    }

    // OTHERS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effect = visualEffectView.effect
//        visualEffectView.isHidden = true
        visualEffectView.effect = nil
        visualEffectView.isHidden = true

        addItemView.layer.cornerRadius = 5
        
        fetchSpeisekarte()
        bestellungTextfield.text = bestellungsText
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}



