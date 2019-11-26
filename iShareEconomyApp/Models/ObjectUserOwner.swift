//
//  ObjectOwner.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 13/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation

class ObjectOwner {
    let userId: String
    let userName: String
    
    init(userId: String, userName: String) {
        self.userId = userId
        self.userName = userName
    }
}

class ObjectUser: ObjectOwner {
    var fromDate: Date
    var toDate: Date
    
    init(userId: String, userName: String, fromDate: Date, toDate: Date) {
        self.fromDate = fromDate
        self.toDate = toDate
        super.init(userId: userId, userName: userName)
    }
}
