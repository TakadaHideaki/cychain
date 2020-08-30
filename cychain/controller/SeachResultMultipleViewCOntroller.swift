import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MessageUI
import GoogleMobileAds
import MessageUI


class SeachResultMultipleViewCOntroller: SeachResultViewCotroller {
    
    private var dataSource: RxTableViewSectionedReloadDataSource<multiMatchSectionModel>!
    private let viewModel = MultiMatchViewModel()
    
    override func setCell() {
        dataSource = RxTableViewSectionedReloadDataSource<multiMatchSectionModel> (
            
            configureCell: { _, tableView, indexPath, item in
                switch indexPath.section {
                case 0:
                    let profileCell = tableView.dequeueReusableCell(withIdentifier: "P_Cell", for: indexPath) as! ProfileCell
                    
                    profileCell.mynameLabel.text = item.map{$0.1}[0]["user"] as? String
                    profileCell.targetLabel.text = item.map{$0.1}[0]["search"] as? String
                    profileCell.profileImage.image = item.map{$0.1}[0]["image"] as? UIImage
                    
                    profileCell.mynameLabel.adjustsFontSizeToFitWidth = true
                    profileCell.targetLabel.adjustsFontSizeToFitWidth = true
                    profileCell.mynameLabel.minimumScaleFactor = 0.5
                    profileCell.targetLabel.minimumScaleFactor = 0.5
                    return profileCell
                case 1:
                    let messagecell = tableView.dequeueReusableCell(withIdentifier: "M_Cell", for: indexPath) as! MessageCell
                    messagecell.messageLabel.text = item.map{$0.1}[0]["msg"] as? String
                    return messagecell
                default: break
                }
                return UITableViewCell()
        })
    }
    
    override func bind() {
        let input = MultiMatchViewModel.Input(
            naviBarButtonTaaped: naviBarButton.rx.tap.asObservable().debug(),
            reportTapped: self.reportObservable,
            blockTapped: self.blockObservable
        )

        let output = viewModel.transform(input: input)
        
        output.cellObj
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //indicaotr & CoverView
        output.indicator.drive(self.indicatorView.rx.isAnimating).disposed(by: disposeBag)
        output.indicator.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.coverView?.isHidden = true
            })
            .disposed(by: disposeBag)
        
        output.naviBarButtonEvent
                 .subscribe(onNext: { [weak self] _ in
                     self?.repotAction()
                 })
             .disposed(by: disposeBag)
        
        //ReportTapp
        output.reportObj.skip(1).subscribe(onNext: { [weak self] data in
            self?.sendMailAction(user: data["user"]!, blockUser: data["search"]!, msg: data["msg"]! )
        })
            .disposed(by: disposeBag)
        
        //BlockTapp
        output.blockID.skip(1).subscribe(onNext: { [weak self] _ in
            self?.blockAction()
        })
            .disposed(by: disposeBag)
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = dataSource[section].sectionTitle
        return label
    }
    
}
 
 

/*

class SeachResultMultipleViewCOntroller: UIViewController, UIScrollViewDelegate{

            
    
    private var dataSource: RxTableViewSectionedReloadDataSource<multiMatchSectionModel>!
    private let viewModel = MultiMatchViewModel()
        let disposeBag = DisposeBag()
        var report: UIAlertAction?
        var block: UIAlertAction?
        let indicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
        var coverView: UIView?
        var tableView: UITableView!
        var naviBarButton: UIBarButtonItem!
        let reportRelay = BehaviorRelay<Void>(value: ())
        var reportObservable: Observable<Void> { return reportRelay.asObservable() }
        let blockRelay = BehaviorRelay<Void>(value: ())
        var blockObservable: Observable<Void> { return blockRelay.asObservable() }

        
        override func viewWillLayoutSubviews() {
            _ = self.initViewLayout
        }
        lazy var initViewLayout : Void = {
            admob()
        }()

        override func viewDidLoad() {
            super.viewDidLoad()
            initializeUI()
            setCell()
            bind()
        }
        
        func initializeUI() {
            setBarButton()
            setIndicator()
            setCoverView()
            initializeTableView()
            registCell()
        }
        
        func setIndicator() {
            indicatorView.center = view.center
            indicatorView.color = .gray
            self.view.addSubview(indicatorView)
            self.view.bringSubviewToFront(indicatorView)
        }
        
        func setCoverView() {
            coverView = UIView(frame: self.view.frame)
            coverView?.backgroundColor = .white
            coverView?.alpha = 0.5
            self.view.addSubview(coverView!)
            self.view.bringSubviewToFront(coverView!)
        }
        
        func setBarButton() {
            naviBarButton = UIBarButtonItem()
            naviBarButton.image = R.image.menu()!
            naviBarButton.style = .plain
            self.navigationItem.rightBarButtonItem = naviBarButton
        }
        
        func initializeTableView() {
            let tableView = UITableView(frame: self.view.bounds, style: .plain)
            tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.separatorStyle = .none
            self.view.addSubview(tableView)
            self.tableView = tableView
            tableView.rx.setDelegate(self).disposed(by: disposeBag)
        }
        
        func registCell() {
              let nib = UINib(resource: R.nib.postCardeTableViewCell)
              tableView.register(nib, forCellReuseIdentifier: "P_Cell")
              
              let messageNib = UINib(resource: R.nib.postCardMessageCell)
              tableView.register(messageNib, forCellReuseIdentifier: "M_Cell")
          }
        
           func setCell() {
                 dataSource = RxTableViewSectionedReloadDataSource<multiMatchSectionModel> (
                     
                     configureCell: { _, tableView, indexPath, item in
                         switch indexPath.section {
                         case 0:
                             let profileCell = tableView.dequeueReusableCell(withIdentifier: "P_Cell", for: indexPath) as! ProfileCell
                             
                             profileCell.mynameLabel.text = item.map{$0.1}[0]["user"] as? String
                             profileCell.targetLabel.text = item.map{$0.1}[0]["search"] as? String
                             profileCell.profileImage.image = item.map{$0.1}[0]["image"] as? UIImage
                             
                             profileCell.mynameLabel.adjustsFontSizeToFitWidth = true
                             profileCell.targetLabel.adjustsFontSizeToFitWidth = true
                             profileCell.mynameLabel.minimumScaleFactor = 0.5
                             profileCell.targetLabel.minimumScaleFactor = 0.5
                             return profileCell
                         case 1:
                             let messagecell = tableView.dequeueReusableCell(withIdentifier: "M_Cell", for: indexPath) as! MessageCell
                             messagecell.messageLabel.text = item.map{$0.1}[0]["msg"] as? String
                             return messagecell
                         default: break
                         }
                         return UITableViewCell()
                 })
             }
        
    func bind() {
               
               let input = MultiMatchViewModel.Input(
                   naviBarButtonTaaped: naviBarButton.rx.tap.asObservable(),
                   reportTapped: self.reportObservable,
                   blockTapped: self.blockObservable
               )
               
               let output = viewModel.transform(input: input)
               
               output.cellObj
                   .bind(to: self.tableView.rx.items(dataSource: dataSource))
                   .disposed(by: disposeBag)
               
               //indicaotr & CoverView
               output.indicator.drive(self.indicatorView.rx.isAnimating).disposed(by: disposeBag)
               output.indicator.asObservable()
                   .subscribe(onNext: { [weak self] _ in
                       self?.coverView?.isHidden = true
                   })
                   .disposed(by: disposeBag)
               
               //ReportTapp
                   output.reportObj.skip(1).subscribe(onNext: { [weak self] data in
                       self?.sendMailAction(user: data["user"]!, blockUser: data["search"]!, msg: data["msg"]! )
                   })
                       .disposed(by: disposeBag)
                   
                   //BlockTapp
                   output.blockID.skip(1).subscribe(onNext: { [weak self] _ in
                       self?.blockAction()
                   })
                       .disposed(by: disposeBag)
               
               
           }
        

        
        
         
    }


    extension SeachResultMultipleViewCOntroller: UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
               return 210
           }
        
        func  tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let label = UILabel()
            label.backgroundColor = UIColor.clear
            label.textColor = UIColor.gray
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.text = dataSource[section].sectionTitle
            return label
        }
    }


    extension SeachResultMultipleViewCOntroller: MFMailComposeViewControllerDelegate {
         func repotAction() {
     
             //Definition_Alert
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            //ReportAction(sendMail)
            let report = UIAlertAction(title: "投稿者を通報", style: .default) {
                (action: UIAlertAction!) in
                self.reportRelay.accept(())
            }
            //userBlock（検索に引っかからないようにする）
            let block = UIAlertAction(title: "投稿者をブロック", style: .default) {
                (action: UIAlertAction!) in
                self.blockRelay.accept(())
            }
            // Cancel
            let cancel = UIAlertAction(title: "cancel", style: .cancel){
                       (action: UIAlertAction!) in
            }
            
            let actions = [report, block, cancel]
            actions.forEach { alert.addAction($0) }
            self.present(alert, animated: true)
        }
        

        func sendMailAction(user: String, blockUser: String, msg: String) {
            //SendMaill_OK
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([ADDRESS])
                mail.setSubject("通報")
                //MSG
                mail.setMessageBody("通報理由(任意)\n\n\n投稿者名:\(user)\n投稿相手名:\(blockUser)\nmessage:\(msg)", isHTML: false)
                self.present(mail, animated: true)
            
            } else {
                //SendMaill_NG
                sendMailErrorAlert()
            }
            //error
            func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                if error != nil {
                    log.debug(error!)//送信失敗
                } else {
                    controller.dismiss(animated: true)
                }
            }
        }
        
        func blockAction() {
            let alert = UIAlertController(title: "この投稿をしたユーザーをブロックしました", message: "", preferredStyle: .alert)
            self.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    alert.dismiss(animated: true)
                })
            })
        }
        
    }
 
 */



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

       IBAction func report1(_ sender: Any) {
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

