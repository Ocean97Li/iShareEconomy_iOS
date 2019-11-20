//
//  LendObject.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 12/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation

struct LendObject {
    let id: String
    let owner: ObjectOwner
    let waitinglist: [ObjectUser]
    let currentUser: ObjectUser?
    let name: String
    let description: String
    let type: LendObjectType
    let rules: String
    
//    init(id: id, owner: ObjectOwner, waitinglist: [ObjectOwner], name: String, description: String, type: LendObjectType, rules: String) {
//        self.id = id
//    }
}
