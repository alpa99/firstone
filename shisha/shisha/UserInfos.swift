//
//  UserInfos.swift
//  shisha
//
//  Created by Ibrahim Akcam on 01.09.17.
//  Copyright © 2017 AM. All rights reserved.
//

import Foundation
class UserInfos: NSObject {
    var UserName: String?
    var UserID: String?
    var UserEmail: String?
    init(dictionary: [String: Any]) {
        self.UserID = dictionary["UserID"] as? String ?? ""
        self.UserName = dictionary["UserName"] as? String ?? ""
        self.UserEmail = dictionary["UserEmail"] as? String ?? ""

    }
}
