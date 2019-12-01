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
    
    let requests = BehaviorSubject<[Request]?>(value: nil)
    
    private var loginObject: LoginObject? = nil
    private let userController = UserController.shared
    private var users: [User] = []
    
    private init() {
        
       userController.users.subscribe({
            if let users = $0.element as? [User] {
                self.users = users
            }
        }).disposed(by: dispose)
        LoginController.shared.loggedIn.subscribe({
            if let loginObject = $0.element {
                self.loginObject = loginObject
                self.fetchRequests(withId: self.loginObject!.id, forMe: true)
                self.fetchRequests(withId: self.loginObject!.id, forMe: false)
            }
        }).disposed(by: dispose)
    }
    
    func fetchRequests(withId userId: String, forMe: Bool) {
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
            self.requests.onNext(requests)
        }
        task.resume()
    }
    
    private func findObject(by id: String) -> LendObject? {
        return self.users.flatMap { $0.lending }.first(where: {$0.id == id})
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
        let toDate = Date.fromUTCString(toDateString),
        let approved = requestJSON["approved"] as? Bool {
            let request = Request(id: id, source: source, object: object, fromDate: fromDate, toDate: toDate, approved: approved)
            return request
        }
        
        return nil
    }
}
