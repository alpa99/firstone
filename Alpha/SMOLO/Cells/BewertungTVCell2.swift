//
//  BewertungTVCell2.swift
//  SMOLO
//
//  Created by Alper Maraz on 09.12.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit
import Cosmos

class BewertungTVCell2: UITableViewCell {
    
    @IBOutlet weak var ItemLbl: UILabel!
   
    @IBOutlet weak var Cosmos: CosmosView!
    @IBOutlet weak var Abschicken: UIButton!
    
    
    @IBAction func Absenden(_ sender: UIButton) {
        print(self.note, "note")

    }
    var section2 = Int()
    var row2 = Int()
    var note = 0.0
//    var delegate: bestellenCell2Delegate?
//
//
//    @IBAction func addBtnTapped(_ sender: Any) {
//        delegate?.addBtnTapped(sender: self)
//    }
//

    override func awakeFromNib() {
        
        Cosmos.settings.fillMode = .half
        Cosmos.didTouchCosmos = { rating in
            self.note = rating
        }
        Cosmos.settings.starSize = 23.0
        Cosmos.settings.starMargin = 5.0
        super.awakeFromNib()
        ItemLbl.font = UIFont(name: "Verdana", size: 15.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
