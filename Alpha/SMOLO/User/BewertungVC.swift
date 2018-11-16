////
////  BewertungVC.swift
////  SMOLO
////
////  Created by Alper Maraz on 09.11.18.
////  Copyright © 2018 AM. All rights reserved.
////
//
//
//  MeineBestellungVC.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 19.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit
import Firebase


class BewertungVC: UIViewController/*, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate*/{

    
    var bestelltebar = " "
    var Bestellungen = [KellnerTVSection]()

    
    
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
        
    }


    // VARS
    var letzteBestellungZeit = Double()
    var userUid = String()

    var bestellungIDs = [String]()
    var BestellungKategorien = [String]()
    var BestellungUnterkategorien =  [[String]]()
    var BestellungExpanded2 = [[Bool]]()
    var Status =  String()

    var BestellungItemsNamen =  [[[String]]]()
    
    var Angenommen = [String: String]()
    var FromUserID = [String: String]()
    var TimeStamp = [String: Double]()
    var extrasString = [String]()
    var extrasPreis = [Double]()

    var KellnerID = String()
    
    var BewUKat = [String]()
    var BewKat = [String]()
    var MatchUKat = [String]()
    var MatchKat = [String]()
    var katcounter = 0
    var fetchcounter = 0
    // OUTLETS

    @IBOutlet weak var BewertungTV: UITableView!

    // ACTIONS

    func fetchUnterkategorie(){
        fetchcounter = 0
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Speisekarten").child(bestelltebar).observe(.childAdded, with: { (snapshot) in
            if let uSnapshots = snapshot.value as? [String: AnyObject]{
                for uSnapshot in uSnapshots{
                    self.fetchcounter += 1
                   
                    if let bewertungValue = uSnapshot.value as? [String: AnyObject]{
                        for bewertbar in bewertungValue {
                            if bewertbar.key == "Bewertbar" {
                                if let bewertbarvalue = bewertbar.value as? Bool {
                                    var bewertbarVar = bewertbarvalue
                                    if bewertbarVar == true {
                                        self.BewUKat.append(uSnapshot.key)
                                        self.BewKat.append(snapshot.key)
                                        print(self.BewUKat, "count1")
                                        print(snapshot.key , "1")
                                        print(uSnapshots.keys , "2")
                                        self.searchformatch()

                                    }
                                }
                            }
                        }
                    }
                }
            }
        }, withCancel: nil)
    }
    
    func searchformatch (){
        katcounter = Bestellungen[0].Unterkategorie.count
        print (Bestellungen[0].Unterkategorie, "ich wurde geprinted")
        print(BewUKat, "bewukat")
        
        for kat in Bestellungen[0].Kategorie{
            
           
            if BewKat.contains(kat){
                if MatchKat.contains(kat){}else {
                    MatchKat.append(kat)
                    print(MatchKat, "matchKAT")
                    for ukat in Bestellungen[0].Unterkategorie{
                        katcounter -= 1

                        for i in ukat {
                            if BewUKat.contains(i) {
                                if MatchUKat.contains(i){
                                    print("hier geh ich rein")
                                   
                                }else{
                                    MatchUKat.append(i)
                                    print(MatchUKat, "matchUKAT")
                                    if katcounter == 0{
                                        self.prepareVote()
                                        print("now i vote")
                                        
                                    }
                                }
                            }
                        }
                    
                    }
                }
            }
        }
       
    }
   
    
    func prepareVote (){
        
        for a in MatchKat{
        var x = Bestellungen[0].Kategorie.index(of: a)
            for c in MatchUKat{
            var b = Bestellungen[0].Unterkategorie[x!].index(of: c)
                var items = Bestellungen[0].items[x!]
                print(items, b ?? "hier soll b sein", "hallo")
                for item in items[b!] {

                    print(item , "DIE NAMEN ?!")
                
            }
            }
        }
        }

//
//    func setSectionsKellnerBestellung(BestellungID: String, tischnummer: String, fromUserID: String, TimeStamp: Double, Kategorie: [String], Unterkategorie: [[String]], items: [[[String]]], preis: [[[Double]]], liter: [[[String]]], extras: [[[[String]]]], extrasPreis: [[[[Double]]]], kommentar: [[[String]]], menge: [[[Int]]], expanded2: [[Bool]], expanded: Bool){
//        self.Bestellungen.append(KellnerTVSection(BestellungID: BestellungID, tischnummer: tischnummer, fromUserID: fromUserID, timeStamp: TimeStamp, Kategorie: Kategorie, Unterkategorie: Unterkategorie, items: items, preis: preis, liter: liter, extras: extras, extrasPreis: extrasPreis, kommentar: kommentar, menge: menge, expanded2: expanded2, expanded: expanded))
//        self.BewertungTV.reloadData()
//    }
//
//
//
//    // TABLE
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.Bestellungen.count
//
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        var heightForHeaderInSection: Int?
//
//        heightForHeaderInSection = 36
//        return CGFloat(heightForHeaderInSection!)
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//
//
//        if (Bestellungen[indexPath.section].expanded) {
//            let kategorieCount = Bestellungen[indexPath.section].Kategorie.count
//            var UnterkategorieCount = 0
//            var itemsCount = 0
//            for items in  Bestellungen[indexPath.section].items {
//                for item in items {
//                    itemsCount = itemsCount + item.count
//                }
//            }
//            for unterkategorie in Bestellungen[indexPath.section].Unterkategorie {
//                UnterkategorieCount = UnterkategorieCount + unterkategorie.count
//
//            }
//            print(itemsCount, "itemscount")
//            print(kategorieCount, "kategorieCount")
//            print(UnterkategorieCount, "UnterkategorieCount")
//            return CGFloat(kategorieCount*40 + UnterkategorieCount*50 + itemsCount*86+50)
//
//
//        }
//        else {
//            return 0
//        }
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//
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
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//
//        let header = ExpandableHeaderView()
//        header.contentView.layer.cornerRadius = 10
//        header.contentView.layer.backgroundColor = UIColor.clear.cgColor
//        header.layer.cornerRadius = 10
//        header.layer.backgroundColor = UIColor.clear.cgColor
//
//        header.customInit(tableView: tableView, title: Bestellungen[section].Tischnummer, section: section, delegate: self as! ExpandableHeaderViewDelegate)
//        return header
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = Bundle.main.loadNibNamed("KellnerCell", owner: self, options: nil)?.first as! KellnerCell
//        print(Bestellungen, "Bestellungen")
//        cell.Bestellungen = Bestellungen
//        cell.Cell1Section = indexPath.section
//        cell.bestellungID = Bestellungen[indexPath.section].BestellungID
//        cell.annehmen.setTitle("Status: \(Status[Bestellungen[indexPath.section].BestellungID]!)", for: .normal)
//
//        if Status[Bestellungen[indexPath.section].BestellungID] != "versendet" {
//            cell.annehmen.backgroundColor = UIColor.green
//        } else {
//            cell.annehmen.backgroundColor = UIColor.gray
//        }
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        let DayOne = formatter.date(from: "2018/05/15 12:00")
//        let timeStampDate = NSDate(timeInterval: self.Bestellungen[indexPath.section].TimeStamp, since: DayOne!)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//
//        cell.timeLbl.text = "\(dateFormatter.string(from: timeStampDate as Date)) Uhr"
//        return cell
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(Auth.auth().currentUser?.uid ?? "keineuid")
//        userUid = (Auth.auth().currentUser?.uid)!
//        loadAktuelleBar()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)
        fetchUnterkategorie()

    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//    /*
//     // MARK: - Navigation
//
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//     }
//     */

}

