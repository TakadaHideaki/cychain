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

class SignUp: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var sinup: Button!
    
    
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
        
        email.underLine(height: 1.0, color: .white)
        password.underLine(height: 1.0, color: .white)
        
        password.isSecureTextEntry = true
        
        eyeButton.setImage((closeeye), for: .normal)
        addLeftIcon(textField: email, andImage: UIImage(named: "mail")!)
        addLeftIcon(textField: password, andImage: UIImage(named: "password")!)
        addEyeButton()
    }
    


    //    アカウント作成
    @IBAction func sighUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
            
            if (((authResult?.user) != nil) && error == nil) {
                let tab1 = self.storyboard?.instantiateViewController(withIdentifier: "tab1")
                self.view.window?.rootViewController = tab1
            
            } else if Auth.auth().currentUser != nil  {
                let tab1 = self.storyboard?.instantiateViewController(withIdentifier: "tab1")
                self.view.window?.rootViewController = tab1
            
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
