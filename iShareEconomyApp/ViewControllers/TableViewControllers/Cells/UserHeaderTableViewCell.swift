//
//  UserHeaderTableViewCell.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 28/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit

class UserHeaderTableViewCell: UITableViewCell {

    @IBOutlet var userHeaderView: UserHeaderView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(user: User, isMe: Bool) {
        if (isMe) {
            userHeaderView.update(name: user.fullname, address: user.address, rating: user.rating)
        } else {
            userHeaderView.update(name: user.fullname, address: user.address, rating: user.rating, distance: user.distance)
        }
        
    }
}
