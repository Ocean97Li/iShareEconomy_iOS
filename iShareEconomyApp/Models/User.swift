//
//  File.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 12/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let firstname: String
    let lastname: String
    let address: String
    let distance: Double
    let rating: Int
    var lending: [LendObject]
    var using: [LendObject]
    
    var fullname: String {
        return "\(firstname) \(lastname)"
    }
}
