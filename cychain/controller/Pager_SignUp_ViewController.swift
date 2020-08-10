import UIKit
import RxSwift
import RxCocoa
import Rswift
import Firebase
import FirebaseAuth
import GoogleSignIn
import XLPagerTabStrip

class Pager_SignUp_ViewController: UIViewController, GIDSignInDelegate, IndicatorInfoProvider {
    
    
    @IBOutlet weak var mailSignUpButton: Button!
    @IBOutlet weak var gmaiSignUplButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private(set) var barTitle = "登録"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageButton()
        GIDSignIn.sharedInstance()?.presentingViewController = self //Gmailでログインする画面を表示
        buttonSet()
    }
    
    //ボタンにアイコンをセット
    func setImageButton() {
        mailSignUpButton.setImage(R.image.mail(), for: .normal) //ログインボタンにメールアイコンをセット
        gmaiSignUplButton.setImage(R.image.google(), for: .normal)//GoogleログインにGoogleアイコンをセット
    }
    
    //『googleで登録』をTapした時のアクション（Gmailでログイン）
    func gmailButtontapAction(button: UIButton) {
        button.rx.tap
            .subscribe(onNext: {
                log.debug("gmailButtontapAction")
                //googleでアカウント登録画面に遷移
                GIDSignIn.sharedInstance().signIn()
            })
        .disposed(by: disposeBag)
    }
    //googleで登録Buttonを監視対象に追加
    func buttonSet() {
        gmailButtontapAction(button: gmaiSignUplButton)
    }
        

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil { return }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // Firebaseにログインする。
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil { return }
        }
    }
    
    //ログインがキャンセル・失敗した場合
    private func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                        withError error: NSError!) {
        //失敗時
        signUpErrorAlert()
        return
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        // initialVCのタブボタンの名前を登録と表示
        return IndicatorInfo(title: barTitle)
    }
}
