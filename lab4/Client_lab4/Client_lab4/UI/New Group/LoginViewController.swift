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
        askAboutIP()
    }
    
    private func askAboutIP() {
        let alert = UIAlertController(title: "Enter server ip or empty for default", message: nil, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: .none)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert, weak self] (_) in
            if let text = alert?.textFields![0].text  {
                if !text.isEmpty {
                    ServerRepository.shared.ip = text
                }
            } else {
                self?.askAboutIP()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        defer {
            loginTextField.text = .none
            passwordTextField.text = .none
        }
        guard
            let login = loginTextField.text,
            !login.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else {
                self.showAlert(title: "Ошибка", message: "Заполините асе поля")
                return
        }
        self.activityIndicator = UIActivityIndicatorView(style: .medium)
        self.activityIndicator!.frame = CGRect(x: self.view.center.x - 23,
                                               y: self.view.center.y - 123,
                                               width: 46,
                                               height: 46)
        self.activityIndicator!.startAnimating()
        self.view.addSubview(self.activityIndicator!)
        sendLoginRequests(login: login, password: password) { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
                self.activityIndicator?.removeFromSuperview()
            }
            if let error = error {
                switch error {
                case .server(let message):
                    self.showAlert(title: "Ошибка", message: message)
                default:
                    self.showAlert(title: "Ошибка", message: "что то не так")
                }
            } else {
                self.navigationController?.pushViewController(
                    OTPViewController.newInstance(),
                    animated: true)
            }
        }
    }
}

private extension LoginViewController {
    
    func sendLoginRequests(
        login: String,
        password: String,
        completionBlock: @escaping (ServerRepository.FileRepositoryErrorEnum?) -> ()) {
        DispatchQueue(label: "keys", qos: .userInitiated).async { [weak self] in
            ServerRepository.shared.getUserA(login: login) { result in
                switch result {
                case .success(let a):
                    let hashPassword = ClientHelper.nHash(a, text: password)
                    ServerRepository.shared.login(
                        login: login,
                        password: hashPassword,
                        key: AppState.shared.publicKey) { result in
                            switch result {
                            case .success:
                                AppState.shared.login = login
                                completionBlock(nil)
                            case .failure(let error):
                                completionBlock(error)
                            }
                    }
                case .failure(let error):
                    completionBlock(error)
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
