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
    
    let dispose = DisposeBag()
    
    var object: LendObject? = nil
    var userDetailId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(object!.name.capitalized) detail"
        self.tableView.reloadData()
        
        cellCoordinator.userHeader.subscribe({
            if let id = $0.element {
                self.userDetailId = id
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "UserDetailSegue", sender: nil)
                }
            }
        }).disposed(by: dispose)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView()
        let text = UITextView()
        switch section {
        case 0:
            text.text = "Item"
        case 1:
            text.text = "Owner"
        case 2:
            text.text = "Current User"
        case 3:
            text.text = "Waitinglist"
        default:
            text.text = ""
        }
        text.font = UIFont.boldSystemFont(ofSize: 25.0)
        text.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 0);
        header.textLabel?.text = text.text
        return header
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        var numberOfSections = 3
        
        if (object?.waitinglist.count)! > 0 {
                numberOfSections += (object?.waitinglist.count)!
        }
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // (object + owner) + current user + waitinglist
        if section == 3 {
            // Waitinglist
            return (object?.waitinglist.count)!
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
            let cell: ObjectUserOwnerTableViewCell
            cell = tableView.dequeueReusableCell(withIdentifier: "ObjectUserOwnerCell", for: indexPath) as! ObjectUserOwnerTableViewCell
            cell.selectionStyle = .none
            cell.update(object!.owner)
            return cell
        } else if indexPath.section == 2 { //current user
            let cell: ObjectUserOwnerTableViewCell
            cell = tableView.dequeueReusableCell(withIdentifier: "ObjectUserOwnerCell", for: indexPath) as! ObjectUserOwnerTableViewCell
            cell.selectionStyle = .none
            if let currentUser = object?.currentUser {
                cell.update(currentUser)
            }
            return cell
        } else { // waitinglist
            let cell: ObjectUserOwnerTableViewCell
            cell = tableView.dequeueReusableCell(withIdentifier: "ObjectUserOwnerCell", for: indexPath) as! ObjectUserOwnerTableViewCell
            cell.selectionStyle = .none
            cell.update(object!.owner)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45;
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue" {
            if let viewController = segue.destination.children[0] as? UserDetailTableViewController,
                  let user = self.userController.getLocalUser(by: userDetailId) {
                      viewController.user = user
                      viewController.isMe = true
                  }
        }
    }

}
