//
//  bezahlenCell.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 09.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit


protocol bezahlenCellDelegate {
    
}

class bezahlenCell: UITableViewCell,UITableViewDelegate, UITableViewDataSource {
    
    
    
    var bestellteItems = [String: [String: [String: Int]]]()
    var idsArray = [String]()
    var genresArray = [String]()
    var itemsNamenArray = [String]()
    var itemsPreiseArray = [Int]()
    var bestellungenArray = [String: [String: Int]]()


    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var testTabelle: UITableView!
    
    @IBOutlet weak var gesamtLbl: UILabel!
    
    @IBOutlet weak var gesamtPreisLbl: UILabel!

    @IBOutlet weak var bezahlenBtn: UIButton!
    
    var section = Int()

    
    var delegate: bezahlenCellDelegate?

    override func layoutSubviews()
    {
        super.layoutSubviews()
        testTabelle.delegate = self
        testTabelle.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


            return itemsNamenArray.count
        
        
    }
    

    func loadBestellung(id: String){
        bestellungenArray = bestellteItems[id]!
        for (genre, item) in bestellungenArray {
            genresArray.append(genre)
            for (name, preis) in item {
                itemsNamenArray.append(name)


                itemsPreiseArray.append(preis)
            }
                
        }
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("bezahlenCell2", owner: self, options: nil)?.first as! bezahlenCell2

//        cell.genreLbl.text = genresArray[indexPath.row]
        cell.ItemLbl.text = itemsNamenArray[indexPath.row]
        cell.PreisLbl.text = "3 €"
        cell.MengeLbl.text = String(describing: itemsPreiseArray[indexPath.row])
        


        return cell
        
        
    }
    

    

    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        

        

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
