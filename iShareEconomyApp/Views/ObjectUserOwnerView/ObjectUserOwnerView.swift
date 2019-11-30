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
    
    let cellCoordinator = CellCoordinator.shared
    
    @IBOutlet var userOwnerImage: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var subtitleLabel: UILabel!
    
    @IBOutlet var userDetailButton: UIButton!
    
    @IBAction func userDetail(_ sender: Any) {
        if let id = self.userId {
            cellCoordinator.updateUserHeader(with: id)
        }
    }
    
    var userId: String? = nil
    
    func update(id: String, name: String, subtitle: String?, owner: Bool = false, info: Bool = false) {
        self.userId = id
        self.nameLabel.text = name
        self.userDetailButton.isHidden = false
        
        if let subtitle = subtitle {
            self.subtitleLabel.text = subtitle
            self.subtitleLabel.isHidden = false
        } else {
            self.subtitleLabel.isHidden = true
        }
        
        if owner {
            self.userOwnerImage.image = UIImage(systemName: "person.circle")
        }
        
        if info {
            self.userDetailButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        } else {
             self.userDetailButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
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
        subtitleLabel.isHidden = true
        userDetailButton.isHidden = true
    }
}
