//
//  LendObjectView.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 21/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit

class ObjectUserOwnerView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    let kCONTENT_XIB_NAME = "ObjectUserOwnerView"
    
    
    @IBOutlet var userOwnerImage: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var periodDatesLabel: UILabel!
    
    var objectUserOwner: ObjectOwner? = nil {
        didSet {
            self.update()
        }
    }
    
    private func update() {
        guard let userOwner = self.objectUserOwner else {
            return
        }
        nameLabel.text = userOwner.userName
        if let user = userOwner as? ObjectUser {
            periodDatesLabel.text = "From \(user.fromDate.toShortString()) to \(user.toDate.toShortString())"
            periodDatesLabel.isHidden = false
        } else {
            userOwnerImage.image = UIImage(systemName: "person.circle")
        }
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
        periodDatesLabel.isHidden = true
    }
}
