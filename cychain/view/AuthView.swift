import UIKit
import RxSwift
import RxCocoa

protocol AuthViewDelegate: class {
    func authAction(email: String, password: String)
    func passwordReset(email: String)
    func textFieldEnptyAlert()
}


class AuthView: UIView {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var authErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passwordResetButton: UIButton!
    @IBOutlet weak var logInButton: Button!
    
    weak var delegate: AuthViewDelegate?

    var securityButton = UIButton(type: .custom)
    
    
    let email = PublishSubject<String>()
    let password = PublishSubject<String>()
    
    func isValid() -> Observable<Bool> {
        return Observable
            .combineLatest(email.asObservable().startWith(""),
                           password.asObservable().startWith(""))
            .map { email, password in
                return email.count > 5 && password.count > 5
        }
        .startWith(false)
    }
    


    
    class func instance() -> AuthView {
          return UINib(nibName: "AuthView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! AuthView
      }
    
    //textFieldをアンダーラインのみにする
    func textFieldUnderLine() {
        emailTextField.underLine(height: 1.0, color: .white)
        passwordTextField.underLine(height: 1.0, color: .white)
    }
    
    func textFieldLeftIconSet() {
        textFieldIconSet(textField: emailTextField, image: R.image.mail()!)
        textFieldIconSet(textField: passwordTextField, image: R.image.password()!)
     }
    //textField左にメールマークと鍵マークを設置
    func textFieldIconSet(textField: UITextField, image: UIImage) {
       
        let iconMarginView: UIView = {
            let iconMarginView = UIView()
            iconMarginView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
            return iconMarginView
        }()
        
        let iconView: UIImageView = {
            let iconView = UIImageView()
            iconView.frame = CGRect(x: 0.0, y: 0.0, width: 20 , height: 20)
            iconView.image = image
            return iconView
        }()
        iconMarginView.addSubview(iconView)
        textField.leftView = iconMarginView
        textField.leftViewMode = .always
    }
    
    //paswprdTextFieldの左に伏せ字用の目のマーク設置
    func addPasswordEyeButton() {
        let button: UIButton = {
            let button = UIButton()
            button.setImage(R.image.eye4(), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 10, right: 0)
            let textFieldWidth = passwordTextField.frame.size.width
            securityButton.frame = CGRect(x: textFieldWidth - 25, y: 5, width: 10, height: 15)
            return button
        }()
        securityButton = button
        passwordTextField.rightView = securityButton
        passwordTextField.rightViewMode = .always
    }
    
    //SignUpボタンを有効/無効切り替え
    var flag = false //textfieldが空の状態がflag == true
    func buttonInvalid(button: UIButton) {
        button.isEnabled = flag ? false: true
        button.backgroundColor = flag ? .white: .clear
        button.layer.borderWidth = flag ? 0: 2
        button.layer.borderColor = flag ? UIColor.white.cgColor: UIColor.lightGray.cgColor
        if flag == true {
            button.setTitleColor(.black, for: .normal)
        } else {
            button.setTitleColor(.lightGray, for: .normal)
        }
    }


    
    //xibで作ったSignUp.LogIn共用画面を【SignUp】用画面にする
    final func signUpUI() {
        authErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        passwordResetButton.isHidden = true
        logInButton.isHidden = false
        signUpButton.setTitle("Sign Up", for: .normal)
        buttonInvalid(button: signUpButton)
    }
    //xibで作ったSignUp.LogIn共用画面を【LogIn】用画面にする
    func logInUI() {
        authErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        passwordResetButton.isHidden = true
        signUpButton.isHidden = true
        logInButton.isHidden = false
        logInButton.setTitle("Log In", for: .normal)
        buttonInvalid(button: logInButton)
    }
    
    func errorLabelHidden() {
        authErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }
    
    
    @IBAction func SignInButtonTapped(_ sender: Any) {
//        buttonTappedAction()
        log.debug("view")

    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        buttonTappedAction()
    }
    
    func buttonTappedAction() {
//        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
//            delegate?.textFieldEnptyAlert()
//
//        } else {
//            guard let email = emailTextField.text?.deleteSpace(),
//                let pass = passwordTextField.text?.deleteSpace()
//                else { return }
//            delegate?.authAction(email: email, password: pass)
//        }
    }
    
    
    @IBAction func passwordResetButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text?.deleteSpace() else { return }
        self.delegate?.passwordReset(email: email)
    }
}










