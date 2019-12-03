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


class LogIn: UIViewController, UITextFieldDelegate {
 
 
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet weak var pwErrorLabel: UILabel!
    @IBOutlet weak var acErrorLabel: UILabel!
    @IBOutlet weak var login:Button!
    
    let eyeButton = UIButton(type: .custom)
    let openEye = UIImage(named: "eye5")
    let closeeye = UIImage(named: "eye4")
    var iconClick = true
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.delegate = self
        password.delegate = self
        
        pwErrorLabel.isHidden = true
        acErrorLabel.isHidden = true
        
        password.isSecureTextEntry = true
        
        email.underLine(height: 1.0, color: .white)
        password.underLine(height: 1.0, color: .white)
        
        setIcon(textField: email, andImage: UIImage(named: "mail")!)
        setIcon(textField: password, andImage: UIImage(named: "password")!)
        addEyeButton()
        eyeButton.setImage((closeeye), for: .normal)
    }
    
    
//    メールでログイン
    @IBAction func sginIn(_ sender: Any) {
        
        let mail = email.text?.deleteSpace() ?? ""
        let pass = password.text?.deleteSpace() ?? ""
        
        Auth.auth().signIn(withEmail: mail, password: pass) { (authResult, error) in
            if (((authResult?.user) != nil) && error == nil) {
                print(Auth.auth().currentUser?.uid as Any)

                let tab1 = self.storyboard?.instantiateViewController(withIdentifier: "tab1")
                self.view.window?.rootViewController = tab1


            } else {
                let errorMessage = error?.localizedDescription
                switch errorMessage {

                case ("The password is invalid or the user does not have a password."):
                    self.pwErrorLabel.isHidden = false
                    self.alert(title: "パスワードは６文字以上で入力して下さい", message: "", actiontitle: "OK")

                    
                case ("There is no user record corresponding to this identifier. The user may have been deleted."):
                    self.acErrorLabel.isHidden = false
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
        
        let mail = email.text?.deleteSpace() ?? ""

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
        pwErrorLabel.isHidden = true
        acErrorLabel.isHidden = true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        email.resignFirstResponder()
        password.resignFirstResponder()
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

        eyeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 5, right: 0)
        eyeButton.frame = CGRect(x: CGFloat(password.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        eyeButton.addTarget(self, action: #selector(self.security), for: .touchUpInside)
        password.rightView = eyeButton
        password.rightViewMode = .always
    }
    
    @objc func security(_ sender: Any) {
        password.isSecureTextEntry.toggle()
        iconClick.toggle()
        let eye = iconClick ? closeeye: openEye
        eyeButton.setImage(eye, for: .normal)
    }


}
