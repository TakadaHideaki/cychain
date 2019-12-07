//
//  loginViewController.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/01/23.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LogInViewController: UIViewController, UITextFieldDelegate {
 
 
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var accountErrorLabel: UILabel!
    @IBOutlet weak var loginButton:Button!
    
    let passwordShow_Hide_Button = UIButton(type: .custom)
    let showImage = UIImage(named: "eye5")
    let hideImage = UIImage(named: "eye4")
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        passwordErrorLabel.isHidden = true
        accountErrorLabel.isHidden = true
        
        passwordTextField.isSecureTextEntry = true
        
        emailTextField.underLine(height: 1.0, color: .white)
        passwordTextField.underLine(height: 1.0, color: .white)
        
        setIcon(textField: emailTextField, andImage: UIImage(named: "mail")!)
        setIcon(textField: passwordTextField, andImage: UIImage(named: "password")!)
        addEyeButton()
        passwordShow_Hide_Button.setImage((hideImage), for: .normal)
    }
    
    
//    メールでログイン
    @IBAction func sginIn(_ sender: Any) {
        
        let mail = emailTextField.text?.deleteSpace() ?? ""
        let pass = passwordTextField.text?.deleteSpace() ?? ""
        
        Auth.auth().signIn(withEmail: mail, password: pass) { (authResult, error) in
            if (((authResult?.user) != nil) && error == nil) {
                print(Auth.auth().currentUser?.uid as Any)

                let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "tabViewController")
                self.view.window?.rootViewController = tabVC


            } else {
                let errorMessage = error?.localizedDescription
                switch errorMessage {

                case ("The password is invalid or the user does not have a password."):
                    self.passwordErrorLabel.isHidden = false
                    self.alert(title: "パスワードは６文字以上で入力して下さい", message: "", actiontitle: "OK")

                    
                case ("There is no user record corresponding to this identifier. The user may have been deleted."):
                    self.accountErrorLabel.isHidden = false
                    self.alert(title: "メールアドレスが正しくありません", message: "", actiontitle: "OK")

                    
                default:
                    print("エラーーデフォルトーーー\(String(describing: errorMessage))")
                    self.alert(title: "登録がありません", message: "", actiontitle: "OK")
                    return
                }
            }
        }
    }
    
    
    @IBAction func passwordReset(_ sender: Any) {
        
        let mail = emailTextField.text?.deleteSpace() ?? ""

        if mail.isEmpty {
            self.alert(title: "メールをアドレスを入力して下さい", message: "", actiontitle: "OK")
            
        } else {
            
            Auth.auth().sendPasswordReset(withEmail: mail) { error in
                DispatchQueue.main.async {
                    if error != nil {
                        self.alert(title: "このアドレスは登録されてません", message: "", actiontitle: "OK")
                    } else {
                        self.alert(title: "メールを送信しました。", message: "メールでパスワードの再設定を行ってください。", actiontitle: "OK")
                    }
                }
            }
        }
    }
    
    
    @objc
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        passwordErrorLabel.isHidden = true
        accountErrorLabel.isHidden = true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        // 今フォーカスが当たっているテキストボックスからフォーカスを外す
        textField.resignFirstResponder()
        // 次のTag番号を持っているテキストボックスがあれば、フォーカスする
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    private func setIcon(textField: UITextField, andImage image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20 , height: 20))
        let iconMarginView: UIView = UIView(frame:
            CGRect(x: 0, y: 0, width: 30, height: 20))
        iconMarginView.addSubview(iconView)
        iconView.image = image
        textField.leftView = iconMarginView
        textField.leftViewMode = .always
    }
    
    private func addEyeButton() {

        passwordShow_Hide_Button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 5, right: 0)
        passwordShow_Hide_Button.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        passwordShow_Hide_Button.addTarget(self, action: #selector(self.security), for: .touchUpInside)
        passwordTextField.rightView = passwordShow_Hide_Button
        passwordTextField.rightViewMode = .always
    }
    
    @objc func security(_ sender: Any) {
        var show = true

        passwordTextField.isSecureTextEntry.toggle()
        show.toggle()
        let show_hideImage = show ? hideImage: showImage
        passwordShow_Hide_Button.setImage(show_hideImage, for: .normal)
    }


}
