//
//  bLogIn.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/08/30.
//  Copyright © 2019 高田英明. All rights reserved.
//

import Firebase
//import FirebaseUI
//import FirebaseAuth
import GoogleSignIn
import XLPagerTabStrip

//class Pager_LogIn_ViewController: Pager_SignUp_ViewController, FUIAuthDelegate {
class Pager_LogIn_ViewController: Pager_SignUp_ViewController {

    
    @IBOutlet weak var mailLogInButton: Button!
    @IBOutlet weak var gmailLogInButton: Button!
    
    override var barTitle: String { return "ログイン" }
    
    //ボタンにアイコンをセット
    override func setImageButton() {
        mailLogInButton.setImage(R.image.mail(), for: .normal) //　メールログインボタンにメールアイコン設置
        gmailLogInButton.setImage(R.image.google(), for: .normal) //　GメールログインボタンにGoogleアイコンを設置
    }
    
    //『googleでログイン』をTapした時のアクション
    override func buttonSet() {
        gmailButtontapAction(button: gmailLogInButton) //googleログイン画面に遷移
    }
    
    //ログインが失敗した場合
     func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        logInErrorAlert() //ログイン失敗アラート表示
    }
    
}
