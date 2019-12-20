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

class settings: UITableViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    let sectiontitle = ["アカウント", "その他"]
    let account = ["ログアウト", "アカウント削除"]
    let other = ["問い合わせ", "利用規約", "プライバシーポリシー"]
    
    var ref:DatabaseReference!
    let storage = Storage.storage()
    var name2 = [[String:String]]()
    var array: [String:String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self


        //        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectiontitle.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return account.count

        } else if section == 1 {
            return other.count

        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        if indexPath.section == 0{
            cell.textLabel?.text = account[indexPath.row]
            
        } else if  indexPath.section == 1 {
            cell.textLabel?.text = other[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectiontitle[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let titles = tableView.cellForRow(at: indexPath)?.textLabel?.text! else { return }
        
        switch titles {
        case ("ログアウト"):
            print("ログアウト")
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("------ログアウト成功")
                let alert = UIAlertController(title: "ログアウト", message: "ログアウトしました", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler:{(action:UIAlertAction!) -> Void in
                    let login = self.storyboard?.instantiateViewController(withIdentifier: "login") as! login
                    self.navigationController?.pushViewController(login, animated: true)
                    
                })
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
                let alert = UIAlertController(title: "ログアウト失敗", message: "ログアウト出来ませんでした「お問い合わせ」から問い合わせ下さい", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            
            
            
        case ("アカウント削除"):
            print("アカウント削除")
            
            if UserDefaults.standard.object(forKey: "uniqueNmame") != nil {
                print("ーーーーーーーーーーーーー有り")
                
                if let name3 = UserDefaults.standard.array(forKey: "uniqueNmame"){
                    self.name2 = (name3  as? [[String : String]])!
                }
                
                for key in self.name2 {
                    for (myNames, targetNames) in key {
                        let myName = String(myNames)
                        let targetNmame = String(targetNames)
                        
                        //  firebase削除
                        let userID = Auth.auth().currentUser?.uid
                        let ref = Database.database().reference().child(myName).child(targetNmame).child(userID!)
                        ref.removeValue()
                        
                        //  fireStorage削除
                        let storageRef = self.storage.reference(forURL: "gs://cychain-6d3b6.appspot.com").child(myName).child(targetNmame).child(userID!).child("imageData")
                        
                        storageRef.delete { error in
                            if error != nil {
                                print("ストレージ削除エラー")
                            } else {
                                print("ストレージ削除おk")
                            }
                        }
                    }
                }
                
                
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                
                Auth.auth().currentUser?.delete { error in
                    if error != nil {
                        print("削除エラー")
                        let alert1 = UIAlertController(title: "アカウント削除失敗", message: "1度ログアウトし再度ログインしてから削除してください。それでも削除でいない時は「お問い合わせ」から問い合わせ下さい", preferredStyle: UIAlertController.Style.alert)
                        let okButton1 = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: nil)
                        alert1.addAction(okButton1)
                        self.present(alert1, animated: true, completion: nil)
                        
                    } else {
                        print("削除OK")
                        UserDefaults.standard.set(true, forKey: "firstLaunch")
                        let alert = UIAlertController(title: "アカウント削除", message: "アプリ内のデータは全て削除されました", preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler:{(action:UIAlertAction!) -> Void in
                            let sighUp = self.storyboard?.instantiateViewController(withIdentifier: "sighUp") as! sighUp
                            self.navigationController?.pushViewController(sighUp, animated: true)
                            
                        })
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
            
            
        case ("問い合わせ"):
            print("問い合わせ")
            //メール送信が可能なら
            if MFMailComposeViewController.canSendMail() {
                //MFMailComposeVCのインスタンス
                let mail = MFMailComposeViewController()
                //MFMailComposeのデリゲート
                mail.mailComposeDelegate = self
                //送り先
                mail.setToRecipients(["cychaincontact@gmail.com"])
                // 件名
                mail.setSubject("お問い合わせ")
                //メッセージ本文
                mail.setMessageBody("お問い合わせな内容", isHTML: false)
                //メールを表示
                self.present(mail, animated: true, completion: nil)
                //メール送信が不可能なら
            } else {
                //アラートで通知
                let alert = UIAlertController(title: "No Mail Accounts", message: "Please set up mail accounts", preferredStyle: .alert)
                let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(dismiss)
                self.present(alert, animated: true, completion: nil)
            }
            
            
            
        case ("利用規約"):
            print("利用規約")
            let terms1 = self.storyboard?.instantiateViewController(withIdentifier: "terms1")
            self.navigationController?.pushViewController(terms1!, animated: true)
            
            
            
        case ("プライバシーポリシー"):
            print("プライバシーポリシー ")
            let privacyPolicy = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicy")
            self.navigationController?.pushViewController(privacyPolicy!, animated: true)
            
            
        default:
            print("ng")
        }
        
    }
}

        



