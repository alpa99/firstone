//
//  bezahlenCell2.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 10.03.18.
//  Copyright © 2018 AM. All rights reserved.
//
import UIKit

protocol bestellenCell2Delegate {
    
}

class bezahlenCell2: UITableViewCell {

    
    @IBOutlet weak var genreLbl: UILabel!
    
    @IBOutlet weak var ItemLbl: UILabel!
    @IBOutlet weak var PreisLbl: UILabel!
    @IBOutlet weak var MengeLbl: UILabel!
    //    var delegate: bestellenCell2Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
