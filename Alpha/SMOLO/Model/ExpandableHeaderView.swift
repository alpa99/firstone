//
//  ExpandableHeaderView.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 22.10.17.
//  Copyright © 2017 AM. All rights reserved.
//


import UIKit

protocol ExpandableHeaderViewDelegate {
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {
    
    
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    var tableView = UITableView()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer){
        
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.toggleSection(tableView: tableView, header: self, section: cell.section)
    }
    
    func customInit(tableView: UITableView, title: String, section: Int, delegate: ExpandableHeaderViewDelegate) {
        
        self.textLabel?.text = title
        self.section = section
        self.delegate = delegate
        self.tableView = tableView
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.textColor = UIColor.white
        self.textLabel?.font = UIFont(name: "Helvetica", size: 25)
        self.textLabel?.textAlignment = .center
    
        self.contentView.backgroundColor = UIColor(red: 185.0/255.0, green: 170.0/255.0, blue: 140.0/255.0, alpha: 0.65)
        self.contentView.layer.cornerRadius = 0
        self.textLabel?.frame = self.layer.frame

    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}


