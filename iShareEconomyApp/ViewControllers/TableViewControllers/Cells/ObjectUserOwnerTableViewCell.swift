//
//  ObjectUserOwnerTableViewCell.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 21/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit

class ObjectUserOwnerTableViewCell: UITableViewCell {

    @IBOutlet var objectUserOwnerView: ObjectUserOwnerView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(id: String, name: String, subtitle: String?, owner: Bool) {
        objectUserOwnerView.update(id: id, name: name, subtitle: subtitle, owner: owner)
    }
}
