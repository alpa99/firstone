//
//  LabelWhiteS30.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 15.05.18.
//  Copyright © 2018 AM. All rights reserved.
//


import UIKit

class LabelWhiteS30: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: "Helvetica", size: 30)
        self.textColor = UIColor.white
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
