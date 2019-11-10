//
//  LoginObject.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 07/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation

struct LoginObject: Codable {
    let id: String
    let username: String
    
    init(id: String, username: String) {
        self.id = id
        self.username = username
    }
}
