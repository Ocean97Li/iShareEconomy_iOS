//
//  LendObjectTableViewCell.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 15/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit

class LendObjectTableViewCell: UITableViewCell {
    
    @IBOutlet var lendObjectView: LendObjectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(_ lendObject: LendObject) {
        lendObjectView.object = lendObject
    }
}
