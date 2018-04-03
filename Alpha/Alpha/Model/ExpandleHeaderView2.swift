//
//  ExpandableHeaderView.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 22.10.17.
//  Copyright © 2017 AM. All rights reserved.
//


import UIKit

protocol ExpandableHeaderViewDelegate2 {
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView2, section: Int)
}

class ExpandableHeaderView2: UITableViewHeaderFooterView {
    
    
    var delegate: ExpandableHeaderViewDelegate2?
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
        
        let cell = gestureRecognizer.view as! ExpandableHeaderView2
        delegate?.toggleSection(tableView: tableView, header: self, section: cell.section)
    }
    
    func customInit(tableView: UITableView, title: String, section: Int, delegate: ExpandableHeaderViewDelegate2) {
        
        self.textLabel?.text = title
        self.section = section
        self.delegate = delegate
        self.tableView = tableView
        self.tableView.backgroundView?.backgroundColor = UIColor.clear
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.tableHeaderView?.backgroundColor = UIColor.clear
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.textColor = UIColor.white
        self.textLabel?.font = UIFont(name: "Helvetica", size: 25.0)
        self.textLabel?.textAlignment = .left
        self.textLabel?.backgroundColor = UIColor.clear
        self.layer.backgroundColor = UIColor.clear.cgColor
//        self.contentView.backgroundColor = UIColor.clear
        
//        self.backgroundColor = UIColor.clear
//        tableView.backgroundColor = UIColor.clear
        
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
