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
    
    let userHeader = PublishSubject<String>()
    
    func updateUserHeader(with userId: String) {
        userHeader.onNext(userId)
    }
    
    private init() {
        
    }
}
