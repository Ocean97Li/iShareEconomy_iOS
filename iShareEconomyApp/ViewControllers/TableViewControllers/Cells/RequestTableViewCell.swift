//
//  RequestTableViewCell.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 01/12/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    @IBOutlet var requestView: RequestView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(with request: Request) {
        requestView.update(with: request)
    }

}
