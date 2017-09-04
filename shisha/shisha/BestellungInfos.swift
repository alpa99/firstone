//
//  File.swift
//  shisha
//
//  Created by Ibrahim Akcam on 03.09.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
class BestellungInfos: NSObject {
    var fromUserID: String?
    var toKellnerID: String?
    var timeStamp: NSNumber?
    var text: String?

    init(dictionary: [String: Any]) {
        self.fromUserID = dictionary["fromUserID"] as? String ?? ""
        self.toKellnerID = dictionary["toKellnerID"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? NSNumber ?? 0
        self.text = dictionary["text"] as? String ?? ""

    }
}
