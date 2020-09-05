import UIKit

extension UIViewController {
    
    //アラートを出すだけ
    func alert(title:String,message:String,actiontitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actiontitle, style: .default))
        self.present(alert, animated: true)
    }
    
    
    //アラートを出してviewを切り替える
    func sendInitialViewAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let sendButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{(action:UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(sendButton)
        self.present(alert, animated: true)
        
    }
    
    
    func cansel_Send_Alert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    
    
    
    func signOutAlert() {
        sendInitialViewAlert(title: "アカウントを削除しました", message: "")
    }
    
    func logOutAlert() {
        sendInitialViewAlert(title: "ログアウトしました", message: "")
    }
    
    func passwordresetSuccessAlert() {
        alert(title: "メールを送信しました。", message: "メールでパスワードの再設定を行ってください。", actiontitle: "OK")
    }
    
    
    
    
    func weakpasswordAlert() {
        alert(title: "パスワードは６文字以上で入力して下さい", message: "", actiontitle: "OK")
    }
    
    func invalidemailAlert() {
        alert(title: "メールアドレスが正しくありません", message: "", actiontitle: "OK")
    }
    func emailalreadyInUseAlert() {
        alert(title: "このメールアドレスはすでに使われています", message: "", actiontitle: "OK")
    }
    
    func passworderrorAlert() {
        alert(title: "このアドレスは登録されてません", message: "", actiontitle: "OK")
    }
    
    func emptyAlert() {
        alert(title: "未入力の項目があります", message: "", actiontitle: "OK")
    }
    
    func passwordemptyAlert() {
        self.alert(title: "メールをアドレスを入力して下さい", message: "", actiontitle: "OK")
    }
    
    func registGoogleadressAlert() {
        alert(title: "Googleアドレスでの登録", message: "Googleログインからログインして下さい", actiontitle: "OK")
    }
    
    func noNameAlert() {
        alert(title: "名前を入力して下さい", message: "", actiontitle: "OK")
    }
    
    func overCharacterAlert() {
        alert(title: "名前は１３文字までです", message: "", actiontitle: "OK")
    }
    
    func charactorErrorAlert() {
         alert(title: "文字数Error", message: "", actiontitle: "OK")
     }
    
    
    
    
    
    func logInErrorAlert() {
        alert(title: "ログインができませんでした", message: "", actiontitle: "OK")
    }
    
    func signUpErrorAlert() {
        alert(title: "アカウントが登録できませんでした", message: "", actiontitle: "OK")
    }
    
    
    func sendMailErrorAlert() {
        alert(title: "メール送信エラー", message: "メールアドレスがありません", actiontitle: "OK")
    }
    
    func logOutErrorAlert() {
        alert(title: "ログアウト失敗", message: "ログアウト出来ませんでした「お問い合わせ」から問い合わせ下さい", actiontitle: "OK")
    }
    
    func signOutErrorAlert() {
        alert(title: "アカウント削除エラー", message: "再ログイン後削除してください。それでも出来ない場合は「お問い合わせ」から連絡下さい", actiontitle: "OK")
    }
    
    func registErrorAlert() {
        self.alert(title: "エラー", message: " エラーが起きました\nしばらくしてから再度お試し下さい", actiontitle: "OK")
    }
    
    
    func RegistationOverAlert(vc: UIViewController){
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        let sendList = UIAlertAction(title: "登録リストへ",style: .default, handler:{(action: UIAlertAction!) -> Void in
            self.pushVC(vc: vc, animation: true)
        })
        cansel_Send_Alert(title: "登録数オーバー", message: "リストから登録数を減らして下さい", actions: [cancel, sendList])
    }
    
    
    
}
