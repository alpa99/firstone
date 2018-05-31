//
//  UserInfo.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 19.05.18.
//  Copyright © 2018 AM. All rights reserved.
//

import Foundation
class UserInfos: NSObject {
    var aktuelleBar: String?
    var aktuellerTisch: String?
    var letzteBestellungZeit: Double?
    var AGBSAkzeptiert: Bool?
    var DatenschutzAkzeptiert: Bool?
    var gesperrt: Bool?
    
    init(dictionary: [String: Any]) {
        self.aktuelleBar = dictionary["aktuelleBar"] as? String ?? "keineBar"
        self.aktuellerTisch = dictionary["aktuellerTisch"] as? String ?? "keinTisch"
        self.letzteBestellungZeit = dictionary["letzteBestellungZeit"] as? Double ?? 0.0
        self.AGBSAkzeptiert = dictionary["AGBSAkzeptiert"] as? Bool ?? false
        self.DatenschutzAkzeptiert = dictionary["DatenschutzAkzeptiert"] as? Bool ?? false
        self.gesperrt = dictionary["gesperrt"] as? Bool ?? true


        
    }
}

