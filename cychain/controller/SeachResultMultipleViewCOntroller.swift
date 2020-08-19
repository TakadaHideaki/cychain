import UIKit
import GoogleMobileAds
import MessageUI

class SeachResultMultipleViewCOntroller: SeachResultViewCotroller {
    
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var coverView1: UIView!
    
    var value: [String:Any]?
    var nameArray: [String]?
    var account: String?
}
/*
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initalizeTableView()
        cellRegist()
        matchDataModel = MatchData.shared
    }
    
    override func initalizeTableView() {
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.tableFooterView = UIView(frame: .zero)
    }
    
    override func cellRegist() {
        tableView.register(UINib(resource:R.nib.postCardeTableViewCell), forCellReuseIdentifier: "PostCardeTableViewCell")
          tableView.register(UINib(resource:R.nib.postCardMessageCell), forCellReuseIdentifier: "PostCardMessageCell")

    }

    @IBAction func report1(_ sender: Any) {
        repotAction()
    }

}


extension SeachResultMultipleViewCOntroller {
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let profileCell = tableView1.dequeueReusableCell(withIdentifier: "PostCardeTableViewCell", for: indexPath) as! ProfileCell
            
            guard let names = nameArray else { return profileCell }
            
            profileCell.mynameLabel.text = names[0]
            profileCell.targetLabel.text = names[1]
            
            profileCell.mynameLabel.adjustsFontSizeToFitWidth = true
            profileCell.targetLabel.adjustsFontSizeToFitWidth = true
            profileCell.mynameLabel.minimumScaleFactor = 0.5
            profileCell.targetLabel.minimumScaleFactor = 0.5
            
            if let urlImage = value?["image"] as? String  {
                matchDataModel?.convertURLtoUIImage(URLImage: urlImage, { complete in
                    profileCell.profileImage.image = complete
                    self.coverView1.isHidden = true
                    self.indicator.stopAnimating()
                })
            } else {
                //アイコン登録が無かっったらデフォルトアイコンをセット
                profileCell.profileImage.image = R.image.user12()
                self.coverView1.isHidden = true
                self.indicator.stopAnimating()
            }
            
            return profileCell
            
        case 1:
            
            let messagecell = tableView1.dequeueReusableCell(withIdentifier: "PostCardMessageCell", for: indexPath) as! MessageCell
            messagecell.messageLabel.text = value?["message"] as? String ?? ""
            return messagecell
            
        default: break
            
        }
        return UITableViewCell()
    }
    
    
    
    override func sendMailAction() {
        
        guard let my = self.nameArray?[0]  else { return }
        guard let target = self.nameArray?[1] else { return }
        let message = self.value?["message"] as? String  ?? ""
        //メール送信が可能なら
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([ADDRESS])
            mail.setSubject("通報")
            //メッセージ本文
            mail.setMessageBody("通報理由(任意)\n\n\n投稿者名:\(my)\n投稿相手名:\(target)\nmessage:\(message)", isHTML: false)
            
            self.present(mail, animated: true)
            
        } else {
            //メール送信が不可能
            sendMailErrorAlert()
        }
        //エラー処理
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if error != nil {
                log.debug(error!)//送信失敗
            } else {
                controller.dismiss(animated: true)
            }
        }
    }
    
    override func blockAction() {
        //ブロックユーザー登録
        guard let blockid = account else { return }
        matchDataModel?.blockUserRegistration(blockID: blockid)
        let alert = UIAlertController(title: "この投稿をしたユーザーをブロックしました", message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                alert.dismiss(animated: true)
            })
        })
    }
    
    
    
}
 
 */
