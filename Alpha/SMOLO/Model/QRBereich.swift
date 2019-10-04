//
//  QRBereich.swift
//  SMOLO
//
//  Created by Alper Maraz on 19.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
class QRBereich: NSObject {
    var Name: String?
    var KellnerID: String?
    var AnzahlQRCodes: Int?
    var Latitude: Double?
    var Longitude: Double?
    var DispName: String?
    
    init(dictionary: [String: Any]) {
        self.Name = dictionary["Name"] as? String ?? ""
        self.KellnerID = dictionary["KellnerID"] as? String ?? ""
        self.AnzahlQRCodes = dictionary["AnzahlQRCodes"] as? Int ?? 0
        self.Latitude = dictionary["Latitude"] as? Double ?? 0.0
        self.Longitude = dictionary["Longitude"] as? Double ?? 0.0
        self.DispName = dictionary["DispName"] as? String ?? ""



        
    }
}
