//
//  MyBestellungCell.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 19.02.18.
//  Copyright © 2018 AM. All rights reserved.
//
import UIKit

protocol MyBestellungCell2Delegate {
    
    func cellMyItemEntfernen(sender: MyBestellungCell2)
    func cellMyItemMengePlusAction(sender: MyBestellungCell2)
    func cellmyItemMengeMinusAction(sender: MyBestellungCell2)
    func cellmyItemKommenAendern(sender: MyBestellungCell2)
    
}


class MyBestellungCell2: UITableViewCell, UITextViewDelegate {
    
    var delegate: MyBestellungCell2Delegate?
    
    var sections2 = Int()
    var rows2 = Int()
    
    
    @IBOutlet weak var myItemName: UILabel!
    
    @IBOutlet weak var myItemPreis: UILabel!
    
    @IBOutlet weak var myItemMenge: UILabel!
    @IBOutlet weak var kommentarLbl: UITextView!
    
    
    
    @IBOutlet weak var myItemLiter: UILabel!
    @IBOutlet weak var myItemMengeMinus: UIButton!
    @IBOutlet weak var myItemMengePlus: UIButton!
    @IBOutlet weak var myItemEntfernen: UIButton!

    @IBAction func myItemMengeMinusAction(_ sender: Any) {
        delegate?.cellmyItemMengeMinusAction(sender: self)
    }
    @IBAction func myItemMengePlusAction(_ sender: Any) {
        delegate?.cellMyItemMengePlusAction(sender: self)
    }
    @IBAction func myItemEntfernenAction(_ sender: Any) {
        delegate?.cellMyItemEntfernen(sender: self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.cellmyItemKommenAendern(sender: self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { textView.resignFirstResponder()
            return false
        }
        
        return true
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        kommentarLbl.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
