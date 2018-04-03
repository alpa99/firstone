//
//  BestellungInfos.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 22.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation

class BestellungInfos: NSObject {
    
    var itemName: String?
    var itemPreis: Int?
    var itemMenge: Int?
    var fromUserID: String?
    var toKellnerID: String?
    var timeStamp: Double?
    var tischnummer: String?
    var angenommen: Bool?
    
    
    init(dictionary: [String: Any]) {
        self.itemName = dictionary["Name"] as? String ?? ""
        self.itemMenge = dictionary["Menge"] as? Int ?? 0
        self.itemPreis = dictionary["Preis"] as? Int ?? 0
        self.fromUserID = dictionary["fromUserID"] as? String ?? ""
        self.toKellnerID = dictionary["toKellnerID"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Double ?? 0.0
        self.tischnummer = dictionary["tischnummer"] as? String ?? "leer"
        self.angenommen = dictionary["angenommen"] as? Bool ?? false
        }

}
