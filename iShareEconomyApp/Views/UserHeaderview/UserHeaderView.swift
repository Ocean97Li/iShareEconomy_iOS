//
//  UserHeaderView.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 28/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit

class UserHeaderView: UIView {
    @IBOutlet weak var containerView: UIView!
    let kCONTENT_XIB_NAME = "UserHeaderView"
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    
    func update(name: String, address: String, rating: Int, distance: Double? = nil) {
        nameLabel.text  = name
        addressLabel.text = address
        if let distance = distance {
            distanceLabel.text = "\(distance.rounded(toPlaces: 2)) km"
        } else {
            distanceLabel.text = ""
        }
        var ratingString = ""
        for index in 1...rating {
            ratingString.append("★")
        }
        ratingLabel.text = ratingString
        
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
    }
}
