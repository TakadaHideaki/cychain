//
//  bSighUp.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/08/30.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import XLPagerTabStrip

class Pager_SignUp_ViewController: UIViewController, GIDSignInDelegate {
  

    @IBOutlet weak var mailButton: Button!
    @IBOutlet weak var gmailButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance()?.delegate = self

        
        mailButton.setImage(UIImage(named: "mail2"), for: .normal)
        gmailButton.setImage(UIImage(named: "google"), for: .normal)
    }
    
    
    @IBAction func googleLogInActive(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil {
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // Firebaseにログインする。
        Auth.auth().signIn(with: credential) { (user, error) in
            
            print("ーーーーーーgoogoleアカウント登録ーーーーーーー")
//            let tab1 = self.storyboard?.instantiateViewController(withIdentifier: "tabVC")
//            self.view.window?.rootViewController = tab1
     
        }
    }
    

    //ログインがキャンセル・失敗した場合
    private func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                        withError error: NSError!) {
        //        失敗した時の処理を書く
        alert(title: "アカウントが登録できませんでした", message: "", actiontitle: "OK")
        return
    }

}

extension Pager_SignUp_ViewController: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "登録")
    }
}
