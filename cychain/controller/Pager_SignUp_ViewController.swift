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
import Rswift

class Pager_SignUp_ViewController: UIViewController, GIDSignInDelegate, IndicatorInfoProvider {
    
    
    @IBOutlet weak var mailSignUpButton: Button!
    @IBOutlet weak var gmaiSignUplButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageButton()
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    func setImageButton() {
        mailSignUpButton.setImage(R.image.mail(), for: .normal)
        gmaiSignUplButton.setImage(R.image.google(), for: .normal)
    }
    
    
    @IBAction func googleSignUpButtonTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
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
        return IndicatorInfo(title: "登録")
    }
}
