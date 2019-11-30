//
//  LendObjectsTableViewController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 15/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit
import RxSwift

class LendObjectsTableViewController: UITableViewController {

    let userController = UserController.shared
    
    let dispose = DisposeBag()
    
    var titleText = ""
    var objects: [LendObject] = []
    var users: [User] = []
    
    var removing: Bool = false
    
    @IBOutlet var removeItemBarButton: UIBarButtonItem!
    
    @IBAction func enableRemoving(_ sender: Any) {
        removing.toggle()
        if (removing) {
            removeItemBarButton.tintColor = .lightGray
        } else {
            removeItemBarButton.tintColor = .systemBlue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isToolbarHidden = true
        self.tabBarController?.navigationController?.navigationItem.hidesBackButton = true
        self.tableView.allowsSelection = true
        userController.loggedInUser.subscribe({
            if let loggedInUser = $0.element as? User {
                DispatchQueue.main.async {
                    self.updateObjectItems(user: loggedInUser)
                }
            }
        }).disposed(by: dispose)
        
        userController.users.subscribe({
            if let users = $0.element as? [User] {
                self.users = users
            }
        }).disposed(by: dispose)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = objects[indexPath.row]
        if let viewController = storyboard?.instantiateViewController(identifier: "ObjectDetail") as? ObjectDetailTableViewController {
            viewController.object = object
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return objects.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LendObjectCell", for: indexPath) as! LendObjectTableViewCell

        // Configure the cell...
        cell.selectionStyle = .none
        let object = objects[indexPath.row]
        cell.update(object)
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        guard title == "Sharing" else {return false}
        if objects[indexPath.row].currentUser != nil && !objects[indexPath.row].waitinglist.isEmpty {
            return false
        }
        return removing
        
    }
    
    func updateObjectItems(user: User) {
        if let restorationID = self.navigationController?.restorationIdentifier {
            if restorationID == "Sharing" {
                self.objects = user.lending
                self.titleText = "Sharing"
            } else {
                self.objects = user.using
                self.titleText = "Using"
            }
            self.title = self.titleText
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView:UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == UITableViewCell.EditingStyle.delete {
                userController.deleteObject(withId: objects[indexPath.row].id)
                objects.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    
    @IBAction func objectAddedUnwindAction(unwindSegue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UsingToUsersOverviewSegue" {
            if let viewController = segue.destination as? UsersOverviewTableViewController {
                viewController.users = self.users
            }
        }
    }

}
