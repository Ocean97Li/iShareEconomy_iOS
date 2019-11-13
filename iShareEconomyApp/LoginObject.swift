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
    let token: String
    
    private let expires: Date
    var expired: Bool {
        get {
            return expires < Date() // Computed property because we want the current date here
        }
    }
    
    init(id: String, username: String, expires: Date, token: String) {
        self.id = id
        self.username = username
        self.expires = expires
        self.token = token
    }
}
