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

class bezahlenCell: UITableViewCell,UITableViewDelegate, UITableViewDataSource {
    
    var testarray = ["1", "2","3", "4"]
    
    
    var bestellteItems = [String: [String: Int]]()


    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var testTabelle: UITableView!
    
    var delegate: bezahlenCellDelegate?
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        testTabelle.delegate = self
        testTabelle.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("bezahlenCell2", owner: self, options: nil)?.first as! bezahlenCell2
        cell.testlbl.text = testarray[indexPath.row]
        return cell
    }
    
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let kellnerangenommenVC = UIStoryboard(name: "Main", bundle: nil) . instantiateViewController(withIdentifier: "KellnerAngenommenVC") as! KellnerAngenommenVC
    bestellteItems = kellnerangenommenVC.itemssss
        print(bestellteItems, "hjadfhjbsdjhbfsdjhljqkdbsak")
        
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
