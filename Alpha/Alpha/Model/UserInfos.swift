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
    init(dictionary: [String: Any]) {
        self.aktuelleBar = dictionary["aktuelleBar"] as? String ?? "keineBar"
        self.aktuellerTisch = dictionary["aktuellerTisch"] as? String ?? "keinTisch"
        self.letzteBestellungZeit = dictionary["letzteBestellungZeit"] as? Double ?? 0.0
        
    }
}

