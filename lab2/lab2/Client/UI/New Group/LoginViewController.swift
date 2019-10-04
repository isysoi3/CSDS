//
//  LoginViewController.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/4/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private var activityIndicator: UIActivityIndicatorView?
    
    class func newInstance() -> LoginViewController {
        let vc = LoginViewController(nibName: "LoginViewController",
                                     bundle: nil)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Authorization"
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        guard
            let login = loginTextField.text,
            !login.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else {
                loginTextField.text = .none
                passwordTextField.text = .none
                let alert = UIAlertController(title: "Ошибка", message: "Заполините асе поля", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Хорошо", style: .default))
                present(alert, animated: true)
                return
        }
        self.activityIndicator = UIActivityIndicatorView(style: .medium)
        self.activityIndicator!.frame = CGRect(x: self.view.center.x - 23,
                                               y: self.view.center.y - 123,
                                               width: 46,
                                               height: 46)
        self.activityIndicator!.startAnimating()
        self.view.addSubview(self.activityIndicator!)
        
        DispatchQueue(label: "keys", qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            AppState.shared.generateKeys()
            ServerRepository.shared.login(
                login: login,
                password: password,
                key: AppState.shared.publicKey) { result in
                    DispatchQueue.main.async {
                        self.activityIndicator?.stopAnimating()
                        self.activityIndicator?.removeFromSuperview()
                    }
            }
           
        }
        
        
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()

        return true
    }
}
