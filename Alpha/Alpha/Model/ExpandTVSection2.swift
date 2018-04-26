//
//  ExpandTVSection2.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 18.03.18.
//  Copyright © 2018 AM. All rights reserved.
//

import Foundation

struct ExpandTVSection2 {
    
    var Kategorie: String
    var Unterkategorie: [String]
    var items: [[String]]
    var preis: [[Double]]
    var liter: [[String]]
    var expanded2: [Bool]
    var expanded: Bool
    
    init(Kategorie: String, Unterkategorie: [String], items: [[String]], preis: [[Double]], liter: [[String]], expanded2: [Bool], expanded: Bool) {
        self.Kategorie = Kategorie
        self.Unterkategorie = Unterkategorie
        self.items = items
        self.preis = preis
        self.liter = liter
        self.expanded2 = expanded2
        self.expanded = expanded
    }
    
}
