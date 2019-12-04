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

class TabLogIn: UIViewController, FUIAuthDelegate, GIDSignInDelegate /* ,GIDSignInUIDelegate*/ {
  
    
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var gmailButton: Button!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
     
        mailButton.setImage(UIImage(named: "mail2"), for: .normal)
        gmailButton.setImage(UIImage(named: "google"), for: .normal)
        
    }
    

    
    @IBAction func google(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        if let error = error {
            print("-------エラー\(error.localizedDescription)---------")
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

//                    firebaseログイン
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                print("エラー------")
                return
            }
            print( "ユーザーはログインしています。　　User is signed in")
            let tab1 = self.storyboard?.instantiateViewController(withIdentifier: "tab1")
            self.view.window?.rootViewController = tab1  
        }
    }
    
    
    //ログインがキャンセル・失敗した場合
    private func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                        withError error: NSError!) {
        print("-----------ログイン失敗-------------")
        //        失敗した時の処理を書く
    }
}




extension TabLogIn: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ログイン") // 親のButtonBarで使われる名前
    }
}
