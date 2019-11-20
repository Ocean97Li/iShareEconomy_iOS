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

    let userController = UserController()
    let dispose = DisposeBag()
    
    var titleText = ""
    var objects: [LendObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isToolbarHidden = true
        self.tabBarController?.navigationController?.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        self.tableView.allowsSelection = true
        userController.loggedInUser.subscribe({
            if let loggedInUser = $0.element as? User {
                DispatchQueue.main.async {
                    self.updateObjectItems(user: loggedInUser)
                }
            }
        }).disposed(by: dispose)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = objects[indexPath.row]
        
        if let viewController = storyboard?.instantiateViewController(identifier: "ObjectDetail") as? ObjectDetailViewController {
            viewController.object = object
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        cell.update(with: object)
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func updateObjectItems(user: User) {
        if self.tabBarController?.tabBar.selectedItem?.title == "Sharing" {
            self.objects = user.lending
            self.titleText = "Sharing"
        } else {
            self.objects = user.using
            self.titleText = "Using"
        }
        self.title = self.titleText
        self.tableView.reloadData()
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
