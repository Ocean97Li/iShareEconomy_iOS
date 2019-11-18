//
//  CustomTabBarController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 09/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
}
