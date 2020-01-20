//
//  SpeisekarteVC.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 16.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Pulley
import Firebase
import FirebaseAuth
import CoreLocation



class SpeisekarteVC: UIViewController, UITableViewDataSource, UITableViewDelegate, PulleyDrawerViewControllerDelegate, ExpandableHeaderViewDelegate, PageObservation, SpeisekarteDelegate {
    
    func reloadUnterkategorie(sender: SpeisekarteCelle) {
        print("jallladflsdf")
        sections = sender.sections
        SpeisekarteTableView.beginUpdates()
        SpeisekarteTableView.reloadRows(at: [IndexPath(row: 0, section: sender.sectioncell)], with: .automatic)
        SpeisekarteTableView.endUpdates()
    }
    
    
        var parentPageViewController: PageViewController!
    
        var barname = " "
        var baradresse = " "
    
    @IBOutlet weak var barnameLbl: UILabel!
    // TABLEVIEW
        var sections = [ExpandTVSection2]()
        var Kategorien = [String]()
        var Unterkategorien = [String: [String]]()
        var Items = [String: [[String]]]()
        var Preis = [String: [[Double]]]()
        var Liter = [String: [[String]]]()
        var Beschreibung = [String: [[String]]]()
        var Expanded = [String: [Bool]]()

        // OUTLETS
        
        @IBOutlet var SpeiseVCView: UIView!
        @IBOutlet weak var SpeisekarteTableView: UITableView!
        @IBAction func Backbtn(_ sender: UIButton) {
        parentPageViewController.goback()
            }
    
    //Zusatzstoffe
    var stoffanzahl = 1
    var kurzel = [String]()
    var stoffname = [String]()
    @IBOutlet var ZusatzstoffeView: UIView!
    
    @IBOutlet weak var ZusatzstoffeTV: UITableView!
    
    @IBAction func info(_ sender: UIButton) {
        
        ZusatzstoffeTV.backgroundColor = .clear
        self.SpeiseVCView.addSubview(visualeffect)
        visualeffect.center = self.SpeiseVCView.center
        self.SpeiseVCView.addSubview(ZusatzstoffeView)
        ZusatzstoffeView.center = self.SpeiseVCView.center
        ZusatzstoffeView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        ZusatzstoffeView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.visualeffect.effect = self.effect
            self.ZusatzstoffeView.alpha = 1
            self.ZusatzstoffeView.transform = CGAffineTransform.identity
        }}
    
    @IBAction func DismissInfo(_ sender: UIButton) {
       dismissZusatzstoffeVC()
    }
    
    var effect: UIVisualEffect!

    @IBOutlet var visualeffect: UIVisualEffectView!
    
    func dismissZusatzstoffeVC (){
        UIView.animate(withDuration: 0.5, animations: {
            self.ZusatzstoffeView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            self.ZusatzstoffeView.alpha = 0
            self.visualeffect.effect = nil
            }){ (success:Bool) in
            self.ZusatzstoffeView.removeFromSuperview()
            self.visualeffect.removeFromSuperview()
            }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
          
        if touch?.view != ZusatzstoffeView && self.view.subviews.contains(ZusatzstoffeView) {
           dismissZusatzstoffeVC()
        }
    }
    
    func fetchInhalte () {
          print("fetchInhalte")
          var ref: DatabaseReference!
          ref = Database.database().reference()
        ref.child("BarInfo").child("\(barname)").child("Zusatzstoffe").observe(.childAdded, with: { (snapshot) in
            self.kurzel.append(snapshot.key)
            self.stoffname.append(snapshot.value as! String)
          //  print(snapshot.key, "und", snapshot.value!)
              } , withCancel: nil)
      }
    
        // FUNCTIONS
    func getParentPageViewController(parentRef: PageViewController) {
        parentPageViewController = parentRef
    }
    

    func getKategorien (){
            var datref: DatabaseReference!
            datref = Database.database().reference()
        print("HOLLLAA")
        print(self.barname, "barname")

        datref.child("Speisekarten").observeSingleEvent(of: .value, with: { (snapshotKategorie) in
            for key in (snapshotKategorie.children.allObjects as? [DataSnapshot])! {
                print(key, "KEY")
                    }

        }, withCancel: nil)
        datref.child("Speisekarten").child("\(self.barname)").observeSingleEvent(of: .value, with: { (snapshotKategorie) in
            for key in (snapshotKategorie.children.allObjects as? [DataSnapshot])! {
                print(key, "Key")
                print(self.barname, "barname")
                        if !self.Kategorien.contains(key.key) {
                            self.Kategorien.append(key.key)
                            self.getUnterKategorienItems(Kategorie: key.key)
                            print(self.Kategorien, "KARS")
                        }
                    }

        }, withCancel: nil)

        }

    
    func getUnterKategorienItems(Kategorie: String){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Speisekarten").child("\(self.barname)").child(Kategorie).observeSingleEvent(of: .value, with: { (snapshotUnterkategorieItem) in
            
            for key in (snapshotUnterkategorieItem.children.allObjects as? [DataSnapshot])! {
                let snapshotItem = snapshotUnterkategorieItem.childSnapshot(forPath: key.key)
                if key.key != "Extras" {
                if self.Unterkategorien[Kategorie] != nil {
                    self.Unterkategorien[Kategorie]?.append(key.key)
                    self.Expanded[Kategorie]?.append(false)
                    for items in (snapshotItem.children.allObjects as? [DataSnapshot])!{
                        if let dictionary = items.value as? [String: AnyObject]{
                            let item = SpeisekarteInformation(dictionary: dictionary)
                            var newitems = self.Items[Kategorie]
                            var newpreis = self.Preis[Kategorie]
                            var newliter = self.Liter[Kategorie]
                            var newbeschreibung = self.Beschreibung[Kategorie]
                            if (self.Items[Kategorie]?.count)! < (self.Unterkategorien[Kategorie]?.count)! {
                                newitems?.append([item.Name!])
                                newpreis?.append([item.Preis!])
                                newliter?.append([item.Liter!])
                                newbeschreibung?.append([item.Beschreibung!])

                                self.Items[Kategorie] = newitems
                                self.Preis[Kategorie] = newpreis
                                self.Liter[Kategorie] = newliter
                                self.Beschreibung[Kategorie] = newbeschreibung
                            } else {
                                newitems![(self.Unterkategorien[Kategorie]?.firstIndex(of: key.key))!].append(item.Name!)
                                self.Items[Kategorie] = newitems
                                newpreis![(self.Unterkategorien[Kategorie]?.firstIndex(of: key.key))!].append(item.Preis!)
                                self.Preis[Kategorie] = newpreis
                                newliter![(self.Unterkategorien[Kategorie]?.firstIndex(of: key.key))!].append(item.Liter!)
                                self.Liter[Kategorie] = newliter
                                newbeschreibung![(self.Unterkategorien[Kategorie]?.firstIndex(of: key.key))!].append(item.Beschreibung!)
                                self.Beschreibung[Kategorie] = newbeschreibung
                            }
                        }
                    }
                } else {
                    self.Unterkategorien.updateValue([key.key], forKey: Kategorie)
                    self.Expanded.updateValue([false], forKey: Kategorie)
                    for items in (snapshotItem.children.allObjects as? [DataSnapshot])!{
                        if let dictionary = items.value as? [String: AnyObject]{
                            let item = SpeisekarteInformation(dictionary: dictionary)
                            if self.Items[Kategorie] != nil{
                                var newItems = self.Items[Kategorie]
                                    newItems![(self.Unterkategorien[Kategorie]?.firstIndex(of: key.key))!].append(item.Name!)
                                    self.Items[Kategorie] = newItems
                                var newPreis = self.Preis[Kategorie]
                                newPreis![(self.Unterkategorien[Kategorie]?.firstIndex(of: key.key))!].append(item.Preis!)
                                self.Preis[Kategorie] = newPreis
                                var newLiter = self.Liter[Kategorie]
                                newLiter![(self.Unterkategorien[Kategorie]?.firstIndex(of: key.key))!].append(item.Liter!)
                                self.Liter[Kategorie] = newLiter
                                var newBeschreibung = self.Beschreibung[Kategorie]
                                newBeschreibung![(self.Unterkategorien[Kategorie]?.firstIndex(of: key.key))!].append(item.Beschreibung!)
                                self.Beschreibung[Kategorie] = newBeschreibung
                            } else {
                                self.Items.updateValue([[item.Name!]], forKey: Kategorie)
                                self.Preis.updateValue([[item.Preis!]], forKey: Kategorie)
                                self.Liter.updateValue([[item.Liter!]], forKey: Kategorie)
                                self.Beschreibung.updateValue([[item.Beschreibung!]], forKey: Kategorie)
                            }
                        }
                    }
                    }
                    
                }
                else {
                    print(key.key, "EEEEXXXTRAS2")
                }
            }
            if self.Unterkategorien.count == self.Kategorien.count {
                for kategorie in self.Kategorien {
                    self.setSectionsSpeisekarte(Kategorie: kategorie, Unterkategorie: self.Unterkategorien[kategorie]!, items: self.Items[kategorie]!, preis: self.Preis[kategorie]!, liter: self.Liter[kategorie]!, beschreibung: self.Beschreibung[kategorie]!, verfuegbarkeit: [self.Expanded[kategorie]!], expanded2: self.Expanded[kategorie]!)
                }
                
            }
            
        }, withCancel: nil)
    }

        // TABLEVIEW FUNCTIONS
        
    func setSectionsSpeisekarte(Kategorie: String, Unterkategorie: [String], items: [[String]], preis: [[Double]], liter: [[String]], beschreibung: [[String]], verfuegbarkeit: [[Bool]], expanded2: [Bool]){
        self.sections.append(ExpandTVSection2(Kategorie: Kategorie, Unterkategorie: Unterkategorie, items: items, preis: preis, liter: liter, beschreibung: beschreibung, verfuegbarkeit: verfuegbarkeit, expanded2: expanded2, expanded: false))
            self.SpeisekarteTableView.reloadData()
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            var numberOfSections: Int?

            if tableView == ZusatzstoffeTV{
                numberOfSections = 1
            }
            if tableView == SpeisekarteTableView{
                numberOfSections = sections.count }
            return numberOfSections!
        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            var rownumber = 1
            
            if tableView == ZusatzstoffeTV{
                print(kurzel.count, "kurzelzahl")
                rownumber = kurzel.count
            }
            if tableView == SpeisekarteTableView{
                rownumber = 1
            }
            return rownumber
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            var headerheigt = 0
            if tableView == SpeisekarteTableView{
                headerheigt = 36
            }
            if tableView == ZusatzstoffeView{
                headerheigt = 0
            }
            return CGFloat(headerheigt)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            var heightForRowAt: Int?
            if tableView == SpeisekarteTableView{
               if  sections[indexPath.section].Unterkategorie[indexPath.row] == "leer"{
                sections[indexPath.section].expanded2[indexPath.row] = true
                }
                
            if (sections[indexPath.section].expanded) {
                heightForRowAt = (sections[indexPath.section].Unterkategorie.count*60)
                for expandend in sections[indexPath.section].expanded2 {
                    if expandend == true {
                        print("dsfdfd")
    heightForRowAt = heightForRowAt! + sections[indexPath.section].items[indexPath.row].count*36
                    }
                }
                
            }
            else {
                heightForRowAt = 0
                }}else{
                heightForRowAt = 36
            }
            return CGFloat(heightForRowAt!)

        }
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            var heighti: Int?
            if tableView == SpeisekarteTableView{
                heighti = 15
            }
            if tableView == ZusatzstoffeTV{
                heighti = 0
            }
            return CGFloat(heighti!)
            
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let view = UIView()
            view.backgroundColor = UIColor.clear
            return view
        }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.contentView.layer.cornerRadius = 5
        header.contentView.layer.backgroundColor = UIColor.clear.cgColor
        
        header.layer.cornerRadius = 5
        header.layer.backgroundColor = UIColor.clear.cgColor
            header.customInit(tableView: tableView, title: sections[section].Kategorie, section: section, delegate: self as ExpandableHeaderViewDelegate)
        return header
    }
    
        
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == ZusatzstoffeTV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ZusatzstoffCell", for: indexPath)
            cell.backgroundColor = .clear
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 17.0)
            
            print(kurzel, "kurzel")
            
            cell.textLabel?.text = "\(kurzel[indexPath.row]) - \(stoffname[indexPath.row])"
            
            return cell
        }else{
        
        let cell = Bundle.main.loadNibNamed("SpeisekarteCelle", owner: self, options: nil)?.first as! SpeisekarteCelle
        cell.backgroundColor = UIColor.clear
        cell.delegate = self
        cell.sections = sections
        cell.items = sections[indexPath.section].items
        cell.preise = sections[indexPath.section].preis
        cell.liters = sections[indexPath.section].liter
        cell.beschreibungen = sections[indexPath.section].beschreibung
        cell.sectioncell = indexPath.section
        
            return cell}
        
    }

        
        
        func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {

                for i in 0..<sections.count{
                    if i == section {
                        sections[section].expanded = !sections[section].expanded
                    } else {
                        sections[i].expanded = false
                        
                    }
                }
                SpeisekarteTableView.beginUpdates()
                SpeisekarteTableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
                SpeisekarteTableView.endUpdates()
        }
   
    // PULLEY
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 102.0
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 240.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SpeisekarteTableView.reloadData()
        self.barname = parentPageViewController.name
        barnameLbl.text = barname
        ZusatzstoffeView.layer.cornerRadius = 5
        ZusatzstoffeView.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)
        effect = visualeffect.effect
        visualeffect.effect = nil
        visualeffect.bounds = self.SpeiseVCView.bounds
        getKategorien()
        fetchInhalte()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
