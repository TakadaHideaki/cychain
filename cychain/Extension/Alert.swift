//
//  Alert.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/05/03.
//  Copyright © 2020 高田英明. All rights reserved.
//

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
    
    
    
    
    func sendMailErrorAlert() {
        alert(title: "アカウントがありません", message: "メールアカウントを設定してください", actiontitle: "OK")
    }
    
    func logOutError() {
        alert(title: "ログアウト失敗", message: "ログアウト出来ませんでした「お問い合わせ」から問い合わせ下さい", actiontitle: "OK")
    }
    
    func signOutErrorAlert() {
        alert(title: "アカウント削除エラー", message: "再ログイン後削除してください。それでも出来ない場合は「お問い合わせ」から連絡下さい", actiontitle: "OK")
    }
    


}
