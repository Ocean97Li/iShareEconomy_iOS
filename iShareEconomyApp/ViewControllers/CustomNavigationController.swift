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

    var lending: [LendObject] = []
    
    let userController = UserController()
    let dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.isToolbarHidden = true
        self.updateObjectItems()
        
        userController.loggedInUser.subscribe({
            if let loggedInUser = $0.element as? User {
                self.lending = loggedInUser.lending
                // Implement Using next in branch
                self.updateObjectItems()
            }
        }).disposed(by: dispose)
        // Do any additional setup after loading the view.
    }
    
    func updateObjectItems() {
        if let tableController = self.children[0] as? LendObjectsTableViewController {
            if self.tabBarController?.tabBar.selectedItem?.title == "Lending" {
                tableController.objects = self.lending
                tableController.titleText = "Sharing"
            } else {
        // Get the new view controller using segue.destination.
            }
        }
    }

}
