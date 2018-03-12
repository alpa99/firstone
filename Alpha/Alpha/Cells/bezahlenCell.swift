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

class bezahlenCell: UITableViewCell {

    
    
    @IBOutlet weak var testcell: UILabel!
    
    @IBOutlet weak var testTabelle: UITableView!
    
    var delegate: bezahlenCellDelegate?
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
