//
//  CreateLendObjectTableViewController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 26/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit
import RxSwift

class CreateLendObjectTableViewController: UITableViewController {
    
    let userController = UserController.shared
    let dispose = DisposeBag()
    
    var objectTitle: String? = nil
    var objectDescription: String? = nil
    var objectType: LendObjectType? = nil
    
    var user: User? = nil
    
    var object: LendObject? = nil
    
    @IBOutlet var typeButtons: [UIButton]!
    
    @IBAction func typeSelectAction(_ sender: UIButton) {
        for button in typeButtons {
            if button.accessibilityIdentifier == sender.accessibilityIdentifier {
                button.tintColor = .systemBlue
            } else {
                button.tintColor = .black
            }
        }
        switch sender.accessibilityIdentifier! {
        case "Tool":
            self.objectType = .Tool
        case "Service":
            self.objectType = .Service
        case "Transport":
            self.objectType = .Transport
        default:
            self.objectType = nil
        }
        self.enableDisableAddButton()
    }
    
    @IBOutlet var nameTextfield: UITextField!
    
    @IBOutlet var descriptionTextfield: UITextField!
    
    @IBOutlet var addButton: UIButton!
    
    @IBAction func createObjectAction(_ sender: UIButton) {
        if let title = objectTitle,
            let type = objectType,
            let description = objectDescription,
            let user = self.user
            {
                userController.addObject(title: title, description: description, type: type, ownerId: user.id, ownerName: user.fullname)
        }
    }
    
    @IBAction func enableDisableAddButton() {
        objectTitle = nameTextfield.text
        objectDescription = descriptionTextfield.text
        if let _ = self.objectType,
            let title = self.objectTitle,
            let description = self.objectDescription {
            if !title.isEmpty && title.count > 2 &&
                !description.isEmpty && description.count > 2 {
                toggleAddButton(true)
            } else {
               toggleAddButton(false)
            }
        } else {
            toggleAddButton(false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleAddButton(false)
        UserController.shared.loggedInUser.subscribe({
            if let loggedInUser = $0.element as? User {
                self.user = loggedInUser
            }
        }).disposed(by: dispose)
    }
    
    private func toggleAddButton(_ bool: Bool) {
        addButton.isEnabled = bool
        if bool {
            addButton.backgroundColor = .black
        } else {
            addButton.backgroundColor = .lightGray
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
