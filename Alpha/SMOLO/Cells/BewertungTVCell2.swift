//
//  BewertungTVCell2.swift
//  SMOLO
//
//  Created by Alper Maraz on 09.12.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

class BewertungTVCell2: UITableViewCell {
    
    @IBOutlet weak var ItemLbl: UILabel!
   
    
    
    var section2 = Int()
    var row2 = Int()
//    var delegate: bestellenCell2Delegate?
//
//
//    @IBAction func addBtnTapped(_ sender: Any) {
//        delegate?.addBtnTapped(sender: self)
//    }
//

    override func awakeFromNib() {
        super.awakeFromNib()
        ItemLbl.font = UIFont(name: "Verdana", size: 15.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
