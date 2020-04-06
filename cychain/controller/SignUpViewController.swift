//
//  sighUp.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/05/01.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    var authModel: AuthModel?
    var authView: AuthView?
    let logInView = AuthView.instance()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logInView.frame = self.view.frame
        self.view.addSubview(logInView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set_View_Model()
        initializeUI()
    }
    
    func set_View_Model() {
        authModel = AuthModel()
        authView = AuthView()
        authModel?.delegate = self
        authView?.delegate = self
    }
    
    func initializeUI() {
        logInView.emailTextField.delegate = self
        logInView.passwordTextField.delegate = self
        logInView.passwordTextField.isSecureTextEntry = true
        logInView.textFieldUnderLine()   // textFieldをアンダーラインのみ
        logInView.textFieldLeftIconSet() // メール、パスワードアイコン設置
        logInView.addPasswordEyeButton() // 伏せ字用アイマーク設置
        logInView.loginButtonInvalid()  // signUpボタン無効
        logInView.signUpUI() //signUp用にラベル等を非表示
        logInView.logInButton.setTitle("Sign Up", for: .normal)
    }
}


extension SignUpViewController: AuthViewDelegate {
    func text(email: String, password: String) {
        
        authModel?.signUp(emai: email, password: password)
    }
}


extension SignUpViewController: AuthModelDelegate {

    //Home画面へ
    func toHome() {
        presentVC(view: "tabVC", animation: true)
    }
    
    //ahthのエラーハンドリング
    func errorDidOccur(error: Error){
        
        let errorCode = AuthErrorCode(rawValue: error._code)
        
        switch errorCode {
        case .weakPassword://パスワード文字数不足
            weakPasswordAlert()
            
        case .invalidEmail://無効アドレス
            invalidEmailAlert()
            
        case .emailAlreadyInUse://既につ使われているアドレス
            emailAlreadyInUseAlert()
            
        default: noRegistationAlert()
        }
    }
    func weakPasswordAlert() {
          self.alert(title: "パスワードは６文字以上で入力して下さい", message: "", actiontitle: "OK")
      }
    func invalidEmailAlert() {
          self.alert(title: "メールアドレスが正しくありません", message: "", actiontitle: "OK")
      }
    func emailAlreadyInUseAlert() {
        self.alert(title: "このメールアドレスはすでに使われています", message: "", actiontitle: "OK")
    }
    func noRegistationAlert() {
          self.alert(title: "エラー", message: " エラーが起きました\nしばらくしてから再度お試し下さい", actiontitle: "OK")
      }
    func passwordErrorAlert(){}
    func passwordResetSuccessAlert(){}
}


extension SignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //signUpボタン有効無効切替
        if logInView.emailTextField.text!.isEmpty || logInView.passwordTextField.text!.isEmpty {
            logInView.loginButtonInvalid()
        } else {
            logInView.loginButtonEnabled()
        }
        return true
    }
    
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        logInView.emailTextField.resignFirstResponder()
    //        logInView.passwordTextField.resignFirstResponder()
    //        //mail入力後passwordにカーソルを自動移動
    //        textField.resignFirstResponder() // 今フォーカスが当たっているTextFieldからフォーカスを外す
    //        let nextTag = textField.tag + 1  // 次のTag番号を持っているTextFieldがあれば、フォーカスする
    //        if let nextTextField = self.view.viewWithTag(nextTag) {
    //            nextTextField.becomeFirstResponder()
    //        }
    //        return true
    //    }
}



