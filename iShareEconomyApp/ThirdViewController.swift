//
//  ThirdViewController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 09/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit
import RxSwift


class ThirdViewController: UIViewController {
    
    let userController = UserController()
    let dispose = DisposeBag()
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var localLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationController?.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        userController.loggedInUser.subscribe({
            if let loggedInUser = $0.element as? User {
                DispatchQueue.main.async {
                    self.nameLabel.text = "\(loggedInUser.firstname) \(loggedInUser.lastname)"
                    self.localLabel.text = loggedInUser.address
                }
            }
        }).disposed(by: dispose)
        
    }


}
