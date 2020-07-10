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


class SignUpViewController: UIViewController {
    
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
        bind()
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
//        initTextField() //textfield空なら無効
        initSecurityButton() //平字/伏せ字切替
        initSignUpButton()
    }
    
    //xibで作ったSignUp.LogIn共用画面をSignUp画面用にする
    func initializeUI() {
        authViewInstance.signUpUI()
    }
    
    
    func bind() {
        //email/passwprdtextFieldを監視対象に追加
        bindtext(textField: authViewInstance.emailTextField, text: authView!.email)
        bindtext(textField: authViewInstance.passwordTextField, text: authView!.password)
        
         //mailとpassの文字数によってsignUpButtonの有効/無効切り替え
        authView?.isValid()
            .subscribe(onNext: { [weak self] flag in
                self?.authView?.flag = flag
                self?.authView?.buttonInvalid(button: (self?.authViewInstance.signUpButton!)!)
        })
         .disposed(by: disposeBag)
    }
    
    //textfield(email/passsord)の変更を監視
    func bindtext(textField: UITextField, text: PublishSubject<String>) {
        textField.rx.text.orEmpty
            .bind(to: text)
            .disposed(by: disposeBag)
    }
    
        
    //目のボタンを監視対象に追加
    private func initSecurityButton() {
        SecureTextEntry() // 伏せ字/平字切り替え
        securityButtonTapped(button: authViewInstance.securityButton)
    }
    //SugnUpButtonを監視対象に登録
    private func initSignUpButton() {
//        signUpAcction()
        signUpButtonTapped(button: authViewInstance.signUpButton)
    }
    
    //目のbuttonタップを監視
    func securityButtonTapped(button: UIButton) {
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.SecureTextEntry() // 伏せ字/平字切り替え
            })
            .disposed(by: disposeBag)
    }
    
    //SignUpButtonタップを監視
    func signUpButtonTapped(button: UIButton) {
        button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.signUpAcction()
            })
        .disposed(by: disposeBag)
    }
    
    //目のボタンタップでtextfieldの伏せ字/平字切り替えができる様にする
    func SecureTextEntry() {
        authViewInstance.passwordTextField.isSecureTextEntry.toggle()
        //伏せ字の時はスラッシュ(\)の目にする
        securityFlag.toggle()
        let slashEye = R.image.eye4()
        let eye = R.image.eye5()
        let eyeImage = securityFlag ? slashEye: eye
        authViewInstance.securityButton.setImage(eyeImage, for: .normal)
    }
    
    // サインアップ
    func signUpAcction() {
        guard let email = authViewInstance.emailTextField.text?.deleteSpace(),
            let pass = authViewInstance.passwordTextField.text?.deleteSpace()
            else { return }
        authModel?.signUp(email: email, password: pass)
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
        authModel?.signUp(email: email, password: password)
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





