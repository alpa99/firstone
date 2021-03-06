//
//  SpeisekarteCelle.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 20.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

protocol SpeisekarteDelegate {
    func reloadUnterkategorie(sender: SpeisekarteCelle)
    func passItemSection(ItemSection: Int)
}

class SpeisekarteCelle: UITableViewCell, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate2 {


    // VARS
    var sections = [ExpandTVSection2]()
    var items = [[String]]()
    var preise = [[Double]]()
    var liters = [[String]]()
    var beschreibungen = [[String]]()
    var sectioncell = Int()
    var section2 = 0
    var row = 0
    var i = 0
    var delegate: SpeisekarteDelegate?
    
    // OUTLETS
    
    
    @IBOutlet weak var SpeisekarteTV: UITableView!
    
    
    
    // Tabelle
    func numberOfSections(in tableView: UITableView) -> Int {
       

        return sections[sectioncell].Unterkategorie.count

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[sectioncell].items[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sections[sectioncell].Unterkategorie[section] == "leer" {
            return 1
            
        } else {
            return 36
        }
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(indexPath, "INDEXPATH CELL2")
        if sections[sectioncell].expanded2[indexPath.section] != false {
            return CGFloat(60)}
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView2()
       
        header.customInit(tableView: tableView, title:  sections[sectioncell].Unterkategorie[section], color: UIColor.white, section: section, delegate: self as ExpandableHeaderViewDelegate2)
        if sections[sectioncell].Unterkategorie[section] == "leer" {
            header.textLabel?.textColor = UIColor.clear
        }
        
            return header
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SpeisekarteCelle2", owner: self, options: nil)?.first as! SpeisekarteCelle2
        delegate?.passItemSection(ItemSection: indexPath.section)
//        cell.itemLbl.text = "cell.itemLbl.text"
        if sections[sectioncell].expanded2[indexPath.section] != false {

            let item = sections[sectioncell].items[indexPath.section]
            let preis = sections[sectioncell].preis[indexPath.section]
            let liter = sections[sectioncell].liter[indexPath.section]
            let beschreibung = sections[sectioncell].beschreibung[indexPath.section]
        cell.itemLbl.text = item[indexPath.row]
        let preisFormat = String(format: "%.2f", arguments: [preis[indexPath.row]])
        cell.PreisLbl.text = "\(preisFormat) €"
            print(liter)
            print(indexPath.row, self.row)
                if liter[indexPath.row] != "0.0l"{
                    cell.LiterLbl.text = (liter[indexPath.row])
            
                        }
                    
                else {
                    cell.LiterLbl.isHidden = true
                        }
        cell.beschreibungLbl.text = beschreibung[indexPath.row]

            return cell
            
        } else {
            cell.itemLbl.isHidden = true
            cell.PreisLbl.isHidden = true
            cell.LiterLbl.isHidden = true
            cell.beschreibungLbl.isHidden = true
            return cell
        }
    }
    
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView2, section: Int) {
        

        for i in 0..<sections[sectioncell].Unterkategorie.count{
            if i == section {
                sections[sectioncell].expanded2[i] = !sections[sectioncell].expanded2[i]
            } else {
                sections[sectioncell].expanded2[i] = false
                
            }
        }
        
        SpeisekarteTV.beginUpdates()
        let indexSet = NSMutableIndexSet()
        for i in 0..<sections[sectioncell].items[section].count {
            SpeisekarteTV.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        for i in 0..<sections[sectioncell].Unterkategorie.count{
            if i != section{
                indexSet.add(i)}
        }
        SpeisekarteTV.reloadSections(indexSet as IndexSet, with: .automatic)
        delegate?.reloadUnterkategorie(sender: self)
        
        SpeisekarteTV.endUpdates()
        
    }
    
    // OTHERS

    override func layoutSubviews()
    {
        super.layoutSubviews()
        SpeisekarteTV.delegate = self
        SpeisekarteTV.dataSource = self
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
