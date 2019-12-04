//
//  ObjectDetailTableViewController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 21/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit
import RxSwift

class ObjectDetailTableViewController: UITableViewController {
    
    let cellCoordinator = CellCoordinator.shared
    let userController = UserController.shared
    let loggedInController = LoginController.shared
    
    let dispose = DisposeBag()
    var subscription: Disposable? = nil
    
    var fromOverview: Bool = false
    
    var object: LendObject? = nil
    var userDetailId = ""
    var logindId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(object!.name.capitalized) \(object!.name.count < 18 ? "Detail" : "")"
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.subscription = cellCoordinator.userHeader.subscribe({
            if let id = $0.element {
                self.userDetailId = id
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "UserDetailModalSegue", sender: nil)
                }
            }
        })
        self.subscription?.disposed(by: dispose)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.subscription?.dispose()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView()
        let text = UITextView()
        switch section {
        case 0:
            text.text = "Lending"
        case 1:
            text.text = "Owner"
        case 2:
            text.text = "Current User"
        case 3:
            text.text = !(object!.waitinglist.isEmpty) ? "Waitinglist" : "Send Request"
        case 4:
            text.text = "Send Request"
        default:
            text.text = ""
        }
        text.font = UIFont.boldSystemFont(ofSize: 25.0)
        text.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 0);
        header.textLabel?.text = text.text
        return header
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 3
        
        if (object?.waitinglist.count)! > 0 {
            numberOfSections += (object?.waitinglist.count)!
        }
        
        if loggedInController.loggedInUserId != object?.owner.userId {
            numberOfSections += 1
        }
        
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 && !object!.waitinglist.isEmpty {
            // Waitinglist
            return object!.waitinglist.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 { // object
            let cell: LendObjectTableViewCell
            cell = tableView.dequeueReusableCell(withIdentifier: "LendObjectCell", for: indexPath) as! LendObjectTableViewCell
            cell.selectionStyle = .none
            cell.update(self.object!)
            
            return cell
        } else if indexPath.section == 1 { //owner
            let owner = self.object!.owner
            let cell: ObjectUserOwnerTableViewCell
            cell = tableView.dequeueReusableCell(withIdentifier: "ObjectUserOwnerCell", for: indexPath) as! ObjectUserOwnerTableViewCell
            cell.selectionStyle = .none
            cell.update(id: owner.userId, name: owner.userName, subtitle: nil, owner: true, info: true)
            
            return cell
        } else if indexPath.section == 2 { //current user
            let cell: ObjectUserOwnerTableViewCell
            cell = tableView.dequeueReusableCell(withIdentifier: "ObjectUserOwnerCell", for: indexPath) as! ObjectUserOwnerTableViewCell
            cell.selectionStyle = .none
            if let user = object?.currentUser {
                let subtitle = objectUserFromToString(user)
                cell.update(id: user.userId, name: user.userName, subtitle: subtitle, owner: false, info: true)
            }
            
            return cell
        } else if indexPath.section == 3 && !object!.waitinglist.isEmpty{ // waitinglist
                let cell: ObjectUserOwnerTableViewCell
                cell = tableView.dequeueReusableCell(withIdentifier: "ObjectUserOwnerCell", for: indexPath) as! ObjectUserOwnerTableViewCell
                cell.selectionStyle = .none
                let waitingUser = object!.waitinglist[indexPath.row]
                let subtitle = objectUserFromToString(waitingUser)
                cell.update(id: waitingUser.userId, name: waitingUser.userName, subtitle: subtitle, owner: false, info: true)
                
                return cell
        } else { // create request button
            let cell: ButtonTableViewCell
             cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
            let button = (cell.contentView.subviews[0]) as! UIButton
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.gray.cgColor
            
            return cell
        }
    }
    
    private func objectUserFromToString(_ user: ObjectUser) -> String {
        return "From \(user.fromDate.toShortString()) to \(user.toDate.toShortString())"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45;
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailModalSegue" {
            if let viewController = segue.destination.children[0] as? UserDetailTableViewController,
                  let user = self.userController.getLocalUser(by: userDetailId) {
                      viewController.user = user
                      viewController.isMe = true
                      viewController.fromOverview = self.fromOverview
                      segue.destination.presentationController?.delegate = viewController
                  }
        }
        
        if segue.identifier == "CreateRequestSegue" {
            if let viewController = segue.destination.children[0] as? CreateRequestTableViewController,
            let object = object {
                viewController.object = object
            }
        }
    }

}
