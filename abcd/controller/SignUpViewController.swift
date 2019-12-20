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
        
        emailTextField.underLine(height: 1.0, color: .white)
        passwordTextField.underLine(height: 1.0, color: .white)
        
        passwordTextField.isSecureTextEntry = true
        
        passwordShow_Hide_Button.setImage((hideImage), for: .normal)
        addLeftIcon(textField: emailTextField, andImage: UIImage(named: "mail")!)
        addLeftIcon(textField: passwordTextField, andImage: UIImage(named: "password")!)
        addPasswordEyeButton()
    }
    


    //    アカウント作成
    @IBAction func sighUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            
            if (((authResult?.user) != nil) && error == nil) || Auth.auth().currentUser != nil {
                let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "tabVC")
                self.view.window?.rootViewController = tabVC
            
//            } else if Auth.auth().currentUser != nil  {
//                let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "tabVC")
//                self.view.window?.rootViewController = tabVC
            
            } else {
                self.alert(title: "アカウントが登録できませんでした", message: "", actiontitle: "OK")
                return
            }
        }
    }
    
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    
    private func addLeftIcon(textField: UITextField, andImage image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20 , height: 20))
        let iconMarginView: UIView = UIView(frame:
            CGRect(x: 0, y: 0, width: 30, height: 20))
        iconMarginView.addSubview(iconView)
        iconView.image = image
        textField.leftView = iconMarginView
        textField.leftViewMode = UITextField.ViewMode.always
    }
    
    private func addPasswordEyeButton() {

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