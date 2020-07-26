import UIKit
import MessageUI
import GoogleMobileAds

class SeachResultViewCotroller: UIViewController, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coverView: UIView!
    
    var names: [String]?//[nyname, searchname]
    var message_image_Data = [String: Any]()//[message:メッセージ、image:写真]
    var matchDataModel: MatchData?
    var report: UIAlertAction?
    var block: UIAlertAction?
    var indicator = UIActivityIndicatorView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initalizeTableView()
        cellRegist()
        matchDataModel = MatchData.shared
    }
    
    func initializeUI() {
        self.navigationItem.hidesBackButton = true
        customNavigationBar()
        indicator.center = view.center
        indicator.style = .whiteLarge
        indicator.color = .black
        view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        indicator.startAnimating()
    }
    
     func initalizeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)

    }
    func cellRegist() {
        tableView.register(UINib(nibName: "PostCardeTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCardeTableViewCell")
        tableView.register(UINib(nibName: "PostCardMessageCell", bundle: nil), forCellReuseIdentifier: "PostCardMessageCell")
    }
    
    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()
    
    //navigationbar右上にブロック+通報のボタン設置
    @IBAction func report(_ sender: Any) {
        repotAction()
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
        
        
        
        switch indexPath.section {
        case 0:
            
            let profileCell = tableView.dequeueReusableCell(withIdentifier: "PostCardeTableViewCell", for: indexPath) as! PostCardeTableViewCell
            
            profileCell.mynameLabel.text = matchDataModel?.names?[0]
            profileCell.targetLabel.text = matchDataModel?.names?[1]
            
            profileCell.mynameLabel.adjustsFontSizeToFitWidth = true
            profileCell.targetLabel.adjustsFontSizeToFitWidth = true
            profileCell.mynameLabel.minimumScaleFactor = 0.5
            profileCell.targetLabel.minimumScaleFactor = 0.5
            
            //アイコン登録があったらアイコンのURLをUIImageに変換する
            if let urlImage = matchDataModel?.URLImage {
                matchDataModel?.convertURLtoUIImage(URLImage: urlImage, { complete in
                    profileCell.profileImage.image = complete
                    //アイコンに画像設定が終わったらインディケーターoff
                    self.coverView.isHidden = true
                    self.indicator.stopAnimating()
                    
                })
            } else {
                //アイコン登録が無かっったらデフォルトアイコンをセット
                profileCell.profileImage.image = R.image.user12()
                self.coverView.isHidden = true
                self.indicator.stopAnimating()
            }
            return profileCell
            
        case 1:
            
            let messagecell = tableView.dequeueReusableCell(withIdentifier: "PostCardMessageCell", for: indexPath) as! PostCardMessageCell
            messagecell.messageLabel.text = matchDataModel?.message ?? ""
            return messagecell
            
        default: break
            
        }
        return UITableViewCell()
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


extension SeachResultViewCotroller {
    //通報
     func repotAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let report = UIAlertAction(title: "投稿者を通報", style: .default) {
            (action: UIAlertAction!) in
            self.sendMailAction()
        }
        //投稿ユーザーブッロク（検索に引っかからないようにする）
        let block = UIAlertAction(title: "投稿者をブロック", style: .default) {
            (action: UIAlertAction!) in
            self.blockAction()
        }
        // Cancelボタン
        let cancel = UIAlertAction(title: "cancel", style: .cancel){
                   (action: UIAlertAction!) in
        }
        
        let actions = [report, block, cancel]
        actions.forEach { alert.addAction($0) }
        self.present(alert, animated: true)
    }
    
    
    @objc func sendMailAction() {

        guard let my = matchDataModel?.names?[0] else { return }
        guard let target = matchDataModel?.names?[1] else { return }
        let message = matchDataModel?.message ?? ""
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
    
    
    
   @objc func blockAction() {
        //ブロックユーザー登録
        matchDataModel?.blockUserRegistration(blockID: (matchDataModel?.matchuserID)!)
        let alert = UIAlertController(title: "この投稿をしたユーザーをブロックしました", message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                alert.dismiss(animated: true)
            })
        })
    }
    
}
    
    

    

