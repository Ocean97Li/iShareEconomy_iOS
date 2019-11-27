//
//  LendObjectType.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 13/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation

enum LendObjectType {
    case Tool, Service, Transport
    
    func toString() -> String {
        switch self {
        case .Tool:
            return "tool"
        case .Service:
            return "service"
        case .Transport:
            return "transport"
        }
    }
}
