//
//  BestellungInfos.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 22.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation

class BestellungInfos: NSObject {
    
    
    var fromUserID: String?
    var toKellnerID: String?
    var timeStamp: NSNumber?
    var shishas: Dictionary<String, Int>?
    var getränke: Dictionary<String, Int>?
    var tischnummer: String?
    var angenommen: Bool?
    
    
    init(dictionary: [String: Any]) {
        self.fromUserID = dictionary["fromUserID"] as? String ?? ""
        self.toKellnerID = dictionary["toKellnerID"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? NSNumber ?? 0
        self.shishas = dictionary["shishas"] as? Dictionary ?? ["": 0]
        self.getränke = dictionary["getränke"] as? Dictionary ?? ["": 0]
        self.tischnummer = dictionary["tischnummer"] as? String ?? "leer"
        self.angenommen = dictionary["angenommen"] as? Bool ?? false
        }

}
