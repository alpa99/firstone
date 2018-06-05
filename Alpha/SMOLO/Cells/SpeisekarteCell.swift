//
//  SpeisekarteCell.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 18.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

class SpeisekarteCell: UITableViewCell {

    
    @IBOutlet weak var itemNameLbl: UILabel!
    
    @IBOutlet weak var itemPreisLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        itemNameLbl.textColor = UIColor.white
        itemPreisLbl.textColor = UIColor.white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
