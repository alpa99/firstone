//
//  FacebookUsers.swift
//  shisha
//
//  Created by Ibrahim Akcam on 17.08.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
class FacebookUsers: NSObject {
    var userFbID: String?
    var userFbName: String?
    var userFbEmail: String?
    init(dictionary: [String: Any]) {
        self.userFbID = dictionary["userFbID"] as? String ?? ""
        self.userFbName = dictionary["userFbName"] as? String ?? ""
        self.userFbEmail = dictionary["userFbEmail"] as? String ?? ""
        
    }
}
