//
//  LendObjectView.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 19/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit

class LendObjectView: UIView {
    
    var object: LendObject? = nil {
        didSet {
            self.update()
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var waitingListLabel: UILabel!
    
    let kCONTENT_XIB_NAME = "LendObjectView"
    
    
    func update() {
        guard let object = self.object else { return }
        var image: UIImage
        switch object.type {
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
        titleLabel.text = object.name
        descriptionLabel.text = object.description
        waitingListLabel.text = String(object.waitinglist.count)
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

extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
