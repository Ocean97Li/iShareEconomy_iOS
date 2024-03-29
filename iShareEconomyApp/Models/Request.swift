//
//  Request.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 12/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation

struct Request {
    let id: String
    let source: ObjectOwner
    let object: LendObject
    let fromDate: Date
    let toDate: Date
    let approved: Bool?
}
