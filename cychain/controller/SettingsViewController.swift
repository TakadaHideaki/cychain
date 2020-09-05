import UIKit
import MessageUI
import RxSwift
import RxCocoa
import RxDataSources

class SettingsViewController: UIViewController, UINavigationControllerDelegate  {
    
    private lazy var dataSource =
        RxTableViewSectionedReloadDataSource<SettingSectionModel> (
            configureCell: configureCell,
            titleForHeaderInSection: titleForHeaderInSection
    )
    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<SettingSectionModel>.ConfigureCell = {
        [weak self] _, tableView, indexPath, item in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch Section(rawValue: indexPath.section ) {
          case .account:
            cell.textLabel?.text = item
          case .other:
            cell.textLabel?.text = item
          default : break
          }
          return cell
    }
    
    private lazy var titleForHeaderInSection: RxTableViewSectionedReloadDataSource<SettingSectionModel>.TitleForHeaderInSection = {
        datasouse, indexpath in
        return self.dataSource.sectionModels[indexpath].sectionTitle
    }

    private let viewModel = SettingViewModel()
    var model = SettingModel()
    let disposeBag = DisposeBag()
    var tableView: UITableView!

 
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        bind()
//        settingModel?.delegate = self
    }
    
    func initializeUI() {
        customNavigationBar()
        setTableView()
        registCell()
    }
    
    func setTableView() {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        self.tableView = tableView
        tableView.tableFooterView = UIView(frame: .zero)
//        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func registCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    func bind() {
        let input = SettingViewModel.Input(
            didSelectedCell: tableView!.rx.itemSelected.asObservable())
        
        let output = viewModel.transform(input: input)
        //表示用CellData
        output.cellObj
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //cellTap
        output.selectedCellEvent
            .subscribe(onNext: {
                switch $0 {
                case .logOut, .deleteAcount: break
                case .inquiry: self.sendMail()
                case .terms: self.pushVC(vc: R.storyboard.main.terms1()!, animation: true)
                case .privacy: self.pushVC(vc: R.storyboard.main.privacyPolicy()!, animation: true)
                }
            })
            .disposed(by: disposeBag)
        
        //LOgOUt
        output.logOutEvent
            .subscribe(onNext: {
                switch $0 {
                case .success: self.logOutAlert()
                case .error: self.logOutErrorAlert()
                }
            })
        .disposed(by: disposeBag)
        
        //SignOut
        output.signOutEvent
            .subscribe(onNext: {
                switch $0 {
                case .success: self.signOutAlert()
                case .error:  self.signOutErrorAlert()
                }
            })
        .disposed(by: disposeBag)
        
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    //    メールviewの処理
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            log.debug("\(error!)")//送信失敗
        } else {
            controller.dismiss(animated: true)
        }
    }
}



/*

extension SettingsViewController: UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EnumCells.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let account = settingModel?.account,
            let other = settingModel?.other
            else { return 0 }
        
        switch Section(rawValue: section) {
        case .account: return account.count
        case .other: return other.count
        case .none: return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let account = settingModel?.account,
                let other = settingModel?.other
                else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch Section(rawValue: indexPath.section ) {
        case .account:
            cell.textLabel?.text = account[indexPath.row]
        case .other:
            cell.textLabel?.text = other[indexPath.row]
        default : break
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingModel?.sectionTitle[section]
    }
}
    
    
extension SettingsViewController: UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let titles = tableView.cellForRow(at: indexPath)?.textLabel?.text! else { return }
        switch titles {
        case ("ログアウト"): settingModel?.logOut()
        case ("アカウント削除"): settingModel?.signOut()
        case ("問い合わせ"): sendMail()
        case ("利用規約"): pushVC(vc: R.storyboard.main.terms1()!, animation: true)
        case ("プライバシーポリシー"): pushVC(vc: R.storyboard.main.privacyPolicy()!, animation: true)
        default: break
        }
    }
 
 */
    
    




