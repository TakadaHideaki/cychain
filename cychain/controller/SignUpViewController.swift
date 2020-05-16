//
//  sighUp.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/05/01.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var authModel: AuthModel?
    var authView: AuthView?
    let authViewInstance = AuthView.instance()
    var securityFlag = true
    
    private let disposeBag = DisposeBag()
    
 

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeUI()
        authViewInstance.emailTextField.text = ""
        authViewInstance.passwordTextField.text = ""
        switchButtonEnabled() 
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authViewInstance.frame = self.view.frame
        self.view.addSubview(authViewInstance)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set_View_Model()
        initialize()
        initButton()
    }
    
    
    func set_View_Model() {
        authModel = AuthModel()
        authView = AuthView()
        authViewInstance.delegate = self
        authModel?.delegate = self
    }
    
    func initialize() {
//        authViewInstance.emailTextField.delegate = self
//        authViewInstance.passwordTextField.delegate = self
        authViewInstance.passwordTextField.isSecureTextEntry = true
        authViewInstance.textFieldUnderLine()   // textFieldをアンダーラインのみ
        authViewInstance.textFieldLeftIconSet() // メール、パスワードアイコン設置
        authViewInstance.addPasswordEyeButton() // 伏せ字用アイマーク設置
        securityButtonTapped() //平字/伏せ字切替
    }
    
    func initializeUI() {
        authViewInstance.signUpUI()
    }
    
    func switchButtonEnabled() {
        guard let authview = authView  else { return }
        
        if authViewInstance.emailTextField.text!.isEmpty ||
            authViewInstance.passwordTextField.text!.isEmpty {
            
            authview.flag = true
            authview.buttonInvalid(button: authViewInstance.signUpButton)
            
        } else {
            authview.flag = false
            authview.buttonInvalid(button: authViewInstance.signUpButton)
        }
    }
    
    func checkTextField(textField: UITextField) {
        textField.rx.text
            .subscribe(onNext: { _ in
                log.debug(textField.text!.count)
                self.switchButtonEnabled()
            })
            .disposed(by: disposeBag)
    }
    
    private func initButton() {
        switchButtonEnabled()
        checkTextField(textField: authViewInstance.emailTextField)
        checkTextField(textField: authViewInstance.passwordTextField)
    }

    
    func securityButtonTapped() {
        authViewInstance.securityButton.addTarget(self,
                                                  action: #selector(self.security),
                                                  for: .touchUpInside)
    }
    @objc func security(_ sender: Any) {
        authViewInstance.passwordTextField.isSecureTextEntry.toggle()
        securityFlag.toggle()
        let eyeImage = securityFlag ? R.image.eye4(): R.image.eye5()
        authViewInstance.securityButton.setImage(eyeImage, for: .normal)
    }
}

extension SignUpViewController: AuthModelDelegate {
    
    //Home画面へ
    func toHome() {
        presentVC(vc: R.storyboard.main.tabVC()!, animation: true)
    }
    
    //ahthのエラーハンドリング
    func signUperrorDidOccur(error: Error){
        
        _ = error.localizedDescription
        let errorCode = AuthErrorCode(rawValue: error._code)

        
        switch errorCode {
        case .weakPassword://パスワード文字数不足
            weakPasswordAlert()
            
        case .invalidEmail://無効アドレス
            invalidEmailAlert()
            
        case .emailAlreadyInUse://既に使われているアドレス
            emailAlreadyInUseAlert()
            
        default: noRegistationAlert()
        }
    }
    
    func weakPasswordAlert() {
        weakpasswordAlert()
    }
    func invalidEmailAlert() {
        invalidemailAlert()
    }
    func emailAlreadyInUseAlert() {
        emailalreadyInUseAlert()
    }
    func noRegistationAlert() {
        registErrorAlert()
    }
    @objc func logInerrorDidOccur(error: Error) {}
    @objc func passwordErrorAlert() {}
    @objc func passwordResetSuccessAlert() {}
}


extension SignUpViewController: AuthViewDelegate {
    
     @objc func authAction(email: String, password: String) {
        authModel?.signUp(emai: email, password: password)
    }
    func textFieldEnptyAlert() {
        emptyAlert()
    }
    @objc func passwordReset(email: String) {}
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
//}





