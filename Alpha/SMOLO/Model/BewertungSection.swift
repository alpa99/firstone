//
//  BewertungSection.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 16.11.18.
//  Copyright © 2018 AM. All rights reserved.
//

import Foundation
struct BewertungSection {
    
    var TimeStamp: Double!
    var Kategorie: String!
    var Unterkategorie: [String]!
    var items: [[String]]!
//    var expanded2: [[Bool]]
//    var expanded: Bool
    
    init(timeStamp: Double, Kategorie: String, Unterkategorie: [String], items: [[String]]) {
        self.TimeStamp = timeStamp
        self.Kategorie = Kategorie
        self.Unterkategorie = Unterkategorie
        self.items = items
//        self.expanded2 = expanded2
//        self.expanded = expanded
        
    }
    
}
