import UIKit
import RxSwift
import FirebaseAuth

class MaillLoginViewController: MaillSignUpViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = MaillLogInViewModel()

    //xibで作ったSignUp.LogIn共用画面をLogIn画面用にする
    override func setScreen() {
        authViewInstance.logInUI()
    }
    
    override func bind() {
        
        let input = MaillLogInViewModel.Input (
            email:
            authViewInstance.emailTextField.rx.text.orEmpty.map{( $0.deleteSpace())},
            password:
            authViewInstance.passwordTextField.rx.text.orEmpty.map{( $0.deleteSpace())},
            logInTap:
            authViewInstance.logInButton.rx.tap.asObservable(),
            securityButtonTapped:
            authViewInstance.securityButton.rx.tap.asObservable(),
            pasdswordResetTap:
            authViewInstance.passwordResetButton.rx.tap.asObservable()  
        )
        
        let output = viewModel.transform(input: input)
        
        // LoginButto_Enabled
        output.isValid
            .drive(authViewInstance.logInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        //Change_SignUpButtonAppearance
        output.isValid.asObservable()
            .bind(onNext: {
                self.authView.buttonInvalid(bool: $0, button: self.authViewInstance.logInButton!)
            })
            .disposed(by: disposeBag)
        
        //LoginResult (success_toHomeVC / error_ErrorAlert)
        output.logInResult
            .subscribe(onNext: { [weak self] _ in
                self?.presentVC(vc: R.storyboard.main.tabVC()!, animation: true)
                
                }, onError: { error in
                    self.logInerrorDidOccur(error: error)
            }
        )
            .disposed(by: disposeBag)
        
        //Switch＿PassWordText(伏字/平字)
        output.boolToggle
            .bind(onNext: { self.secureTextEntry(bool: $0) })
            .disposed(by: disposeBag)
        
        //メールアドレス文字数不足
        output.insufficientMaill
            .bind(onNext: { self.passwordemptyAlert() })
            .disposed(by: disposeBag)
        
        //Resurt＿Reset_MailAddress
        output.resetMailAdress
            .subscribe(onNext: { [weak self] _ in
                self?.passwordresetSuccessAlert()
                
                }, onError: { [weak self] _ in
                    self?.passworderrorAlert()
                })
            .disposed(by: disposeBag)
        
        output.watingUI
            .drive(self.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.watingUI
            .scan(true) { state, _ in !state}
            .startWith(true)
            .drive(self.coverView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
     func logInerrorDidOccur(error: Error) {
        _ = AuthErrorCode(rawValue: error._code)
        let mailText = authViewInstance.emailTextField.text!.deleteSpace()
        let errorMessage = error.localizedDescription
        
        switch errorMessage {
//        無効アドレス
        case ("There is no user record corresponding to this identifier. The user may have been deleted."):
            
            if mailText.contains("@gmail.com") {
                registGoogleadressAlert()
            } else {
                invalidemailAlert()
                authViewInstance.authErrorLabel.isHidden = false
            }
        default: registErrorAlert()
        }
        
    }

}
