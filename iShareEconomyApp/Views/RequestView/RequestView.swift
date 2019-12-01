//
//  RequestView.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 01/12/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation
import UIKit

class RequestView: UIView {
    @IBOutlet var containerView: UIView!
    let kCONTENT_XIB_NAME = "RequestView"
    
    @IBOutlet var sourceToOwnerLabel: UILabel!
    @IBOutlet var lendObjectView: LendObjectView!
    @IBOutlet var fromDateToDateLabel: UILabel!
    
    func update(with request: Request) {
        sourceToOwnerLabel.text = "\(request.source.userName) →  \(request.object.owner.userName)\((request.approved != nil ? (request.approved! ? " ✅":" ❌") : ""))"
            
        lendObjectView.object = request.object
        fromDateToDateLabel.text = "From \(request.fromDate.toShortString()) to \(request.toDate.toShortString())"
    }
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
           
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
           
       func commonInit() {
            Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
            containerView.fixInView(self)
            lendObjectView.layer.borderWidth = 1
            lendObjectView.layer.borderColor = UIColor.systemGray4.cgColor
       }
}
