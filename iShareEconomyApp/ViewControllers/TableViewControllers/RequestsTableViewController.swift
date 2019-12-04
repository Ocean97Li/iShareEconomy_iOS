//
//  RequestsTableViewController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 01/12/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit
import RxSwift

class RequestsTableViewController: UITableViewController {
    
    let requestController = RequestController.shared
    var inSubscription: Disposable? = nil
    var outSubscription: Disposable? = nil
    let dispose = DisposeBag()
    
    var inRequests: [Request] = []
    var outRequests: [Request] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Requests"
        
        self.inSubscription = requestController.inRequests.subscribe({
            if let requests = $0.element as? [Request] {
                DispatchQueue.main.async {
                    self.inRequests = requests
                    self.tableView.reloadData()
                    self.setMyselfToSelected()
                }
            }
        })
        self.inSubscription?.disposed(by: dispose)
        
        self.inSubscription = requestController.outRequests.subscribe({
            if let requests = $0.element as? [Request] {
                DispatchQueue.main.async {
                    self.outRequests = requests
                    self.tableView.reloadData()
                    self.setMyselfToSelected()
                }
            }
        })
        self.inSubscription?.disposed(by: dispose)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView()
        let text = UITextView()
        switch section {
        case 0:
            text.text = "My Requests"
        case 1:
            text.text = "Requests for Me"
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return outRequests.count
        } else if section == 1{
            return inRequests.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestTableViewCell
        var request: Request
        if indexPath.section == 0 {
            request = outRequests[indexPath.row]
        } else {
            request = inRequests[indexPath.row]
        }
        cell.update(with: request)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Approve") { (action, view, completionHandler) in
            let requestId = (indexPath.section == 0 ? self.outRequests : self.inRequests)[indexPath.row].id
            self.requestController.approveInRequest(withId: requestId)
            completionHandler(true)
        }
        editAction.backgroundColor = .systemGreen
        editAction.image = UIImage(systemName: "checkmark")

        let deleteAction = UIContextualAction(style: .normal, title: "Deny") { (action, view, completionHandler) in
            let requestId = (indexPath.section == 0 ? self.outRequests : self.inRequests)[indexPath.row].id
            self.requestController.denyInRequest(withId: requestId)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "xmark")

        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return inRequests[indexPath.row].approved == nil
        }
        return false
    }
    
    private func setMyselfToSelected() {
        self.tabBarController?.selectedIndex = 2
    }

}
