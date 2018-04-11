//
//  KellnerCelle3.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 08.04.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

class KellnerCell3: UITableViewCell {
    
    
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPreis: UILabel!
    @IBOutlet weak var itemMenge: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
