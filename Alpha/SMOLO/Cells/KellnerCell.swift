//
//  KellnerCell.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 11.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit

protocol kellnerCellDelegate {
    func annehmen(sender: KellnerCell)
}


class KellnerCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate2 {
    
    
    var Bestellungen = [KellnerTVSection]()
    var Cell1Section = Int()
    var bestellungID = String()
    var delegate: kellnerCellDelegate?
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var KellnerCelleTV: UITableView!
    
    @IBOutlet weak var annehmen: UIButton!
    
    @IBAction func annehmenTapped(_ sender: Any) {
        delegate?.annehmen(sender: self)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return Bestellungen[Cell1Section].Kategorie.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return Bestellungen[Cell1Section].Unterkategorie[section].count
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if Bestellungen[Cell1Section].expanded != false {
            
            let items = Bestellungen[Cell1Section].items[indexPath.section]
            let newitems = items[indexPath.row]
            return CGFloat(newitems.count*86+50)
            
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
        
        
        header.customInit(tableView: tableView, title: Bestellungen[Cell1Section].Kategorie[section], section: section, delegate: self as ExpandableHeaderViewDelegate2)
        return header
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("KellnerCell2", owner: self, options: nil)?.first as! KellnerCell2
        cell.Cell1Section = Cell1Section
        cell.Bestellungen = Bestellungen
        cell.Cell2Section = indexPath.section
        cell.Cell2Row = indexPath.row

        return cell
    }
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView2, section: Int) {
        
        //        for i in 0..<unterkategorien[0].Unterkategorie.count{
        //            if i == section {
        //                unterkategorien[0].expanded2[i] = !unterkategorien[0].expanded2[i]
        //            } else {
        //                unterkategorien[0].expanded2[i] = false
        //
        //            }
        //        }
        //
        //        BestellenTV.beginUpdates()
        //        let indexSet = NSMutableIndexSet()
        //        for i in 0..<unterkategorien[0].items[section].count {
        //            BestellenTV.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        //        }
        //        for i in 0..<unterkategorien[0].Unterkategorie.count{
        //            if i != section{
        //                indexSet.add(i)}
        //        }
        //        BestellenTV.reloadSections(indexSet as IndexSet, with: .automatic)
        //
        //        BestellenTV.endUpdates()
        
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        KellnerCelleTV.delegate = self
        KellnerCelleTV.dataSource = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timeLbl.textColor = UIColor.white
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
