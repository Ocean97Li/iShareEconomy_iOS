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
        loginController.postLogin(username: user, password: password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.isEnabled = false
        logInButton.backgroundColor = .gray
        // Do any additional setup after loading the view.
        
        loginController.loggedIn.subscribe({
            if let login = $0.element! {
                DispatchQueue.main.async {
                    self.usernameTextfield.text = login.username
                    if !login.expired {
                        self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                    }
                }
            }
        }).disposed(by: dispose)
        
        loginController.loginError.subscribe({
            if let errorMessage = $0.element! {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Login Failed", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
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

