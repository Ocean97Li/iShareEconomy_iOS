//
//  RequestController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 30/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation
import RxSwift

class RequestController {
    static let shared = RequestController()
    private let dispose = DisposeBag()
    
    // Requests for me
    let inRequests = BehaviorSubject<[Request]?>(value: nil)
    // Requests by me
    let outRequests = BehaviorSubject<[Request]?>(value: nil)
    // Request sent
    let requestSent = BehaviorSubject<Request?>(value: nil)
    
    private var loginObject: LoginObject? = nil
    private let userController = UserController.shared
    private var users: [User] = []
    private var loggedInUser: User? = nil
    private var auth = ""
    
    private init() {
        
        LoginController.shared.authToken.subscribe({
            if let authToken = $0.element as? String {
                self.auth = authToken
            }
        }).disposed(by: dispose)
        
       userController.users.subscribe({
            if let users = $0.element as? [User] {
                self.users = users
            }
        }).disposed(by: dispose)
        
        userController.loggedInUser.subscribe({
            if let loggedInUsers = $0.element as? User {
                self.loggedInUser = loggedInUsers
            }
        }).disposed(by: dispose)
        
        LoginController.shared.loggedIn.subscribe({
            if let loginObject = $0.element {
                self.loginObject = loginObject
                self.fetchRequests(withUserId: self.loginObject!.id, forMe: true)
                self.fetchRequests(withUserId: self.loginObject!.id, forMe: false)
            }
        }).disposed(by: dispose)
    }
    
    func fetchRequests(withUserId userId: String, forMe: Bool) {
        var requestBox: String
        if forMe {
            requestBox = "inRequest"
        } else {
            requestBox = "outRequest"
        }
        let url = URL(string: "https://ishare-economy-backend.herokuapp.com/API/users/\(userId)/\(requestBox)")!
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        request.setValue("Bearer \(loginObject!.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            var requests: [Request] = []
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let requestsJSON = responseJSON as? [[String: Any]] {
                for requestJSON in requestsJSON {
                    let request = self.extractRequestFromJSON(requestJSON)
                    if let request = request {
                        requests.append(request)
                    }
                }
            }
            if forMe { //Add to requests for me
                self.inRequests.onNext(requests)
            } else { //Add to requests made by me
                self.outRequests.onNext(requests)
            }
        }
        task.resume()
    }
    
    func approveInRequest(withId requestId: String) {
        let url = URL(string: "https://ishare-economy-backend.herokuapp.com/API/users/\(loggedInUser!.id)/inRequest/\(requestId)/approve")!
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        request.setValue("Bearer \(loginObject!.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            // Succeeded
            self.fetchRequests(withUserId: self.loggedInUser!.id, forMe: true)
        }
        task.resume()
    }
    
    func denyInRequest(withId requestId: String) {
        let url = URL(string: "https://ishare-economy-backend.herokuapp.com/API/users/\(loggedInUser!.id)/inRequest/\(requestId)/deny")!
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        request.setValue("Bearer \(loginObject!.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            // Succeeded
            self.fetchRequests(withUserId: self.loggedInUser!.id, forMe: true)
        }
        task.resume()
    }
    
    func addOutRequest(objectId: String, ownerId: String, fromDate: Date, toDate: Date) {
        let source = loggedInUser!
        let jsonDict = [
            "source": ["id": source.id, "name": source.fullname],
            "object": ["_id": objectId, "owner": ["id": ownerId]],
            "fromdate": fromDate.removeTime().toUTCString(),
            "todate": fromDate.removeTime().toUTCString()
            ] as [String : Any]
        
        let url = URL(string: "https://ishare-economy-backend.herokuapp.com/API/users/\(loggedInUser!.id)/outRequest")!
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        request.setValue("Bearer \(auth)", forHTTPHeaderField: "Authorization")
       
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            // Post Succesfull, new object returned
            self.fetchRequests(withUserId: self.loggedInUser!.id, forMe: false)
        }
        task.resume()
    }
    
    private func findObject(by id: String) -> LendObject? {
        var usersALL = self.users
        if let loggedInUser = loggedInUser {
             usersALL.append(loggedInUser)
        }
        return usersALL.flatMap { $0.lending }.first(where: {$0.id == id})
    }
    
    public func extractRequestFromJSON(_ requestJSON: [String: Any]) -> Request? {
        if let id = requestJSON["_id"] as? String,
        let sourceJSON = requestJSON["source"] as? [String: Any],
        let source = LendObjectController.extractObjectOwnerFromJSON(sourceJSON),
        let objectJSON = requestJSON["object"] as? [String: Any],
        let objectIdString = objectJSON["_id"] as? String,
        let object = self.findObject(by: objectIdString),
        let fromDateString = requestJSON["fromdate"] as? String,
        let fromDate = Date.fromUTCString(fromDateString),
        let toDateString = requestJSON["todate"] as? String,
        let toDate = Date.fromUTCString(toDateString) {
            let approved = requestJSON["approved"] as? Bool
            let request = Request(id: id, source: source, object: object, fromDate: fromDate, toDate: toDate, approved: approved)
            return request
        }
        
        return nil
    }
}
