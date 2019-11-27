//
//  OTPViewController.swift
//  Client_lab4
//
//  Created by Ilya Sysoi on 11/26/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController {

    class func newInstance() -> OTPViewController {
        let vc = OTPViewController(nibName: "OTPViewController",
                                   bundle: nil)
        return vc
    }
    
    @IBOutlet weak var otpTextField: UITextField!
    private var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "OTP"
        otpTextField.delegate = self
        otpTextField.keyboardType = .numberPad
    }

    @IBAction func loginButtonHandler(_ sender: Any) {
        defer {
            otpTextField.text = .none
        }
        guard
            let otp = otpTextField.text,
            !otp.isEmpty
            else {
                self.showAlert(title: "Ошибка", message: "Заполините поле")
                return
        }
        
        self.activityIndicator = UIActivityIndicatorView(style: .medium)
        self.activityIndicator!.frame = CGRect(x: self.view.center.x - 23,
                                               y: self.view.center.y - 123,
                                               width: 46,
                                               height: 46)
        self.activityIndicator!.startAnimating()
        self.view.addSubview(self.activityIndicator!)
        
        checkOTPRequest(otp: otp) { [weak self] error in
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
                    FilesListViewController.newInstance(),
                    animated: true)
            }
        }
    }
}

private extension OTPViewController {
    
    func checkOTPRequest(
        otp: String,
        completionBlock: @escaping (ServerRepository.FileRepositoryErrorEnum?) -> ()) {
        ServerRepository.shared.checkOTP(login: AppState.shared.login!, otp: otp) { result in
            switch result {
            case .success(let key, let token):
                AppState.shared.token = token
                AppState.shared.serverKey = key
                completionBlock(nil)
            case .failure(let error):
                completionBlock(error)
            }
        }
    }
    
}

extension OTPViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}

