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

extension UITextField {
    

    
    func underLine(height: CGFloat, color: UIColor) {
        
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }}



class login: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTextFiled: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var eyeImage: UIButton!
    var openEye = UIImage(named: "openeye")
    var closeeye = UIImage(named: "eye")
    var flag = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextFiled.delegate = self
        passwordTextField.delegate = self
        
        emailTextFiled.underLine(height: 1.0, color: UIColor.lightGray)
        passwordTextField.underLine(height: 1.0, color: UIColor.lightGray)

    }
    

    @IBAction func login(_ sender: Any) {
        
//        6文字
        
        Auth.auth().createUser(withEmail: emailTextFiled.text!, password: passwordTextField.text!) { (authResult, error) in
            if let error = error {
                print("エラー")
                return
            }
            if let user = authResult?.user{
                print(Auth.auth().currentUser?.uid)
            }}}
        
        
        
        
    @IBAction func sginIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextFiled.text!, password: passwordTextField.text!) { (authResult, error) in
            if let error = error {
                print("エラー")
                return
            }
            if let user = authResult?.user{

                print(Auth.auth().currentUser?.uid)
            }
        }
    }
    
        
        
        
    @IBAction func security(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry 

        if flag {
            eyeImage.setImage(openEye, for: .normal)
            flag = false
        } else {
            eyeImage.setImage(closeeye, for:.normal)
            flag = true
        }}
    
    
        
    
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
