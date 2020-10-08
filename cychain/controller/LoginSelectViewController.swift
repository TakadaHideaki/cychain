import Firebase
import GoogleSignIn
import XLPagerTabStrip

class LoginSelectViewController: SignUpSlectViewController {
    
    override var barTitle: String { return "ログイン" }

    override func setButtonTitle() {
        pagerViewInstance.buttonTitle(mailtitle: "MailAdressでログイン",
                                      googleTitle: "Googleでログイン")
    }
    
    override func switchVC() {
        self.pushVC(vc: R.storyboard.main.login()!, animation: true)
    }
}
