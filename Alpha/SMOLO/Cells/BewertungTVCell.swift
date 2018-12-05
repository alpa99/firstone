//
//  BewertungTVCell.swift
//  SMOLO
//
//  Created by Alper Maraz on 04.12.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

class BewertungTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var unterkategorien = [BewertungSection]()

    var items = [[String]]()

    @IBOutlet weak var ItemName: UILabel!
    
    
    
}
