//
//  KellnerTVSection.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 02.04.18.
//  Copyright © 2018 AM. All rights reserved.
//

import Foundation
struct KellnerTVSection {
    
    var BestellungID: String
    var Tischnummer: String
    var TimeStamp: Double
    var Kategorie: [String]
    var Unterkategorie: [[String]]
    var items: [[[String]]]
    var preis: [[[Int]]]
    var liter: [[[String]]]
    var menge: [[[Int]]]
    var expanded2: [[Bool]]
    var expanded: Bool
    
    init(BestellungID: String, tischnummer: String, timeStamp: Double, Kategorie: [String], Unterkategorie: [[String]], items: [[[String]]], preis: [[[Int]]], liter: [[[String]]], menge: [[[Int]]], expanded2: [[Bool]], expanded: Bool) {
        self.BestellungID = BestellungID
        self.Tischnummer = tischnummer
        self.TimeStamp = timeStamp
        self.Kategorie = Kategorie
        self.Unterkategorie = Unterkategorie
        self.items = items
        self.preis = preis
        self.liter = liter
        self.menge = menge
        self.expanded2 = expanded2
        self.expanded = expanded
    }
    
}
