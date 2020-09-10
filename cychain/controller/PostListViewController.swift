import UIKit
//import Firebase
import RxSwift
import RxCocoa
import RxDataSources
import GoogleMobileAds


class PostListViewController: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var dataSource =
        RxTableViewSectionedReloadDataSource<PostListSectionModel> (
            configureCell: {
                [weak self] _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? inputDataListCell
                item.forEach{ cell?.myName.text = $0.key }
                item.forEach{ cell?.targetName.text = $0.value }
                return cell!
            }
    )
    
    private let disposeBag = DisposeBag()
    private let userDefaultClass = SetUserDefault()
    var indicatorView = UIActivityIndicatorView()
    var viewmodel = PostListViewModel()
    private let editModel = EditModel.shared
    
    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canSelectCell()
        initializeUI()
        bind()
     }
    
    func initializeUI() {
        self.navigationItem.hidesBackButton = true
        customNavigationBar()
        settableView()
    }
    
    func settableView() {
//        let tableView = UITableView(frame: self.view.bounds, style: .plain)
//        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.tableView = tableView
//        self.view.addSubview(self.tableView!)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func sregistCell() {
        self.tableView.register(inputDataListCell.self, forCellReuseIdentifier: "cell")
    }
    
    func canSelectCell() {
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
    }
    
    private func bind() {
        let input = PostListViewModel
            .Input(onDeleteCell: tableView.rx.itemDeleted.asObservable(),
                   onSelectedCell: tableView.rx.itemSelected.asObservable())
        
        let output = viewmodel.transform(input: input)
        //表示用cellデータ
        output.cellObj?
        .debug()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //cellタップ
        output.selectedPairName?
            .subscribe(onNext: { pair in
                self.editModel.observe(value: pair)
                self.pushVC(vc: R.storyboard.main.editNC()!, animation: false)
            })
            .disposed(by: disposeBag)
        
        //Cell削除
        output.deleteCompleted.subscribe().disposed(by: disposeBag)

    }
}

extension PostListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 80
       }
}
