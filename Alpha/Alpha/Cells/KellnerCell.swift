//
//  KellnerCell.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 11.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit




class KellnerCell: UITableViewCell {



    @IBOutlet weak var tischnummer: UILabel!
    
    @IBOutlet weak var bestellungsText: UITextView!
    
    @IBOutlet weak var timeLbl: UILabel!
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tischnummer.textColor = UIColor.white
        bestellungsText.textColor = UIColor.white
        timeLbl.textColor = UIColor.white
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
