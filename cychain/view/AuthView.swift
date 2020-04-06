//
//  LogInView.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/04/05.
//  Copyright © 2020 高田英明. All rights reserved.
//

import UIKit

protocol AuthViewDelegate: class {
    func text(email: String, password: String)
}


class AuthView: UIView {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var authErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passwordResetButton: UIButton!
    
    
    
    let securityButton = UIButton(type: .custom)
    let showImage = UIImage(named: "eye5")
    let hideImage = UIImage(named: "eye4")
    weak var delegate: AuthViewDelegate?

    
    class func instance() -> AuthView {
          return UINib(nibName: "LoginView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! AuthView
      }
    
    //textFieldをアンダーラインのみにする
    func textFieldUnderLine() {
        emailTextField.underLine(height: 1.0, color: .white)
        passwordTextField.underLine(height: 1.0, color: .white)
    }
    
    //メールアイコンとパスワードアイコンをtextFieldに設置
    func textFieldIconSet(textField: UITextField, andImage image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20 , height: 20))
        let iconMarginView: UIView = UIView(frame:
            CGRect(x: 0, y: 0, width: 30, height: 20))
        iconMarginView.addSubview(iconView)
        iconView.image = image
        textField.leftView = iconMarginView
        textField.leftViewMode = .always
    }
    //　↑を適合
    func textFieldLeftIconSet() {
         textFieldIconSet(textField: emailTextField, andImage: UIImage(named: "mail")!)
         textFieldIconSet(textField: passwordTextField, andImage: UIImage(named: "password")!)
     }
    
    //paswprdTextFieldの左に伏せ字用の目のマーク設置
     func addPasswordEyeButton() {
        securityButton.setImage((hideImage), for: .normal)
         securityButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 5, right: 0)
         securityButton.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
         securityButton.addTarget(self, action: #selector(self.security), for: .touchUpInside)
         passwordTextField.rightView = securityButton
         passwordTextField.rightViewMode = .always
     }
     @objc func security(_ sender: Any) {
         var show = true
         passwordTextField.isSecureTextEntry.toggle()
         show.toggle()
         let eye = show ? hideImage: showImage
         securityButton.setImage(eye, for: .normal)
     }
    
    //SignUpボタンを有効
    func loginButtonEnabled() {
         logInButton.isEnabled = true
         logInButton.backgroundColor = .white
         logInButton.setTitleColor(.black, for: .normal)
         logInButton.layer.borderWidth = 0
     }
     
    //SignUpvボタン無効
     func loginButtonInvalid() {
         logInButton.isEnabled = false
         logInButton.backgroundColor = .clear
         logInButton.setTitleColor(.lightGray, for: .normal)
         logInButton.layer.borderColor = UIColor.lightGray.cgColor
         logInButton.layer.borderWidth = 2
     }
    
    func signUpUI() {
        authErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        passwordResetButton.isHidden = true
    }
    
    func errorLabelHidden() {
        authErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }
    
    
    
    @IBAction func SignInButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text?.deleteSpace(),
            let pass = passwordTextField.text?.deleteSpace()
            else { return }
        
        self.delegate?.text(email: email, password: pass)  
    }
    

}
