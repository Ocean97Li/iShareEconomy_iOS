//
//  UserDetailTableViewController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 28/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit
import RxSwift

class UserDetailTableViewController: UITableViewController {

    var user: User? = nil {
        didSet {
            tableView.reloadData()
            self.title = user?.fullname
        }
    }
    
    var selectedObject: LendObject? = nil
    
    var isMe: Bool = false
    
    let dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = true
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return user!.lending.count
        case 2:
            return user!.using.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == 0 { //info
            let cell: UserHeaderTableViewCell
                   cell = tableView.dequeueReusableCell(withIdentifier: "UserHeaderCell", for: indexPath) as! UserHeaderTableViewCell
                   cell.selectionStyle = .none
                   if let user = user {
                       cell.update(user: user, isMe: isMe)
                   }
                   
                   return cell
        } else if indexPath.section == 1 { //lending
            let cell: LendObjectTableViewCell
                   cell = tableView.dequeueReusableCell(withIdentifier: "LendObjectCell", for: indexPath) as! LendObjectTableViewCell
                   cell.selectionStyle = .none
                   if let user = user {
                    cell.update(user.lending[indexPath.row])
                   }
                   
                   return cell
        } else { //using
            let cell: LendObjectTableViewCell
                   cell = tableView.dequeueReusableCell(withIdentifier: "LendObjectCell", for: indexPath) as! LendObjectTableViewCell
                   cell.selectionStyle = .none
                    if let user = user {
                        cell.update(user.using[indexPath.row])
                    }
                   
                   return cell
        }
       
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView()
        let text = UITextView()
        switch section {
        case 0:
            text.text = "User Info"
        case 1:
            text.text = "Sharing Objects"
        case 2:
            text.text = "Using Objects"
        default:
            text.text = ""
        }
        text.font = UIFont.boldSystemFont(ofSize: 25.0)
        text.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 0);
        header.textLabel?.text = text.text
        header.backgroundColor = .white
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = self.user {
            guard indexPath.section != 0 else {return}
            if indexPath.section == 1 {
                self.selectedObject = user.lending[indexPath.row]
            } else {
                self.selectedObject = user.using[indexPath.row]
            }
            performSegue(withIdentifier: "UserDetailToObjectDetailSegue", sender: nil)
       }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailToObjectDetailSegue" {
            if let viewController = segue.destination as? ObjectDetailTableViewController,
                let object = selectedObject {
                viewController.object = object
            }
        }
    }
    
}
