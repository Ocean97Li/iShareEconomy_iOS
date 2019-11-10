//
//  PhotoInfoController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 07/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation
import RxSwift

class LoginController {
    
    let loggedIn = BehaviorSubject<LoginObject?>(value: nil)
    let loginError = BehaviorSubject<String?>(value: nil)
    
    init() {
        loggedIn.onNext(loadFromFile())
    }
    
    func postLogin(username: String, password: String) -> Void {
        // create post request
       let url = URL(string: "https://ishare-economy-backend.herokuapp.com/API/users/login")!
       let jsonDict = ["username": username, "password": password]
       let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])

       var request = URLRequest(url: url)
       request.httpMethod = "post"
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                if let token = responseJSON["token"] as? String {
                    let response = self.decode(jwtToken: token) as [String: Any]
                    let user = response["user"] as! [String: Any]
                    
                    let exp = String(response["exp"] as! Int)
                    let expInt = Int(exp, radix: 10)!
                    let expDate = Date(timeIntervalSince1970: TimeInterval(expInt))
                    
                    let loginObject = LoginObject(id: user["_id"] as! String, username: user["username"] as! String, expires: expDate)
                    self.saveToFile(loginObject)
                    self.loggedIn.onNext(loginObject)
                    
                } else {
                    if let message = responseJSON["message"] as? String {
                        self.loginError.onNext(message)
                    }
                }
            }
        }

        task.resume()
        
    }
    
    private func decode(jwtToken jwt: String) -> [String: Any] {
      let segments = jwt.components(separatedBy: ".")
      return decodeJWTPart(segments[1]) ?? [:]
    }

    private func base64UrlDecode(_ value: String) -> Data? {
      var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

      let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
      let requiredLength = 4 * ceil(length / 4.0)
      let paddingLength = requiredLength - length
      if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 = base64 + padding
      }
      return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }

    private func decodeJWTPart(_ value: String) -> [String: Any]? {
      guard let bodyData = base64UrlDecode(value),
        let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
          return nil
      }

      return payload
    }
    
    private func saveToFile(_ loginObject: LoginObject) {
        let encoder = PropertyListEncoder()
        let encodedLoginObject = try? encoder.encode(loginObject)
        try? encodedLoginObject?.write(to: ActiveURL, options: .noFileProtection)
    }
    
    private func loadFromFile() -> LoginObject? {
        let decoder = PropertyListDecoder()
        if let retrieved = try? Data(contentsOf: ActiveURL),
            let decoded = try? decoder.decode(LoginObject.self, from: retrieved) {
            return decoded
        }
        return nil
    }
    
    private var ActiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
       return documentsDirectory.appendingPathComponent("login").appendingPathExtension("plist")
    }
}
