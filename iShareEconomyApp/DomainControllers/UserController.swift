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
    let loginController = LoginController()
    let dispose = DisposeBag()
    let loggedInUser = BehaviorSubject<User?>(value: nil)
    let users = BehaviorSubject<[User]?>(value: nil)
    
    init() {
        loginController.loggedIn.subscribe({
            if let loginObject = $0.element! {
                self.fetchUserObjects(loginObject)
            }
        }).disposed(by: dispose)
    }
    
    func fetchUserObjects (_ loginObject: LoginObject) {
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
                        self.loggedInUser.onNext(user)
                        print("loggedInuser")
                    } else {
                        users.append(user)
                    }
                }
                self.users.onNext(users)
                print("other users")
            }
        }
        task.resume()
    }
}
