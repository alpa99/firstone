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
    func disableBackBtn(sender: MyBestellungCell2)
    
    
}


class MyBestellungCell2: UITableViewCell, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource{

    var bestellteItemsDictionary = [bestellungTVSection]()
    var Cell1Section = Int()
    var Cell2Section = Int()
    var Cell2Row = Int()
    
    var delegate: MyBestellungCell2Delegate?
    var extrasNamen = [String]()
    var extrasPreise = [Double]()
    var Kategorie = String()
    var Extras = [String: [String]]()
    var ExtrasPreise = [String: [Double]]()
//

    @IBOutlet weak var extrasTV: UITableView!
    
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
        print("holla neu")
        delegate?.cellMyItemMengePlusAction(sender: self)
        print("holla neu2")

    }
    @IBAction func myItemEntfernenAction(_ sender: Any) {
        delegate?.cellMyItemEntfernen(sender: self)
        print("11")
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.disableBackBtn(sender: self)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        delegate?.cellmyItemKommenAendern(sender: self)
        delegate?.disableBackBtn(sender: self)

        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(extrasNamen, "ferfwd")
        
        return extrasNamen.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("KellnerExtrasCell", owner: self, options: nil)?.first as! KellnerExtrasCell
        cell.backgroundColor = UIColor.clear
        cell.extrasNameLbl.text = extrasNamen[indexPath.row]
        let preisFormat = String(format: "%.2f", arguments: [(extrasPreise[indexPath.row])])
        cell.extrasPreisLbl.text = "\(preisFormat) €"
        
//                    if self.Extras.keys.contains(Kategorie) {
//
//                        var extras = self.Extras[Kategorie]
//                        var extraspreise = self.ExtrasPreise[Kategorie]
//                        cell.extraRow = indexPath.row
//                        cell.extrasNameLbl.text = extras?[indexPath.row]
////                        if extrasNamen.contains((extras?[indexPath.row])!) {
////                            cell.extraSelect.isSelected = true
////                        } else {
////                            cell.extraSelect.isSelected = false
////
////                        }
//                        let preisFormat = String(format: "%.2f", arguments: [(extraspreise?[indexPath.row])!])
//
//                        cell.extrasPreisLbl.text = preisFormat
//                    } else {
//                        cell.extrasNameLbl.text = "keine Extras"
////                        ExtrasHinzufügenBtn.isHidden = true
//                        cell.extrasPreisLbl.isHidden = true
////                        cell.extraSelect.isHidden = true
//                    }

        return cell
    }
    
   
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        extrasTV.delegate = self
        extrasTV.dataSource = self
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
