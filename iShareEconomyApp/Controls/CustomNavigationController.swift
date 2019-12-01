//
//  CustomNaviagationController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 16/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit
import RxSwift

class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.isToolbarHidden = true    
    }
}
