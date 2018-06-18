//
//  KellnerCelle3.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 08.04.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

class KellnerCell3: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var extras = [String]()
    var extrasPreise = [Double]()
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPreis: UILabel!
    @IBOutlet weak var itemMenge: UILabel!
    @IBOutlet weak var kommentarTextView: UITextView!
    @IBOutlet weak var extrasTV: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ExtrasCell", owner: self, options: nil)?.first as! ExtrasCell
        cell.extraLbl.text = extras[indexPath.row]
        let preisFormat = String(format: "%.2f", arguments: [extrasPreise[indexPath.row]])

        cell.extraPreis.text = "\(preisFormat) €"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        extrasTV.delegate = self
        extrasTV.dataSource = self
    }
    
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
