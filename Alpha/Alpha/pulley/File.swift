////
////  File.swift
////  Alpha
////
////  Created by Ibrahim Akcam on 20.03.18.
////  Copyright © 2018 AM. All rights reserved.
////
//
//import Foundation
////
////  SpeisekarteVC.swift
////  Alpha
////
////  Created by Ibrahim Akcam on 16.11.17.
////  Copyright © 2017 AM. All rights reserved.
////
//
//import UIKit
//
//import Pulley
//import Firebase
//import FirebaseAuth
//import CoreLocation
//
////class SpeisekarteVC: UIViewController, UITableViewDataSource, UITableViewDelegate, PulleyDrawerViewControllerDelegate, ExpandableHeaderViewDelegate, PageObservation, BestellenCellDelegate {
////
////
//
//
//
//    var keys = [String: Int]()
//    var bestellteItemsDictionary = [String: [String: Int]]()
//    var yy = [String]()
//    var genres = [String]()
//    var itemss = [String]()
//    var values = [Int]()
//
//
//    var parentPageViewController: PageViewController!
//
//    var barname = " "
//    var baradresse = " "
//
//
//    var items = [String]()
//    var itemsPreise = [Int]()
//
//    var sections = [ExpandTVSection]()
//
//    var cellIndexPathSection = 0
//    var cellIndexPathRow = 0
//    var i = Int()
//
//    var bestellung = [ExpandTVSection]()
//
//
//
//
//
//    // OUTLETS
//
//    @IBOutlet var SpeiseVCView: UIView!
//
//
//    @IBOutlet weak var SpeisekarteTableView: UITableView!
//
//    @IBAction func Backbtn(_ sender: UIButton) {
//        parentPageViewController.goback()
//
//        // performSegue(withIdentifier: "drawervc", sender: self)
//    }
//
//
//    // FUNCTIONS
//
//    func cellItemAddTapped(sender: BestellenCell) {
//
//    }
//
//    func getKategorien (){
//        var datref: DatabaseReference!
//        datref = Database.database().reference()
//
//        datref.child("Speisekarten").child("\(self.barname)").observe(.value, with: { (snapshotKategorie) in
//
//
//            // Anzahl Kategorien: Shishas, Getränke
//            self.getUnterkategorien(kategorieInt: Int(snapshotKategorie.childrenCount))
//            print(snapshotKategorie, "1")
//
//
//        }, withCancel: nil)
//
//    }
//
//    // Softdrinks, Classics
//    func getUnterkategorien(kategorieInt: Int){
//
//        var datref: DatabaseReference!
//        datref = Database.database().reference()
//        datref.child("Speisekarten").child("\(self.barname)").observe(.childAdded, with: { (snapshotUnterkategorie) in
//
//            self.getUnterKategorienItems(Kategorie: snapshotUnterkategorie.key)
//            //                self.keys.updateValue(Int(snapshotKey.childrenCount), forKey: snapshotKey.key)
//            //                print(self.keys, "KEYS")
//            //                print(snapshotKey, "2")
//            //                if self.keys.count == kategorieInt {
//            //                    for (key, value) in self.keys {
//            //                        self.fetchSpeisekarte(ii: key, z: value)
//            //                    }
//            //                }
//        }, withCancel: nil)
//
//    }
//
//    func getUnterKategorienItems(Kategorie: String){
//
//        var datref: DatabaseReference!
//        datref = Database.database().reference()
//        datref.child("Speisekarten").child("\(self.barname)").child(Kategorie).observe(.childAdded, with: { (snapshotUnterkategorieItem) in
//
//            print(snapshotUnterkategorieItem, "snapshotUnterkategorieItem")
//            self.fetchSpeisekarte(Kategorie: Kategorie, Unterkategorie: snapshotUnterkategorieItem.key)
//
//
//            //            self.keys.updateValue(Int(snapshotKey.childrenCount), forKey: snapshotKey.key)
//            //            print(self.keys, "KEYS")
//            //            print(snapshotKey, "2")
//            //            if self.keys.count == value {
//            //                for (key, value) in self.keys {
//            //                    self.fetchSpeisekarte(ii: key, z: value)
//            //                }
//            //            }
//        }, withCancel: nil)
//
//
//    }
//
//
//    func fetchSpeisekarte(Kategorie: String, Unterkategorie: String){
//        var datref: DatabaseReference!
//        datref = Database.database().reference()
//
//
//        datref.child("Speisekarten").child("\(self.barname)").child(Kategorie).child(Unterkategorie).observe(.childAdded, with: { (snapshot) in
//            print(snapshot, "GESAMTEKARTE")
//            if let dictionary = snapshot.value as? [String: AnyObject]{
//                let item = SpeisekarteInformation(dictionary: dictionary)
//                print(item.Name!, "NAME")
//                print(item.Preis!, "PREIS")
//                if item.Liter != "Fehler" {
//                    print(item.Liter!, "item.Liter")}
//            }
//
//            //                if let dictionary = snapshot.value as? [String: AnyObject]{
//            //                    let shisha = SpeisekarteInfos(dictionary: dictionary)
//            //
//            //
//            //                    self.items.append(shisha.Name!)
//            //                    self.itemsPreise.append(shisha.Preis!)
//            //
//            //                    if self.items.count == z{
//            //
//            //                        self.setSectionsSpeisekarte(genre: ii, items: self.items, preise: self.itemsPreise)
//            //                        self.items.removeAll()
//            //                        self.itemsPreise.removeAll()
//            //                    }
//            //                }
//        }, withCancel: nil)
//
//    }
//
//
//
//    func getParentPageViewController(parentRef: PageViewController) {
//        parentPageViewController = parentRef
//    }
//
//
//
//    // TABLEVIEW FUNCTIONS
//
//    func setSectionsSpeisekarte(genre: String, items: [String], preise: [Int]){
//        self.sections.append(ExpandTVSection(genre: genre, items: items, preise: preise, expanded: false))
//        self.SpeisekarteTableView.reloadData()
//    }
//
//    func setSectionsBestellung(genre: String, items: [String], preise: [Int]){
//        self.bestellung.append(ExpandTVSection(genre: genre, items: items, preise: preise, expanded: true))
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 4
//        //            if tableView == SpeisekarteTableView {
//        //                return sections.count }
//        //            else {
//        //
//        //                return bestellung.count
//        //            }
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return 2
//        //            if tableView == SpeisekarteTableView {
//        //                return sections[section].items.count }
//        //            else {
//        //
//        //                return bestellung[section].items.count
//        //
//        //            }
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 59
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 15
//
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = UIColor.clear
//        return view
//    }
//
//
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = ExpandableHeaderView()
//        if tableView == SpeisekarteTableView {
//
//            header.customInit(tableView: tableView, title: sections[section].genre, section: section, delegate: self as ExpandableHeaderViewDelegate)
//        } else {
//
//            header.customInit(tableView: tableView, title: bestellung[section].genre, section: section, delegate: self as ExpandableHeaderViewDelegate)
//        }
//
//        return header
//    }
//
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = Bundle.main.loadNibNamed("SpeisekarteCelle", owner: self, options: nil)?.first as! SpeisekarteCelle
//        cell.textLabel?.text = "hi"
//
//        return cell
//
//        //            cell.delegate = self
//        //            cell.backgroundColor = UIColor.clear
//        //
//        //
//        //            if (sections[indexPath.section].expanded){
//        //                cell.itemNameLbl.text = "\(sections[indexPath.section].items[indexPath.row])"
//        //                cell.itemPreisLbl.text = "\(sections[indexPath.section].preise[indexPath.row]) €"
//        //                return cell
//        //
//        //            }
//        //            else {
//        //                cell.itemNameLbl.isHidden = true
//        //                cell.itemPreisLbl.isHidden = true
//        //                cell.itemAddBtn.isHidden = true
//        //                cell.backgroudn2.isHidden = true
//        //                cell.strich.isHidden = true
//        //                cell.liter.isHidden = true
//        //
//        //                return cell
//        //
//        //            }
//
//
//    }
//
//
//
//    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
//        if tableView == SpeisekarteTableView {
//            sections[section].expanded = !sections[section].expanded
//
//            SpeisekarteTableView.beginUpdates()
//            for i in 0..<sections[section].items.count{
//                SpeisekarteTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
//            }
//            SpeisekarteTableView.endUpdates()
//        }
//        else {
//            sections[section].expanded = !sections[section].expanded
//
//        }
//    }
//
//
//
//
//
//
//    // PULLEY
//
//    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
//        return 102.0
//    }
//
//    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
//        return 340.0
//    }
//
//    func supportedDrawerPositions() -> [PulleyPosition] {
//        return PulleyPosition.all
//    }
//
//
//    // OTHERS
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        SpeisekarteTableView.reloadData()
//        self.barname = parentPageViewController.name
//
//        print(self.baradresse, "viewload")
//
//
//        getKategorien()
//
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//
//
//
