//
//  MyBestellungCelle.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 29.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

protocol MyBestellungCellDelegate {
    func passItemEntfernen(sender: MyBestellungCell)
    func passItemPlus(sender: MyBestellungCell)
    func passItemMinus(sender: MyBestellungCell)
    func passKommentarAendern(sender: MyBestellungCell)
    
}

class MyBestellungCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate2, MyBestellungCell2Delegate {

    
    
    // VARS
    //
    var bestellteItemsDictionary = [bestellungTVSection]()
    var Cell1Section = Int()
    var delegate: MyBestellungCellDelegate?

    var items = [[String]]()
    var preise = [[Double]]()
    var liters = [[String]]()
    var sections = Int()
    var rows = Int()
    var Kategorie = String()
    var Extras = [String: [String]]()
    var ExtrasPreise = [String: [Double]]()


    
    var sections2 = Int()
    var rows2 = Int()
    var kommenar = String()
    
//    var delegate: MyBestellungCellDelegate?

    // OUTLETS
    
    
    @IBOutlet weak var myBestellungTV: UITableView!

    func cellMyItemEntfernen(sender: MyBestellungCell2) {
        sections2 = sender.Cell2Section
        rows2 = sender.Cell2Row
        delegate?.passItemEntfernen(sender: self)
        print("22")


    }
    
    func cellmyItemMengeMinusAction(sender: MyBestellungCell2) {
        sections2 = sender.Cell2Section
        rows2 = sender.Cell2Row
        delegate?.passItemMinus(sender: self)
    }
    
    func cellMyItemMengePlusAction(sender: MyBestellungCell2) {
        sections2 = sender.Cell2Section
        rows2 = sender.Cell2Row
        delegate?.passItemPlus(sender: self)
    }
    
    func cellmyItemKommenAendern(sender: MyBestellungCell2) {
        sections2 = sender.Cell2Section
        rows2 = sender.Cell2Row
        kommenar = sender.kommentarLbl.text
        delegate?.passKommentarAendern(sender: self)
    }
    
    // Tabelle
    func numberOfSections(in tableView: UITableView) -> Int {
        return bestellteItemsDictionary[Cell1Section].Unterkategorie.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bestellteItemsDictionary[Cell1Section].items[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if bestellteItemsDictionary[Cell1Section].expanded != false {
            let a = bestellteItemsDictionary[Cell1Section].extras[indexPath.section]
            let b = a[indexPath.row].count*44
            return CGFloat(171+b)
        }
        else {
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView2()
        
        header.customInit(tableView: tableView, title:  bestellteItemsDictionary[Cell1Section].Unterkategorie[section] , section: section, delegate: self as ExpandableHeaderViewDelegate2)
        return header
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MyBestellungCell2", owner: self, options: nil)?.first as! MyBestellungCell2
        cell.backgroundColor = UIColor.clear
        print(bestellteItemsDictionary,"bestellteItemsDictionary, CELL 1")
        cell.Cell1Section = Cell1Section
        cell.bestellteItemsDictionary = bestellteItemsDictionary
        cell.Cell2Section = indexPath.section
        cell.Cell2Row = indexPath.row
        cell.delegate = self
        var extrasNamen = bestellteItemsDictionary[Cell1Section].extras[indexPath.section]
        cell.extrasNamen = extrasNamen[indexPath.row]
        var item = bestellteItemsDictionary[Cell1Section].items[indexPath.section]
        var extrasPreise = bestellteItemsDictionary[Cell1Section].extrasPreise[indexPath.section]
        cell.extrasPreise = extrasPreise[indexPath.row]
        var preis = bestellteItemsDictionary[Cell1Section].preis[indexPath.section]
        var liter = bestellteItemsDictionary[Cell1Section].liter[indexPath.section]
        var menge = bestellteItemsDictionary[Cell1Section].menge[indexPath.section]
        var kommentare = bestellteItemsDictionary[Cell1Section].kommentar[indexPath.section]
        
        let preisFormat = String(format: "%.2f", arguments: [(preis[indexPath.row])])

        cell.myItemName.text = item[indexPath.row]
        cell.myItemPreis.text = "\(preisFormat) €"
        cell.myItemLiter.text = liter[indexPath.row]
        cell.myItemMenge.text = "\(menge[indexPath.row])"
        cell.kommentarLbl.text = kommentare [indexPath.row]
        return cell
// bestellteItemsDictionary[sections].expanded2[indexPath.section] != false {
//
//                    var item = bestellteItemsDictionary[sections].items[indexPath.section]
//                    var preis = bestellteItemsDictionary[sections].preis[indexPath.section]
//                    var liter = bestellteItemsDictionary[sections].liter[indexPath.section]
//                    var menge = bestellteItemsDictionary[sections].menge[indexPath.section]
//                    var kommentare = bestellteItemsDictionary[sections].kommentar[indexPath.section]
//                    var extras = bestellteItemsDictionary[sections].extras[indexPath.section]
//                    print(extras, "hwehwhehwehwe")
//                    var extrasPreise = bestellteItemsDictionary[sections].extrasPreise[indexPath.section]
//
////                    section2 = indexPath.section
////                    row2 = indexPath.row
//                    cell.sections2 = indexPath.section
//                    cell.rows2 = indexPath.row
//                    cell.myItemName.text = item[indexPath.row]
//                    cell.kommentarLbl.text = kommentare[indexPath.row]
//                    cell.extrasNamen = extras[indexPath.row]
//                    cell.extrasPreise = extrasPreise[indexPath.row]
//                    cell.Kategorie = self.Kategorie
//                    cell.Extras = self.Extras
//                    cell.ExtrasPreise = self.ExtrasPreise
//
//                    let preisFormat = String(format: "%.2f", arguments: [preis[indexPath.row]])
//
//                    cell.myItemPreis.text = "\(preisFormat) €"
//                    cell.myItemMenge.text = String(menge[indexPath.row])
//
//                    cell.myItemLiter.text = liter[indexPath.row]
//                    if liter[indexPath.row] != "0.0l"{
//                        cell.myItemLiter.text = liter[indexPath.row]
//
//                    }
//
//                    else {
//                        cell.myItemLiter.isHidden = true
//                    }
//
//
//                    return cell
//
//                } else {
//                    cell.myItemName.isHidden = true
//                    cell.myItemPreis.isHidden = true
//                    cell.myItemMenge.isHidden = true
//                    cell.myItemLiter.isHidden = true
//                    cell.myItemEntfernen.isHidden = true
//                    cell.myItemMengePlus.isHidden = true
//                    cell.myItemMengeMinus.isHidden = true
//
//                    return cell
//        }

    }
    
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView2, section: Int) {
        print("jw98weiujked")
//        for i in 0..<bestellteItemsDictionary[sections].Unterkategorie.count{
//            if i == section {
//                bestellteItemsDictionary[sections].expanded2[i] = !bestellteItemsDictionary[sections].expanded2[i]
//            } else {
//                bestellteItemsDictionary[sections].expanded2[i] = false
//                
//            }
//        }
//        
//        myBestellungTV.beginUpdates()
//        let indexSet = NSMutableIndexSet()
//        for i in 0..<bestellteItemsDictionary[sections].items[section].count {
//            myBestellungTV.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
//        }
//        for i in 0..<bestellteItemsDictionary[sections].Unterkategorie.count{
//            if i != section{
//                indexSet.add(i)}
//        }
//        myBestellungTV.reloadSections(indexSet as IndexSet, with: .automatic)
//        
//        myBestellungTV.endUpdates()
        
    }
    
    // OTHERS
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        myBestellungTV.delegate = self
        myBestellungTV.dataSource = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
