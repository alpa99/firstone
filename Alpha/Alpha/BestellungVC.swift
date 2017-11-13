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
    
    var bestellteShishas  = [String: Int]()
    var bestellteGetränke  = [String: Int]()

    // OUTLETS
    
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var bestellungTextfield: UITextView!
    @IBOutlet weak var bestellungTableView: UITableView!

    
    
    // ACTIONS
    

    @IBAction func Back(_ sender: Any) {
        
        let tableVC:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerVC") as UIViewController
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: tableVC, animated: true)
    }
    
    @IBAction func sendToFirebase(_ sender: Any) {
        handleBestellung()
    }
    
    
    

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
    
    
    
    func cellItemBtnTapped(sender: BestellenCell) {
        let indexPath = self.bestellungTableView.indexPathForRow(at: sender.center)!
        let selectedItems = "\(sections[indexPath.section].items[indexPath.row])"
        let cell = bestellungTableView.cellForRow(at: indexPath) as! BestellenCell
        if count > 0 && cell.countLbl.text != "Count"{
            if indexPath.section == 0{
        bestellteShishas.updateValue(Int(cell.countLbl.text!)!, forKey: selectedItems)
            } else {
                
                bestellteGetränke.updateValue(Int(cell.countLbl.text!)!, forKey: selectedItems)

            }
        } else {
            
            print("Bitte Stückzahl auswählen")
        }
        print(bestellteGetränke, "getränke")
        print(bestellteShishas, "shishas")
    
        bestellungTextfield.text = bestellteShishas.description + bestellteGetränke.description
        
    }
    
    
    func cellMinusBtnTapped(sender: BestellenCell) {
        let indexPath = self.bestellungTableView.indexPathForRow(at: sender.center)!
        
        if cellIndexPathRow == indexPath.row && cellIndexPathSection == indexPath.section {
            count = count-1
        } else {
            count = 0
            cellIndexPathRow = indexPath.row
            cellIndexPathSection = indexPath.section
            count = -1
        }

        let cell = bestellungTableView.cellForRow(at: indexPath) as! BestellenCell
        if count > 0{
            cell.countLbl.text = "\(count)"}
        else {
            cell.countLbl.text = "0"
            
        }
    }
    
    func cellPlusBtnTapped(sender: BestellenCell){
        let indexPath = self.bestellungTableView.indexPathForRow(at: sender.center)!
        
        if cellIndexPathRow == indexPath.row && cellIndexPathSection == indexPath.section {
            count = count+1
        } else {
            count = 0
            cellIndexPathRow = indexPath.row
            cellIndexPathSection = indexPath.section
            count = 1
        }
    
        let cell = bestellungTableView.cellForRow(at: indexPath) as! BestellenCell
        
        if count > 0{
            cell.countLbl.text = "\(count)"}
        else {
            cell.countLbl.text = "0"
            
        }
    }
    
    
    func handleBestellung(){
        
        var ref: DatabaseReference!

        if bestellungTextfield.text != nil{
            let timestamp = Double(NSDate().timeIntervalSince1970)
            let values = ["shishas": "Lemon Fresh", "getränke": "cola", "toKellnerID": "Kellner1", "tischnummer": "3", "fromUserID": FBSDKAccessToken.current().userID, "timeStamp": timestamp] as [String : Any]
            
            ref = Database.database().reference().child("Users").child("\(FBSDKAccessToken.current().userID!)").child("Bestellungen")
            let childReff = ref?.childByAutoId()
            childReff?.updateChildValues(values)
            ref = Database.database().reference().child("Bestellungen")
            let childRef = ref?.childByAutoId()
            childRef?.updateChildValues(values)
            print(Date(timeIntervalSince1970: timestamp))
            
            
            
        }
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
            return 170
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
        cell.shishaNameLbl.text = "\(sections[indexPath.section].items[indexPath.row])"
        cell.shishaPreisLbl.text = "\(sections[indexPath.section].preise[indexPath.row]) €"
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
        fetchSpeisekarte()
        bestellungTextfield.text = bestellungsText
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}



