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
        let userController = UserController()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
