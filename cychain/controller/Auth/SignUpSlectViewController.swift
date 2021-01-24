import UIKit
import RxSwift
import RxCocoa
import GoogleSignIn
import XLPagerTabStrip

class SignUpSlectViewController: UIViewController {
    
    let pagerViewInstance = XLPagerTabView.instance()
    let viewModel = SignUpSelectViewModel()
    let disposeBag = DisposeBag()
    private(set) var barTitle = "登録"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubView()
        pagerViewInstance.setButtonImg()
        setButtonTitle()
        bind()
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    //xibで作成したScreenUIをXLPagerTabViewに設置
     func setSubView() {
        pagerViewInstance.frame = self.view.frame
        self.view.addSubview(pagerViewInstance)
    }
    
    func setButtonTitle() {
        pagerViewInstance.buttonTitle(mailtitle: "MailAdressで登録",
                                      googleTitle: "Googleで登録")
        
    }
    
    func bind() {
        let input = SignUpSelectViewModel.Input (
            mailTap:
            self.pagerViewInstance.mailButton.rx.tap.asObservable(),
            googleTap:
            self.pagerViewInstance.googleButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        //to_MailSignUpScreen
        output.mailTapEvent
            .bind(onNext: { self.switchVC()})
            .disposed(by: disposeBag)
        //googleで登録Tap→　GmailSignUp
        output.googleTapEvent.subscribe().disposed(by: disposeBag)
    }
    
    func switchVC() {
        //継承先で遷移先が変わるのでfunctionにしておく
        self.pushVC(vc: R.storyboard.main.sighUp()!, animation: true)
    }
}

extension SignUpSlectViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        // initialVCのタブボタンの名前を登録と表示
        return IndicatorInfo(title: barTitle)
    }
}
