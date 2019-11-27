//
//  UserController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 10/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation
import RxSwift

class UserController {
    
    static let shared = UserController()
    
    let loginController = LoginController.shared
    let dispose = DisposeBag()
    let loggedInUser = BehaviorSubject<User?>(value: nil)
    let users = BehaviorSubject<[User]?>(value: nil)
    
    private var _loggedInObject: LoginObject!
    private var _loggedInUser: User!
    private var _users: [User] = []
    
    private init() {
        loginController.loggedIn.subscribe({
            if let loginObject = $0.element! {
                self.fetchUserObjects(loginObject)
                self._loggedInObject = loginObject
            }
        }).disposed(by: dispose)
    }
    
    public func fetchUserObjects (_ loginObject: LoginObject) {
        let url = URL(string: "https://ishare-economy-backend.herokuapp.com/API/users/\(loginObject.id)/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        request.setValue("Bearer \(loginObject.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            var users: [User] = []
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
             if let usersJSON = responseJSON as? [[String: Any]] {
                for userJSON in usersJSON {
                    let lending = LendObjectController.lendobjects(fromJSON: userJSON, usingCollection: "lending")
                    let using = LendObjectController.lendobjects(fromJSON: userJSON, usingCollection: "using")
                    let user = User(
                        id: userJSON["_id"] as! String,
                        firstname:  userJSON["firstname"] as! String,
                        lastname: userJSON["lastname"] as! String,
                        address: userJSON["address"] as! String,
                        distance: Int(truncating: userJSON["distance"] as! NSNumber),
                        rating: Int(truncating: userJSON["rating"] as! NSNumber),
                        lending: lending,
                        using: using)
                    if user.id == loginObject.id {
                        self._loggedInUser = user
                        self.loggedInUser.onNext(user)
                    } else {
                        users.append(user)
                    }
                }
                self._users = users
                self.users.onNext(users)
            }
        }
        task.resume()
    }
    
    public func addObject(title: String, description: String, type: LendObjectType, ownerId: String, ownerName: String) {
        let url = URL(string: "https://ishare-economy-backend.herokuapp.com/API/users/\(self._loggedInObject!.id)/lending")!
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        request.setValue("Bearer \(self._loggedInObject!.token)", forHTTPHeaderField: "Authorization")
        let jsonDict = ["name": title, "description": description, "type": type.toString(), "owner": ["id": ownerId, "name": ownerName]] as [String : Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            // Post Succesfull, new object returned
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let objectJSON = responseJSON as? [String: Any] {
                    if let lendobject = LendObjectController.lendObject(fromJSON: objectJSON) {
                        self._loggedInUser.lending.append(lendobject)
                        self.loggedInUser.onNext(self._loggedInUser)
                    }
                }
        }
        task.resume()
    }
}
