//
//  sighUp.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/05/01.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var sinupButton: Button!
    
    
    var authModel: AuthModel?
    let passwordShow_Hide_Button = UIButton(type: .custom) //パスワードを伏せ字にするボタン
    let showImage = UIImage(named: "eye5") //目のマーク
    let hideImage = UIImage(named: "eye4") //目にスラッシュ（伏せ字用）
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intializeModel()
        initializeUI()
    }
    
    func intializeModel() {
        authModel = AuthModel()
        authModel?.delegate = self
    }
    
    func initializeUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        
        emailTextField.underLine(height: 1.0, color: .white)
        passwordTextField.underLine(height: 1.0, color: .white)
        
        passwordShow_Hide_Button.setImage((hideImage), for: .normal)
        addLeftIcon(textField: emailTextField, andImage: UIImage(named: "mail")!)
        addLeftIcon(textField: passwordTextField, andImage: UIImage(named: "password")!)
        addPasswordEyeButton()
    }
    
    //paswprdTextFieldの左に伏せ字用の目のマーク設置
    func addPasswordEyeButton() {
        passwordShow_Hide_Button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 5, right: 0)
        passwordShow_Hide_Button.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        passwordShow_Hide_Button.addTarget(self, action: #selector(self.security), for: .touchUpInside)
        passwordTextField.rightView = passwordShow_Hide_Button
        passwordTextField.rightViewMode = .always
    }
    //伏せ字の処理
    @objc func security(_ sender: Any) {
        var show = true
        passwordTextField.isSecureTextEntry.toggle()
        show.toggle()
        let show_hideImage = show ? hideImage: showImage
        passwordShow_Hide_Button.setImage(show_hideImage, for: .normal)
    }
    
    //textField左にアイコン設置
    func addLeftIcon(textField: UITextField, andImage image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20 , height: 20))
        let iconMarginView: UIView = UIView(frame:
            CGRect(x: 0, y: 0, width: 30, height: 20))
        iconMarginView.addSubview(iconView)
        iconView.image = image
        textField.leftView = iconMarginView
        textField.leftViewMode = UITextField.ViewMode.always
    }
    
    //mail入力後passwordにカーソルを自動移動
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    
    //メールでアカウント作成
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let passord = passwordTextField.text
            else { return }
        authModel?.signUp(emai: email, password: passord)
    }
}



extension SignUpViewController: AuthModelDelegate {
    
    func didSignUp() {
        presentVC(view: "tabVC", animation: true)
    }
}

