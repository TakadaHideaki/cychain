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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authViewInstance.logInUI()
    }
    
    override func logIn(email: String, password: String) {
        authModel?.LogIn(mail: email, pass: password)
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
            self.weakPasswordAlert()
            authViewInstance.passwordErrorLabel.isHidden = false
            
        //無効アドレス
        case ("There is no user record corresponding to this identifier. The user may have been deleted."):
            invalidEmailAlert()
            authViewInstance.authErrorLabel.isHidden = false
            
        default:
            if mailText.contains("@gmail.com") {
                log.debug("@gmail.com")
                registGoogleAdressAlert()
            } else {
                log.debug("default erroe")
                noRegistationAlert()
            }
            return
        }
    }
    
    
    override func passwordErrorAlert() {
        self.alert(title: "このアドレスは登録されてません", message: "", actiontitle: "OK")
    }
    
    override func passwordResetSuccessAlert() {
        self.alert(title: "メールを送信しました。", message: "メールでパスワードの再設定を行ってください。", actiontitle: "OK")
    }
    
    func passwordEmptyAlert() {
        self.alert(title: "メールをアドレスを入力して下さい", message: "", actiontitle: "OK")
    }
    
    func registGoogleAdressAlert() {
        self.alert(title: "Googleアドレスでの登録", message: "Googleログインからログインして下さい", actiontitle: "OK")
    }
    
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let authview = authView  else { return true }
        
        if authViewInstance.emailTextField.text!.isEmpty || authViewInstance.passwordTextField.text!.isEmpty {
            authview.signUpButtonInvalid(button: authViewInstance.logInButton)
        } else {
            authview.signUpButtonEnabled(button: authViewInstance.logInButton)
        }
        
        
        authViewInstance.passwordErrorLabel.isHidden = true
        authViewInstance.authErrorLabel.isHidden = true
        return true
    }
}



