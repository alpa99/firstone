//
//  MeineBestellungVC.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 23.01.19.
//  Copyright © 2019 AM. All rights reserved.
//

import UIKit

class BestellungÜbersichtVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MyBestellungCellDelegate, ExpandableHeaderViewDelegate {
    
    var bestellteItemsDictionary = [bestellungTVSection]()
    var Kategorie = String()
    var Extras = [String: [String]]()
    var ExtrasPreise = [String: [Double]]()
    
    
    var BestellungUnterkategorien = [[String]]()
    var BestellungItemsNamen = [[[String]]]()
    var BestellungItemsPreise = [[[Double]]]()
    var BestellungItemsLiter = [[[String]]]()
    var BestellungItemsKommentar = [[[String]]]()
    var BestellungItemsMengen = [[[Int]]]()
    var BestellungItemsExpanded2 = [[Bool]]()
    var BestellungExtrasName = [[[[String]]]]()
    var BestellungExtrasPreise = [[[[Double]]]]()
    
    
    @IBOutlet weak var uebersichtTV: UITableView!
    
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
        print("BestellungÜbersicht")
        
    }
    
    func passItemEntfernen(sender: MyBestellungCell) {
        print(bestellteItemsDictionary, sender.sections, sender.sections2, sender.rows2, BestellungItemsNamen)
        var itemsInSection = bestellteItemsDictionary[sender.sections].items
        var preisInSection = bestellteItemsDictionary[sender.sections].preis
        var literInSection = bestellteItemsDictionary[sender.sections].liter
        var mengeInSection = bestellteItemsDictionary[sender.sections].menge
        var newitemsInSection = itemsInSection[sender.sections2]
        var newpreisInSection = preisInSection[sender.sections2]
        var newliterInSection = literInSection[sender.sections2]
        var newmengeInSection = mengeInSection[sender.sections2]
        
        newitemsInSection.remove(at: sender.rows2)
        newliterInSection.remove(at: sender.rows2)
        newpreisInSection.remove(at: sender.rows2)
        newmengeInSection.remove(at: sender.rows2)
        
        if newitemsInSection.count != 0{
            
            itemsInSection[sender.sections2] = newitemsInSection
            preisInSection[sender.sections2] = newpreisInSection
            literInSection[sender.sections2] = newliterInSection
            mengeInSection[sender.sections2] = newmengeInSection
            BestellungItemsNamen[sender.sections] = itemsInSection
            BestellungItemsPreise[sender.sections] = preisInSection
            BestellungItemsLiter[sender.sections] = literInSection
            BestellungItemsMengen[sender.sections] = mengeInSection
            bestellteItemsDictionary[sender.sections].items = itemsInSection
            bestellteItemsDictionary[sender.sections].preis = preisInSection
            bestellteItemsDictionary[sender.sections].liter = literInSection
            bestellteItemsDictionary[sender.sections].menge = mengeInSection
            
        }  else {
            
            BestellungItemsNamen[sender.sections].remove(at: sender.sections2)
            BestellungItemsPreise[sender.sections].remove(at: sender.sections2)
            BestellungItemsLiter[sender.sections].remove(at: sender.sections2)
            BestellungItemsMengen[sender.sections].remove(at: sender.sections2)
            BestellungUnterkategorien[sender.sections].remove(at: sender.sections2)
            BestellungItemsExpanded2[sender.sections].remove(at: sender.sections2)
            
            bestellteItemsDictionary[sender.sections].items.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.sections].preis.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.sections].liter.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.sections].menge.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.sections].Unterkategorie.remove(at: sender.sections2)
            bestellteItemsDictionary[sender.sections].expanded2.remove(at: sender.sections2)
            
            if bestellteItemsDictionary[sender.sections].Unterkategorie.count == 0{
                bestellteItemsDictionary.remove(at: sender.sections)
                BestellungKategorien.remove(at: sender.sections)
                BestellungItemsNamen.remove(at: sender.sections)
                BestellungItemsMengen.remove(at: sender.sections)
                BestellungItemsLiter.remove(at: sender.sections)
                BestellungItemsPreise.remove(at: sender.sections)
                BestellungUnterkategorien.remove(at: sender.sections)
                BestellungItemsExpanded2.remove(at: sender.sections)
                
                if bestellteItemsDictionary.count == 0 {
                    print("leeer")
                } } }
        sender.bestellteItemsDictionary = bestellteItemsDictionary
        uebersichtTV.reloadData()
    }
    
    func passItemPlus(sender: MyBestellungCell) {
        print(1)
    }
    
    func passItemMinus(sender: MyBestellungCell) {
        print(4)
    }
    
    func passKommentarAendern(sender: MyBestellungCell) {
        print(3)
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return bestellteItemsDictionary.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var heightForHeaderInSection: Int?
        
        heightForHeaderInSection = 36
        return CGFloat(heightForHeaderInSection!)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var countUKat =  0
        var countItems = 0
        var countExtras = 0
        
        countUKat = bestellteItemsDictionary[indexPath.section].items.count
        for items in bestellteItemsDictionary[indexPath.section].items  {
        
        countItems = countItems+items.count
        
        }
        
        for extras in bestellteItemsDictionary[indexPath.section].extras{
            for extra in extras{
                countExtras = extra.count
            }
        }
        
        return CGFloat(36+countUKat*36+countItems*171+countExtras*44)
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
//            return CGFloat(kategorieCount*100 + UnterkategorieCount*100 + itemsCount*86+50)
//
//
//        }
//        else {
//            return 1000
//        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.contentView.layer.cornerRadius = 5
        header.contentView.layer.backgroundColor = UIColor.clear.cgColor
        
        header.layer.cornerRadius = 5
        header.layer.backgroundColor = UIColor.clear.cgColor
        header.customInit(tableView: tableView, title:  bestellteItemsDictionary[section].Kategorie , section: section, delegate: self as ExpandableHeaderViewDelegate)
        return header
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
//        let cell = Bundle.main.loadNibNamed("MyBestellungCell", owner: self, options: nil)?.first as! MyBestellungCell
//        cell.backgroundColor = UIColor.clear
//        cell.delegate = self
//        cell.bestellteItemsDictionary = bestellteItemsDictionary
//        cell.sections = indexPath.section
//        cell.Extras = self.Extras
//        cell.ExtrasPreise = self.ExtrasPreise
        
        let cell = Bundle.main.loadNibNamed("MyBestellungCell", owner: self, options: nil)?.first as! MyBestellungCell
        cell.delegate = self
        cell.bestellteItemsDictionary = bestellteItemsDictionary
        print(bestellteItemsDictionary, "bestellteItemsDictionary")
        cell.Cell1Section = indexPath.section
//        cell.delegate = self as! MyBestellungCellDelegate

        
//
//        var Items = bestellteItemsDictionary[indexPath.section].items
//
//        var Preise = bestellteItemsDictionary[indexPath.section].preis
//        var Mengen = bestellteItemsDictionary[indexPath.section].menge
//        var Kommentare = bestellteItemsDictionary[indexPath.section].kommentar
//
//        print(Items, indexPath.row)
//        var newItems = Items[indexPath.row]
//        var newPreise = Preise[indexPath.row]
//        var newMengen = Mengen[indexPath.row]
//        var newKommentare = Kommentare[indexPath.row]
//        var Extras =  bestellteItemsDictionary[indexPath.section].extras
//        var newExtras = Extras[indexPath.row]
////        print(Bestellungen, "bestellung")
////        print(Extras, "Extras")
////        print(Cell2Row, "Cell2Row")
////        print(indexPath.row, "indexPath.row")
//        var newnewExtras = newExtras[indexPath.row]
//        var ExtrasPreise =  bestellteItemsDictionary[indexPath.section].extrasPreise
//        var newExtrasPreise = ExtrasPreise[indexPath.row]
//
////        print(newExtras, newExtrasPreise, indexPath.row)
//        var newnewExtrasPreise = newExtrasPreise[indexPath.row]
//
//        cell.myItemName.text = newItems[indexPath.row]
//        cell.extrasNamen = newnewExtras
//        cell.extrasPreise = newnewExtrasPreise
//        cell.Kategorie = bestellteItemsDictionary[indexPath.section].Kategorie
//
//        let preisFormat = String(format: "%.2f", arguments: [newPreise[indexPath.row]])
//        cell.myItemPreis.text = "\(preisFormat) €"
//        cell.myItemMenge.text = String(newMengen[indexPath.row])
//        cell.kommentarLbl.text = newKommentare[indexPath.row]


        return cell
        
//        let cell = Bundle.main.loadNibNamed("MyBestellungCell2", owner: self, options: nil)?.first as! MyBestellungCell2
////        cell.delegate = self
//        cell.bestellteItemsDictionary = bestellteItemsDictionary
//        cell.sections2 = indexPath.section
//
//        cell.Extras = self.Extras
//        cell.ExtrasPreise = self.ExtrasPreise
//
//
//
    }
    

    
    
    override func viewDidLoad() {
        self.navigationItem.title = "Deine Bestellung"

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)

        super.viewDidLoad()


    }
}
