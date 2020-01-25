//
//  bLogIn.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/08/30.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseAuth
import GoogleSignIn
import XLPagerTabStrip

class Pager_LogIn_ViewController: UIViewController, FUIAuthDelegate, GIDSignInDelegate {
  
    
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var gmailButton: Button!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.presentingViewController = self

     
        mailButton.setImage(UIImage(named: "mail2"), for: .normal)
        gmailButton.setImage(UIImage(named: "google"), for: .normal)
        
    }
    

    
    @IBAction func googleSignInActive(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        if let error = error {
            log.debug("-エラー\(error.localizedDescription)")
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

        //firebaseログイン
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil { return }
        }
    }
    
    
    //ログインがキャンセル・失敗した場合
    private func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                        withError error: NSError!) {
        print("ログイン失敗")
        //        失敗した時の処理を書く
    }
}




extension Pager_LogIn_ViewController: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ログイン") // 親のButtonBarで使われる名前
    }
}
