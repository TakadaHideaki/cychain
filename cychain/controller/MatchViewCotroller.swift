import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MessageUI
import GoogleMobileAds

class MatchViewCotroller: UIViewController {
    
    private let viewModel = MatchViewModel()
    var cellObject: BaseViewModel = MatchViewModel()
    let disposeBag = DisposeBag()
    let reportRelay = BehaviorRelay<Void>(value: ())
    var reportObservable: Observable<Void> { return reportRelay.asObservable() }
    let blockRelay = PublishRelay<Void>()
    var blockObservable: Observable<Void> { return blockRelay.asObservable() }
    
    private lazy var dataSource =
        RxTableViewSectionedReloadDataSource<MatchSectionModel> (
            configureCell: { [weak self] _, tableView, indexPath, item in
                
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
            }
    )
    
    lazy var coverView: UIView = {
        let view = UIView()
        view.frame = self.view.bounds
        view.backgroundColor = .white
        view.alpha = 0.5
        self.view.addSubview(view)
        self.view.bringSubviewToFront(view)
        return view
    }()
    
    lazy var indicatorView = { () -> UIActivityIndicatorView in
        var view = UIActivityIndicatorView.init(style: .whiteLarge)
        view.color = .gray
        self.view.addSubview(view)
        self.view.bringSubviewToFront(view)
        return view
    }()
    
    var naviBarButton = { () -> UIBarButtonItem in
        let button = UIBarButtonItem()
        button.image = R.image.menu()!
        button.style = .plain
        return button
    }()
    
    lazy var tableView = { () -> UITableView in
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        
        let nib = UINib(resource: R.nib.postCardeTableViewCell)
        tableView.register(nib, forCellReuseIdentifier: "P_Cell")
        
        let messageNib = UINib(resource: R.nib.postCardMessageCell)
        tableView.register(messageNib, forCellReuseIdentifier: "M_Cell")
        
        self.view.addSubview(tableView)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        return tableView
    }()
    
    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        self.tableView.isScrollEnabled = false
        self.navigationItem.rightBarButtonItem = naviBarButton
    }
    
    func bind() {
        let input = MatchViewModel.Input(
            naviBarButtonTaaped: naviBarButton.rx.tap.asObservable(),
            reportTapped: self.reportObservable,
            blockTapped: self.blockObservable
        )
        
        let output = viewModel.transform(input: input)
        
        //cellData
        cellObject.cellObj
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //indicaotr & CoverView
        output.indicator.drive(self.indicatorView.rx.isAnimating).disposed(by: disposeBag)
        output.indicator.drive(self.indicatorView.rx.isHidden).disposed(by: disposeBag)
//
        //NavBarBtnTap(Repot or Block)
        output.naviBarButtonEvent
            .bind(onNext: { self.repotAction() })
            .disposed(by: disposeBag)
        
        //ReportTapp
        output.reportObj.skip(1)
            .bind(onNext: { self.sendMailAction(user: $0["user"]!, blockUser: $0["search"]!, msg: $0["msg"]! ) })
            .disposed(by: disposeBag)
        
        //BlockTapp
        output.blockID.skip(1)
            .bind(onNext: { self.blockAction() })
            .disposed(by: disposeBag)
    }
    
}


//extension Reactive where Base: UIControl {
//    public var isHidden: Binder<Bool> {
//        return Binder(self.base) { control, value in
//            control.isHidden = value
//        }
//    }
//}


extension MatchViewCotroller: UITableViewDelegate {
    
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


extension MatchViewCotroller: MFMailComposeViewControllerDelegate {
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
        let alert = UIAlertController(title: "この投稿ユーザーをブロックしました", message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                alert.dismiss(animated: true)
            })
        })
    }
    
}
