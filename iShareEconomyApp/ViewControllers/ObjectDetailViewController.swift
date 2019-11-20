//
//  ObjectDetailViewController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 19/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit

class ObjectDetailViewController: UIViewController {
    
    var object: LendObject? = nil
    
    @IBOutlet var lendObjectView: LendObjectView!
    
    @IBOutlet var objectOwnerNameLabel: UILabel!
    
    @IBOutlet var objectCurrentUserNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(object!.name.capitalized) detail"
        lendObjectView.object = object
        objectOwnerNameLabel.text = object?.owner.userName
//        objectCurrentUserNameLabel.text = object?.waitinglist[0].userName
    
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
