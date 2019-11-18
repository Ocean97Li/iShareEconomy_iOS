//
//  LendObjectTableViewCell.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 15/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit

class LendObjectTableViewCell: UITableViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var waitingListLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(with lendObject: LendObject) {
        var image: UIImage
        switch lendObject.type {
            case .Service:
                image = UIImage(systemName: "person.2.fill")!
                break
            case .Tool:
                image = UIImage(systemName: "hammer.fill")!
                break
            case .Transport:
                image = UIImage(systemName: "car.fill")!
                break
        }
        iconImageView.image = image
        titleLabel.text = lendObject.name
        descriptionLabel.text = lendObject.description
        waitingListLabel.text = String(lendObject.waitinglist.count)
    }
}
