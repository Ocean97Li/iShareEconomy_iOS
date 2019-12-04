//
//  CreateRequestTableViewController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 03/12/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit
import RxSwift

class CreateRequestTableViewController: UITableViewController {
        
    @IBOutlet var lendObject: LendObjectView!
    
    @IBOutlet var fromDateInputCell: DatePickerTableViewCell!
    
    @IBOutlet var toDateInputCell: DatePickerTableViewCell!
    
    @IBOutlet var sendButton: UIButton!
    
    var object: LendObject? = nil
    
    let requestController = RequestController.shared
    let loginController = LoginController.shared
    
    let dispose = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        self.lendObject!.object = object!
        
        sendButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        sendButton.layer.cornerRadius = 5
        sendButton.layer.borderWidth = 1
        sendButton.layer.borderColor = UIColor.gray.cgColor
        
        fromDateInputCell.emits = true
        CellCoordinator.shared.datePickerDate.subscribe({
            if let date = $0.element {
                self.toDateInputCell.minDate = date
            }
        }).disposed(by: dispose)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateRequestTableViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func buttonClicked() {
        let from = fromDateInputCell.date!
        let to = toDateInputCell.date!
        requestController.addOutRequest(objectId: object!.id, ownerId: object!.owner.userId, fromDate: from, toDate: to)
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func switchToDataTab() {
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(switchToDataTabCont), userInfo: nil, repeats: false)
    }

    @objc func switchToDataTabCont(){
        self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.tabBarController!.selectedIndex = 2
    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 4
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell: LendObjectTableViewCell
//            cell = tableView.dequeueReusableCell(withIdentifier: "LendObjectCell", for: indexPath) as! LendObjectTableViewCell
//            cell.selectionStyle = .none
//            cell.update(self.object!)
//            return cell
//        } else if indexPath.section < 3{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "DateInputCell", for: indexPath) as! DatePickerTableViewCell
//            if let waitinglist = object?.waitinglist {
//                cell.minDate = waitinglist.last?.toDate.adding(.day, 1)
//            } else if self.object!.currentUser != nil {
//                cell.minDate = self.object!.currentUser?.toDate.adding(.day, 1)
//            }
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
//            let button = (cell.contentView.subviews[0]) as! UIButton
//            button.layer.cornerRadius = 5
//            button.layer.borderWidth = 1
//            button.layer.borderColor = UIColor.gray.cgColor
//            button.addTarget(self, action:  #selector(buttonClicked), for: .touchUpInside)
//            return cell
//        }
//       
//    }
//    
//    @objc func buttonClicked() {
//        self.requestController.addOutRequest(source: object!.owner, objectId: object!.id, fromDate: fromDate!, toDate: toDate!)
//    }
//    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UITableViewHeaderFooterView()
//        let text = UITextView()
//        switch section {
//        case 0:
//            text.text = "I want to lend:"
//        case 1:
//            text.text = "Starting from:"
//        case 2:
//            text.text = "Untill:"
//        default:
//            text.text = ""
//        }
//        text.font = UIFont.boldSystemFont(ofSize: 25.0)
//        text.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 0);
//        header.textLabel?.text = text.text
//        header.backgroundColor = .white
//        return header
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 45;
//    }
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
