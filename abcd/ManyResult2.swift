//
//  result3.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/04/15.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FirebaseUI
import MessageUI

class ManyResult2: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var value: [String:Any]!
    var names: [String]!
    var account: (String)!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        admob()
        tableView.reloadData()
        print(account)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultPostCardCell2", for: indexPath) as? resultPostCardCell2
            
            cell?.myName.text = names[0]
            cell?.targetName.text = names[1]
            
            cell?.myName.adjustsFontSizeToFitWidth = true
            cell?.targetName.adjustsFontSizeToFitWidth = true
            cell?.myName.minimumScaleFactor = 0.5
            cell?.targetName.minimumScaleFactor = 0.5
            
            
            guard let profileImage: String = value["image"] as? String else { return cell! }
            
            if profileImage != "" {
                let url = URL(string: profileImage)
                //            image変換
                DispatchQueue.global().async {
                    do {
                        let imageData = try Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            let image = UIImage(data:imageData as Data)
                            cell?.profaleIcon.image = image
                        }
                    } catch {
                        cell?.profaleIcon.image = UIImage(named: "user12")
                    }
                }
            } else {
                cell?.profaleIcon.image = UIImage(named: "user12")
            }
            return cell!
            
            
        } else {
            
            let messagecell = tableView.dequeueReusableCell(withIdentifier: "messagecell", for: indexPath) as! postCardMessage

            messagecell.messageLabel.text = value["message"] as? String
            return messagecell
        }
    }
        
    
    
    func  tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        switch section {
        case 0: label.text = "posting card"
        case 1: label.text = "message"
        default: break
        }
        return label
    }
    
    @IBAction func report(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle:  UIAlertController.Style.actionSheet)
        
        let report: UIAlertAction = UIAlertAction(title: "投稿者を通報", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            //メール送信が可能なら
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["cychaincontact@gmail.com"]) //送り先adless
                mail.setSubject("通報") //件名
                //メッセージ本文
                if let messegaText = self.value["message"] as? String {
                    mail.setMessageBody("通報理由(任意)\n\n\n投稿者名:\(self.names[0])\n投稿相手名:\(self.names[1])\nmessage:\(messegaText)", isHTML: false)
                } else {
                    mail.setMessageBody("通報理由(任意)\n\n\n投稿者名:\(self.names[0])\n投稿相手名:\(self.names[1])", isHTML: false)
                }
                //メールを表示
                self.present(mail, animated: true, completion: nil)
            
            } else {
                //メール送信が不可能
                self.alert(title: "No Mail Accounts", message: "Please set up mail accounts", actiontitle: "OK")
            }
            
            //エラー処理
            func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                if error != nil {
                    //送信失敗
                    print(error!)
                } else {
                    switch result {
                    case .cancelled:
                        break
                    case .saved:
                        break
                    case .sent:
                        //送信
                        break
                    default:
                        break
                    }
                    controller.dismiss(animated: true, completion: nil)
                }
            }
        })
        
        
        let block: UIAlertAction = UIAlertAction(title: "投稿者をブロック", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
       
            if var blocks = UD.array(forKey: "block") {
                blocks += [self.account]
                UD.set(blocks, forKey: "block")
                
            }  else {
                var blockArray = [String]()
                blockArray += [self.account]
                UD.set(blockArray, forKey: "block")
            }
            
            let alert = UIAlertController(title: "ブロック", message: "この投稿をしたユーザーをブロックしました", preferredStyle: .alert)
            self.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    alert.dismiss(animated: true, completion: nil)
                })
            })
        })
        // Cancelボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(report)
        alert.addAction(block)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    


}
