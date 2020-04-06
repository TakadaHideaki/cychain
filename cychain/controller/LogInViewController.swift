//
//  loginViewController.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/01/23.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var accountErrorLabel: UILabel!
    @IBOutlet weak var loginButton:Button!
    
    
    var authModel: AuthModel?
       var authView: AuthView?
       let logInView = AuthView.instance()
    
    
//
//    let passwordShow_Hide_Button = UIButton(type: .custom)
//    let showImage = UIImage(named: "eye5")
//    let hideImage = UIImage(named: "eye4")
    
    
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
//        emailTextField.delegate = self
//        passwordTextField.delegate = self
//        passwordErrorLabel.isHidden = true
//        accountErrorLabel.isHidden = true
//        passwordTextField.isSecureTextEntry = true
//
//        emailTextField.underLine(height: 1.0, color: .white)
//        passwordTextField.underLine(height: 1.0, color: .white)
//
//        textFieldIconSet(textField: emailTextField, andImage: UIImage(named: "mail")!)
//        textFieldIconSet(textField: passwordTextField, andImage: UIImage(named: "password")!)
//        addPasswordEyeButton()
//        loginButtonInvalid()
//        passwordShow_Hide_Button.setImage((hideImage), for: .normal)
        
        
        logInView.emailTextField.delegate = self
          logInView.passwordTextField.delegate = self
          logInView.passwordTextField.isSecureTextEntry = true
        logInView.errorLabelHidden() //エラーラベル非表示
          logInView.textFieldUnderLine()   // textFieldをアンダーラインのみ
          logInView.textFieldLeftIconSet() // メール、パスワードアイコン設置
          logInView.addPasswordEyeButton() // 伏せ字用アイマーク設置
          logInView.loginButtonInvalid()  // signUpボタン無効
          logInView.logInButton.setTitle("Log In", for: .normal)
    }
    
//    func loginButtonEnabled() {
//        loginButton.isEnabled = true
//        loginButton.backgroundColor = .white
//        loginButton.setTitleColor(.black, for: .normal)
//        loginButton.layer.borderWidth = 0
//    }
    
//    func loginButtonInvalid() {
//        loginButton.isEnabled = false
//        loginButton.backgroundColor = .clear
//        loginButton.setTitleColor(.lightGray, for: .normal)
//        loginButton.layer.borderColor = UIColor.lightGray.cgColor
//        loginButton.layer.borderWidth = 2
//    }
    
   
    
    //mail入力後passwordにカーソルを自動移動
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        emailTextField.resignFirstResponder()
//        passwordTextField.resignFirstResponder()
//        textField.resignFirstResponder() // 今フォーカスが当たっているTextFieldからフォーカスを外す
//        let nextTag = textField.tag + 1  // 次のTag番号を持っているTextFieldがあれば、フォーカスする
//        if let nextTextField = self.view.viewWithTag(nextTag) {
//            nextTextField.becomeFirstResponder()
//        }
//        return true
//    }
    
    //textFildの左アイコン設置
//    private func textFieldIconSet(textField: UITextField, andImage image: UIImage) {
//        let iconView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20 , height: 20))
//        let iconMarginView: UIView = UIView(frame:
//            CGRect(x: 0, y: 0, width: 30, height: 20))
//        iconMarginView.addSubview(iconView)
//        iconView.image = image
//        textField.leftView = iconMarginView
//        textField.leftViewMode = .always
//    }
    
    //passwordTextFieldの左に伏せ字用目のアイコン設置
//    private func addPasswordEyeButton() {
//        passwordShow_Hide_Button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 5, right: 0)
//        passwordShow_Hide_Button.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
//        passwordShow_Hide_Button.addTarget(self, action: #selector(self.security), for: .touchUpInside)
//        passwordTextField.rightView = passwordShow_Hide_Button
//        passwordTextField.rightViewMode = .always
//    }
//    @objc func security(_ sender: Any) {
//        var show = true
//        passwordTextField.isSecureTextEntry.toggle()
//        show.toggle()
//        let show_hideImage = show ? hideImage: showImage
//        passwordShow_Hide_Button.setImage(show_hideImage, for: .normal)
//    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
//            loginButtonInvalid()
//        } else {
//           loginButtonEnabled()
//        }
//        return true
//    }
    
    //    メールでログイン
    @IBAction func mailSginInAction(_ sender: Any) {
        
        guard let mail = emailTextField.text?.deleteSpace(),
            let pass = passwordTextField.text?.deleteSpace()
            else { return }
        
        authModel?.LogIn(mail: mail, pass: pass)
    }
    
    //　パスワードを忘れ
    @IBAction func passwordReset(_ sender: Any) {
        
        if let mail = emailTextField.text?.deleteSpace() {
            if mail.isEmpty {
                passwordEnptyAlert()
            }else {
                authModel?.passwordReset(email: mail)
            }
        } else {
            passwordEnptyAlert()
        }
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        passwordErrorLabel.isHidden = true
        accountErrorLabel.isHidden = true
    }
}

extension LogInViewController: AuthViewDelegate {
    func text(email: String, password: String) {
        authModel?.LogIn(mail: email, pass: password)
    }
    
    
}


extension LogInViewController: AuthModelDelegate {
    
    func toHome() {
        presentVC(view: "tabVC", animation: true)

    }
    
    func errorDidOccur(error: Error) {
        let errorCode = AuthErrorCode(rawValue: error._code)
        let mail = emailTextField.text?.deleteSpace() ?? ""
        
        switch errorCode {
        case .weakPassword://パスワード文字数エラー
            weakPasswordAlert()
            self.passwordErrorLabel.isHidden = false

        
        case .invalidEmail://無効アドレス
            invalidEmailAlert()
            self.accountErrorLabel.isHidden = false
        
        default:
            if mail.contains("@gmail.com") {
                registGoogleAdressAlert()
            } else {
                noRegistationAlert()
            }
        }
    }
    
    
    func passwordErrorAlert() {
        self.alert(title: "このアドレスは登録されてません", message: "", actiontitle: "OK")
    }
    
    func passwordResetSuccessAlert() {
        self.alert(title: "メールを送信しました。", message: "メールでパスワードの再設定を行ってください。", actiontitle: "OK")
    }
    
    func passwordEnptyAlert() {
        self.alert(title: "メールをアドレスを入力して下さい", message: "", actiontitle: "OK")
    }
    
    func weakPasswordAlert() {
        self.alert(title: "パスワードは６文字以上で入力して下さい", message: "", actiontitle: "OK")
    }
    func invalidEmailAlert() {
        self.alert(title: "メールアドレスが正しくありません", message: "", actiontitle: "OK")
    }
    func noRegistationAlert() {
        self.alert(title: "登録がありません", message: "", actiontitle: "OK")
    }
    func registGoogleAdressAlert() {
        self.alert(title: "Googleアドレスでの登録", message: "Googleログインからログインして下さい", actiontitle: "OK")
    }
}

extension LogInViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if logInView.emailTextField.text!.isEmpty || logInView.passwordTextField.text!.isEmpty {
            logInView.loginButtonInvalid()
        } else {
           logInView.loginButtonEnabled()
        }
        return true
    }

    
}

