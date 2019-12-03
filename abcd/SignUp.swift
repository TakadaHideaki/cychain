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
    @IBOutlet weak var eyeImage: UIButton!
    @IBOutlet weak var sinup: customButton!
    
    
    
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
        
        addLeftIcon(textField: email, andImage: UIImage(named: "mail")!)
        addLeftIcon(textField: password, andImage: UIImage(named: "password")!)
        addEyeButton()
    }
    


    //    アカウント作成
    @IBAction func sighUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
            
            if (((authResult?.user) != nil) && error == nil) {
                self.switchVC(view: "first")

            
            } else if Auth.auth().currentUser != nil  {
                self.switchVC(view: "first")
            
            } else {
                self.alert(title: "アカウント登録失敗", message: "アカウントが登録できませんでした", actiontitle: "ok")
                return
            }
        }
    }
    
    
    @IBAction func security(_ sender: Any) {
        password.isSecureTextEntry = !password.isSecureTextEntry
        iconClick = !iconClick
        if iconClick == true {
            eyeImage.setImage(closeeye, for: .normal)
        } else {
            eyeImage.setImage(openEye, for: .normal)
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
    
    
    func addLeftIcon(textField: UITextField, andImage image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20 , height: 20))
        let iconMarginView: UIView = UIView(frame:
            CGRect(x: 0, y: 0, width: 30, height: 20))
        iconMarginView.addSubview(iconView)
        iconView.image = image
        textField.leftView = iconMarginView
        textField.leftViewMode = UITextField.ViewMode.always
    }
    
    func addEyeButton() {
        let eyeview: UIView = UIView(frame:
            CGRect(x: 0, y: 0, width: 30, height: 30))
        eyeview.addSubview(eyeImage)
        password.rightView = eyeview
        password.rightViewMode = UITextField.ViewMode.always
    }
    
}
