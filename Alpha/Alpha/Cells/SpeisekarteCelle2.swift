//
//  SpeisekarteCelle2.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 21.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

class SpeisekarteCelle2: UITableViewCell {

    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var LiterLbl: UILabel!
    @IBOutlet weak var PreisLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemLbl.textColor = UIColor.white
        LiterLbl.textColor = UIColor.white
        PreisLbl.textColor = UIColor.white
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
