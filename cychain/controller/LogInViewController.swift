//
//  loginViewController.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/01/23.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: SignUpViewController {
    
    override func initializeUI() {
        authViewInstance.logInUI()
    }
    

    override func authAction(email: String, password: String) {
       authModel?.logIn(mail: email, pass: password)
   }
    
    override func switchButtonEnabled() {
        
        guard let authview = authView  else { return }
        
        if authViewInstance.emailTextField.text!.isEmpty ||
            authViewInstance.passwordTextField.text!.isEmpty {
            authview.flag = true
            authview.buttonInvalid(button: authViewInstance.logInButton)
            
        } else {
            authview.flag = false
            authview.buttonInvalid(button: authViewInstance.logInButton)
        }
    }
    
    override func passwordReset(email: String) {
        if email.isEmpty {
            passwordEmptyAlert()
        }else {
            authModel?.passwordReset(email: email)
        }
    }
    
    override func logInerrorDidOccur(error: Error) {
        _ = AuthErrorCode(rawValue: error._code)
        let mailText = authViewInstance.emailTextField.text!.deleteSpace()
        let errorMessage = error.localizedDescription
        
        switch errorMessage {
        //パスワード文字数不足
        case ("The password is invalid or the user does not have a password."):
//            self.weakPasswordAlert()
            invalidEmailAlert()
            authViewInstance.passwordErrorLabel.isHidden = false
            
        //無効アドレス
        case ("There is no user record corresponding to this identifier. The user may have been deleted."):
            invalidEmailAlert()
            authViewInstance.authErrorLabel.isHidden = false
            
        default:
            if mailText.contains("@gmail.com") {
                registGoogleAdressAlert()
            } else {
                noRegistationAlert()
            }
            return
        }
        
    }
    
    
    override func passwordErrorAlert() {
        passworderrorAlert()
    }
    override func passwordResetSuccessAlert() {
        passwordresetSuccessAlert()
    }
    func passwordEmptyAlert() {
        passwordemptyAlert()
    }
    func registGoogleAdressAlert() {
        registGoogleadressAlert()
    }
    
    
//    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        guard let authview = authView  else { return true }
//        
//        if authViewInstance.emailTextField.text!.isEmpty || authViewInstance.passwordTextField.text!.isEmpty {
//            authview.flag = true
//            authview.buttonInvalid(button: authViewInstance.logInButton)
//        } else {
//            authView?.flag = false
//            authview.buttonInvalid(button: authViewInstance.logInButton)
//        }
//        
//        authViewInstance.passwordErrorLabel.isHidden = true
//        authViewInstance.authErrorLabel.isHidden = true
//        return true
//    }
}



