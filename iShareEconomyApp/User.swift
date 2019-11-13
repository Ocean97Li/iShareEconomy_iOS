//
//  File.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 12/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: String
    let firstname: String
    let lastname: String
    let address: String
    let distance: Int
    let rating: Int
    
    init(id: String, firstname: String, lastname: String, address: String, distance: Int, rating: Int) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.address = address
        self.distance = distance
        self.rating = rating
    }
}
