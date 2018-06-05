//
//  KellnerCelle3.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 08.04.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

class KellnerCell3: UITableViewCell {
    
    
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPreis: UILabel!
    @IBOutlet weak var itemMenge: UILabel!
    @IBOutlet weak var kommentarTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        kommentarTextView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
