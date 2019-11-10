//
//  FirstViewController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 07/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: KUIViewController {
    
    var user: String = ""
    var password: String = ""
    let loginController = LoginController()
    let dispose = DisposeBag()
    
    @IBOutlet var usernameTextfield: UITextField!
    
    @IBOutlet var passwordtextField: UITextField!
    
    @IBOutlet var logInButton: UIButton!
    
    @IBAction func usernameEditAction(_ sender: UITextField) {
        editHappend()
    }
    
    @IBAction func passwordEditAction(_ sender: UITextField) {
        editHappend()
    }
    
    @IBAction func logInButtonTappedAction(_ sender: UIButton) {
        print("pressed")
        loginController.postLogin(username: user, password: password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.isEnabled = false
        logInButton.backgroundColor = .gray
        // Do any additional setup after loading the view.
        
        loginController.loggedIn.subscribe({
            if let login = $0.element! {
                print("segue right here")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                    print(login.username)
                    self.usernameTextfield.text = login.username
                }
            }
        }).disposed(by: dispose)
    }
    
    func editHappend() {
        if let user = usernameTextfield.text,
            let password = passwordtextField.text {
            self.user = user
            self.password = password
            if !user.isEmpty && !password.isEmpty {
                logInButton.isEnabled = true
                logInButton.backgroundColor = .black
            } else {
                logInButton.isEnabled = false
                logInButton.backgroundColor = .gray
            }
        }
    }
    
    


}

