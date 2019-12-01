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
                }
            }
        })
        self.inSubscription?.disposed(by: dispose)
        
        self.inSubscription = requestController.outRequests.subscribe({
            if let requests = $0.element as? [Request] {
                DispatchQueue.main.async {
                    self.outRequests = requests
                    self.tableView.reloadData()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
