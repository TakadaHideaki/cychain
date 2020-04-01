//
//  setting.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/08/30.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import GoogleSignIn
import MessageUI

class SettingsViewController: UIViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate  {
    
    
    @IBOutlet weak var tableView: UITableView!
    let sectionTitle = ["アカウント", "その他"]
    let account = ["ログアウト", "アカウント削除"]
    let other = ["問い合わせ", "利用規約", "プライバシーポリシー"]
    var array: [String:String]!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeTableview()
    }
    
    func initializeUI() {
        customNavigationBar()
    }
    
    func initializeTableview() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
}



extension SettingsViewController: UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return account.count
        case 1: return other.count
        default: break
        }
        return section
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
        case 0: cell.textLabel?.text = account[indexPath.row]
        case 1: cell.textLabel?.text = other[indexPath.row]
        default: break
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
}
    


    
extension SettingsViewController: UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let titles = tableView.cellForRow(at: indexPath)?.textLabel?.text! else { return }
        
        switch titles {
        case ("ログアウト"):
            let firebaseAuth = Auth.auth()
            do {
                log.debug("ログアウト成功")

                try firebaseAuth.signOut()
                sendInitialViewAlert(title: "ログアウトしました", message: "")
  
            } catch let signOutError as NSError {
                log.debug("ログアウト失敗")
                alert(title: "ログアウト失敗", message: "ログアウト出来ませんでした「お問い合わせ」から問い合わせ下さい", actiontitle: "OK")
            }            
            
            
            
            
        case ("アカウント削除"):
            
            func haveData() {
                guard let names = UD.array(forKey: "uniqueNmame") as? [[String : String]] else { return }
                names.forEach {
                    $0.forEach {
                        //  firebase削除
                        let ref = Database.database().reference().child("\($0)/\($1)/\(USER_ID!)")
                        ref.removeValue()
                        
                        //  fireStorage削除
                        let storageRef = STORAGE.child("\($0)/\($1)/\(USER_ID!)/\("imageData")")
                        storageRef.delete { error in
                            if error != nil {
                                log.debug("Strage delete error")
                            } else {
                                log.debug("Strage delete success")
                            }
                        }
                    }
                }
            }
            
            haveData()
            let domain = Bundle.main.bundleIdentifier!
            UD.removePersistentDomain(forName: domain)
            
            Auth.auth().currentUser?.delete { error in
                if error != nil {
                    self.alert(title: "アカウント削除エラー", message: "再ログインして削除してください。それでも削除でいない時は「お問い合わせ」から連絡下さい", actiontitle: "OK")
                } else {
                    self.sendInitialViewAlert(title: "アカウントを削除しました", message: "")
                }
            }
            
            
        case ("問い合わせ"): sendMail()
        case ("利用規約"): switchVC(view: "terms1", animation: true)
        case ("プライバシーポリシー"): switchVC(view: "privacyPolicy", animation: true)
        default: break
        }
    }
    
    
    //    メールviewの処理
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            print("\(error!)")//送信失敗
        } else {
            controller.dismiss(animated: true)
        }
    }

}




