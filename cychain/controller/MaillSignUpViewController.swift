import UIKit
import RxSwift
import FirebaseAuth

class MaillSignUpViewController: UIViewController {
    
    let authView = AuthView()
    let authViewInstance = AuthView.instance()
    private let disposeBag = DisposeBag()
    final private let viewModel = MaillSignUpViewModel()
    
    lazy var coverView: UIView = {
          let view = UIView()
          view.frame = self.view.bounds
          view.backgroundColor = .lightGray
          view.alpha = 0.2
          return view
      }()

    lazy var indicatorView = { () -> UIActivityIndicatorView in
        var view = UIActivityIndicatorView.init(style: .whiteLarge)
        view.color = .white
        view.center = self.view.center
        return view
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authViewInstance.emailTextField.text = ""
        authViewInstance.passwordTextField.text = ""
        self.navigationController?.isNavigationBarHidden = false

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScreen()
        initializeUI()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        authViewInstance.frame = self.view.frame
        self.view.addSubview(authViewInstance)
//        self.view.addSubview(coverView)
//        self.view.bringSubviewToFront(coverView)
//        self.view.addSubview(indicatorView)
//        self.view.bringSubviewToFront(indicatorView)
    }
    
    func initializeUI() {
        authViewInstance.passwordTextField.isSecureTextEntry = true
        //textFieldをアンダーラインのみ
        authViewInstance.textFieldUnderLine()
        //メール、パスワードアイコン設置
        authViewInstance.textFieldLeftIconSet()
        // 伏せ字用アイマーク設置
        authViewInstance.addPasswordEyeButton()
        //textFieldを２つ設置した時に発生するLayoutConstraintエラー（バグ？）に対応
        authViewInstance.emailTextField.autocorrectionType = .no
        authViewInstance.passwordTextField.autocorrectionType = .no
    }
    
    //xibで作ったSignUp.LogIn共用画面をSignUp画面用にする
    func setScreen() {
        authViewInstance.signUpUI()
    }
    
    func bind() {
        
        let input = MaillSignUpViewModel.Input (
            email:
            authViewInstance.emailTextField.rx.text.orEmpty.map{( $0.deleteSpace())},
            password:
            authViewInstance.passwordTextField.rx.text.orEmpty.map{( $0.deleteSpace())},
            signUpTap:
            authViewInstance.signUpButton.rx.tap.asObservable(),
            securityButtonTapped:
            authViewInstance.securityButton.rx.tap.asObservable()
            
        )
        
        let output = viewModel.transform(input: input)
        
        // signUpButton_Enabled
        output.isValid
            .drive(authViewInstance.signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        //Change_SignUpButtonImage
        output.isValid.asObservable()
            .bind(onNext: { bool in
                self.authView.buttonInvalid(bool: bool, button: self.authViewInstance.signUpButton!)
            })
            .disposed(by: disposeBag)
        
        //SignUpResult (success_toHomeVC / error_ErrorAlert)
        output.signUpResult
            .subscribe(onNext: { [weak self] _ in
                self?.presentVC(vc: R.storyboard.main.tabVC()!, animation: true)
                
                }, onError: { error in
                    self.signUperrorDidOccur(error: error)
            }
        )
            .disposed(by: disposeBag)
        
        //Switch＿PassWordText(伏字/平字)
        output.boolToggle
            .bind(onNext: { self.secureTextEntry(bool: $0) })
            .disposed(by: disposeBag)
        
        output.watingUI
            .drive(self.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.watingUI.debug()
            .scan(true) { state, _ in !state}
            .startWith(true)
            .drive(self.coverView.rx.isHidden)
            .disposed(by: disposeBag)
     }
    
    //目のボタンタップでtextfieldの伏せ字/平字切り替えができる様にする
    func secureTextEntry(bool: Bool) {
        let slashEye = R.image.eye4()
        let eye = R.image.eye5()
        let eyeImage = bool ? slashEye: eye
        authViewInstance.passwordTextField.isSecureTextEntry.toggle()
        authViewInstance.securityButton.setImage(eyeImage, for: .normal)
    }
    
    //ahthのエラーハンドリング
    func signUperrorDidOccur(error: Error) {
        
        _ = error.localizedDescription
        let errorCode = AuthErrorCode(rawValue: error._code)
        
        switch errorCode {
        //パスワード文字数不足
        case .weakPassword:  weakpasswordAlert()
        //無効アドレス
        case .invalidEmail: invalidemailAlert()
        //既に使われているアドレス
        case .emailAlreadyInUse: emailalreadyInUseAlert()
        default: registErrorAlert()
        }
    }
    
//    func weakPasswordAlert() {
//        weakpasswordAlert()
//    }
//    func invalidEmailAlert() {
//        invalidemailAlert()
//    }
//    func emailAlreadyInUseAlert() {
//        emailalreadyInUseAlert()
//    }
//    func noRegistationAlert() {
//        registErrorAlert()
//    }
    
}
