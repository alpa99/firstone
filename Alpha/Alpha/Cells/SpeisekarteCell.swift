//
//  SpeisekarteCell.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 16.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit

class SpeisekarteCell: UITableViewCell {

 
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemPreisLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
