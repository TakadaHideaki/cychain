import UIKit

class AuthView: UIView {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var authErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passwordResetButton: UIButton!
    @IBOutlet weak var logInButton: Button!
    
    var securityButton = UIButton(type: .custom)
    
    class func instance() -> AuthView {
          return UINib(nibName: "AuthView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! AuthView
      }
    
    //textFieldをアンダーラインのみにする
    func textFieldUnderLine() {
        emailTextField.underLine(height: 1.0, color: .white)
        passwordTextField.underLine(height: 1.0, color: .white)
    }
    //textFielf左に設置するiconを登録
    func textFieldLeftIconSet() {
        textFieldIconSet(textField: emailTextField, image: R.image.mail()!)
        textFieldIconSet(textField: passwordTextField, image: R.image.password()!)
     }
    //textField左に設置するiconを設定
    func textFieldIconSet(textField: UITextField, image: UIImage) {
       
       //Icon_MarginSiza
        let iconMarginView: UIView = {
            let iconMarginView = UIView()
            iconMarginView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
            return iconMarginView
        }()
        //Icon_Size
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
//    var flag = false //textfieldが空の状態がflag == true
    func buttonInvalid(bool: Bool, button: UIButton) {
        button.backgroundColor = bool ? .white: .clear
        button.layer.borderWidth = bool ? 0: 2
        button.layer.borderColor = bool ? UIColor.white.cgColor: UIColor.lightGray.cgColor
        if bool == true {
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
        buttonInvalid(bool: false, button: signUpButton)
    }
    //xibで作ったSignUp.LogIn共用画面を【LogIn】用画面にする
    func logInUI() {
        authErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        passwordResetButton.isHidden = true
        signUpButton.isHidden = true
        logInButton.isHidden = false
        logInButton.setTitle("Log In", for: .normal)
        buttonInvalid(bool: false, button: logInButton)
    }
    
    func errorLabelHidden() {
        authErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }

}
