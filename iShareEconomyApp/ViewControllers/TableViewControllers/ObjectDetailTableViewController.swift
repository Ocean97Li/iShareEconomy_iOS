//
//  ObjectDetailTableViewController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 21/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit

class ObjectDetailTableViewController: UITableViewController {
    
    var object: LendObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(object!.name.capitalized) detail"
        self.tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
            ".."
        }
        text.font = UIFont.boldSystemFont(ofSize: 25.0)
        text.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0);
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
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.backgroundColor = UIColor.white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .natural
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
