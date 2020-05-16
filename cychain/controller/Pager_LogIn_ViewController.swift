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
    
    
    override func setImageButton() {
        mailLogInButton.setImage(R.image.mail(), for: .normal)
        gmailLogInButton.setImage(R.image.google(), for: .normal)
    }
    
        
    @IBAction func googleLogInButtonTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    //ログインがキャンセル・失敗した場合
     func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        logInErrorAlert()
    }
    
    override func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ログイン") // 親のButtonBarで使われる名前
    }
}
