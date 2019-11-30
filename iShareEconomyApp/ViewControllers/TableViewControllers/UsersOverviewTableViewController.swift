//
//  UsersOverviewTableViewController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 29/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit
import RxSwift

class UsersOverviewTableViewController: UITableViewController {

    let cellCoordinator = CellCoordinator.shared
    let userController = UserController.shared
    
    let dispose = DisposeBag()
    var subscription: Disposable? = nil
    
    var users: [User] = []
    
    var userDetailId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.cellCoordinator.usersViewedStack = []
        self.subscription = cellCoordinator.userHeader.subscribe({
            if let id = $0.element {
                self.userDetailId = id
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "OverviewToUserDetailSegue", sender: nil)
                }
            }
        })
        self.subscription?.disposed(by: dispose)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.subscription?.dispose()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectUserOwnerCell", for: indexPath) as! ObjectUserOwnerTableViewCell
        let user = users[indexPath.row]
        let subtitle = "\(user.distance.rounded(toPlaces: 2)) km"
        cell.update(id: user.id, name: user.fullname, subtitle: subtitle, owner: false, info: false)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OverviewToUserDetailSegue" {
            if let viewController = segue.destination as? UserDetailTableViewController {
                viewController.fromOverview = true
                viewController.user = userController.getLocalUser(by:userDetailId)
            }
            
        }
    }

}
