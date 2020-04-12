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
        let errorCode = AuthErrorCode(rawValue: error._code)
        let signUp = SignUpViewController()
        let e = signUp.authViewInstance.emailTextField.text ?? ""
        let mail = e.deleteSpace()
        let ahthView = AuthView()
        _ = error.localizedDescription

        switch errorCode {
        case .weakPassword://パスワード文字数エラー
            self.weakPasswordAlert()
            ahthView.passwordErrorLabel.isHidden = false
        
        case .invalidEmail://無効アドレス
            invalidEmailAlert()
            ahthView.authErrorLabel.isHidden = false
        
        default:
            if mail.contains("@gmail.com") {
                log.debug("@gmail.com")
                registGoogleAdressAlert()
            } else {
                log.debug("default erroe")
                noRegistationAlert()
            }
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
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        authViewInstance.passwordErrorLabel.isHidden = true
        authViewInstance.authErrorLabel.isHidden = true
    }
}



