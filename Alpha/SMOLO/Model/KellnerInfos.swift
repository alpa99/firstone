//
//  KellnerInfos.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 11.11.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
class KellnerInfos: NSObject {
    var Barname: String?

    init(dictionary: [String: Any]) {
        self.Barname = dictionary["Barname"] as? String ?? ""

        
    }
}

