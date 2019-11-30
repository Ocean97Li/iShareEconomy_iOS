//
//  File.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 12/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation

class User {
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
    
    init(id: String, firstname: String, lastname: String, address: String, distance: Double, rating: Int, lending: [LendObject], using: [LendObject]) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.address = address
        self.distance = distance
        self.rating = rating
        self.lending = lending
        self.using = using
    }
}
