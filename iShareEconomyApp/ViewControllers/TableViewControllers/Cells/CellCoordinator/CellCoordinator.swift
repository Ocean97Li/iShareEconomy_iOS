//
//  File.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 28/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation
import RxSwift

class CellCoordinator {
    
    static let shared = CellCoordinator()
    
    var usersViewedStack: [String] = []
    
    let userHeader = PublishSubject<String>()
    
    func updateUserHeader(with userId: String) {
        if !usersViewedStack.contains(userId) {
            usersViewedStack.append(userId)
            userHeader.onNext(userId)
        }
       
    }
    
    private init() {
        
    }
}
