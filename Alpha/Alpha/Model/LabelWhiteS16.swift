//
//  LabelWhiteS16.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 24.04.18.
//  Copyright © 2018 AM. All rights reserved.
//
import UIKit

class LabelWhiteS16: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: "Helvetica", size: 16)
        self.textColor = UIColor.white
}

}

