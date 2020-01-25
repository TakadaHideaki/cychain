//
//  result.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/04/14.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import MessageUI
import GoogleMobileAds


class SeachResultViewCotroller: UIViewController, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var names: [String]?//[nyname, searchname]
    var mutchUserID: String?
    var mutchiUserData = [String: [String: Any]]()//[UID: [message:メッセージ、image:写真]]
    var message_image_Data = [String: Any]()//[message:メッセージ、image:写真]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mutchUserID = mutchiUserData.map{$0.0}[0]
        message_image_Data = mutchiUserData.map{$0.1}[0]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.hidesBackButton = true
        customNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()
    
    
    //navigationbar右上にブロック+通報のボタン設置
    @IBAction func report(_ sender: Any) {
        
        guard let my = self.names?[0] else { return }
        guard let target = self.names?[1] else { return }
        //通報
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle:  UIAlertController.Style.actionSheet)        
        let report: UIAlertAction = UIAlertAction(title: "投稿者を通報", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            //メール送信が可能なら
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([ADDRESS])
                mail.setSubject("通報")
                //メッセージ本文
                if let messegaText = self.message_image_Data["message"] as? String {
                    mail.setMessageBody("通報理由(任意)\n\n\n投稿者名:\(my)\n投稿相手名:\(target)\nmessage:\(messegaText)", isHTML: false)
                } else {
                    mail.setMessageBody("通報理由(任意)\n\n\n投稿者名:\(my)\n投稿相手名:\(target)", isHTML: false)
                }
                self.present(mail, animated: true)
                
            } else {
                //メール送信が不可能
                self.alert(title: "メールアカウントを設定してください", message: "", actiontitle: "OK")
            }
            
            //エラー処理
            func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                if error != nil {
                    print(error!)//送信失敗
                } else {
                    controller.dismiss(animated: true, completion: nil)
                }
            }
        })
        
        //投稿ユーザーブッロク（検索に引っかからないようにする）
        let block: UIAlertAction = UIAlertAction(title: "投稿者をブロック", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            //ブロックUIDをUDに保存
            //ブロックり履歴有り
            if  var blocksUserID = UD.array(forKey: UdKey.keys.block.rawValue),
                let userID = self.mutchUserID {
                blocksUserID += [userID]
                UD.set(blocksUserID, forKey: UdKey.keys.block.rawValue)
                
            }  else {
                //初ブロック
                if let account = self.mutchUserID {
                    UD.set([account], forKey: UdKey.keys.block.rawValue)
                }
            }
            
            let alert = UIAlertController(title: "この投稿をしたユーザーをブロックしました", message: "", preferredStyle: .alert)
            self.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    alert.dismiss(animated: true)
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
        self.present(alert, animated: true)
    }
}
    
    


extension SeachResultViewCotroller: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResultCell
            
            cell.myName.text = names?[0] ?? ""
            cell.targetName.text = names?[1] ?? ""
            
            cell.myName.adjustsFontSizeToFitWidth = true
            cell.targetName.adjustsFontSizeToFitWidth = true
            cell.myName.minimumScaleFactor = 0.5
            cell.targetName.minimumScaleFactor = 0.5
            
            
            guard let iconImage: String = message_image_Data["image"] as? String else { return cell }
            
                let url = URL(string: iconImage)
                // image変換
                DispatchQueue.global().async {
                    do {
                        let imageData = try Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            let image = UIImage(data:imageData as Data)
                            cell.profileImage.image = image
                        }
                    } catch {
                        return
                    }
                }
            return cell
            
        } else {
            
            let messagecell = tableView.dequeueReusableCell(withIdentifier: "messagecell", for: indexPath) as! MessageCell
            messagecell.messageLabel.text = message_image_Data["message"] as? String ?? ""
            return messagecell
        }
    }
}

extension SeachResultViewCotroller:UITableViewDelegate {
    
    func  tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        
        switch section {
        case 0: label.text = "posting card"
        case 1: label.text = "message"
        default: break
        }
        return label
    }
}
