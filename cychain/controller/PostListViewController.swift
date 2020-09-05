import UIKit
//import Firebase
import RxSwift
import RxCocoa
import RxDataSources
import GoogleMobileAds


class PostListViewController: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: RxTableViewSectionedReloadDataSource<PostListSectionModel>!
    private let disposeBag = DisposeBag()
    private let userDefaultClass = SetUserDefault()
//    var tableView: UITableView?
    var indicatorView = UIActivityIndicatorView()
    var viewmodel = PostListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        setCell()
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
    
    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        if let indexPathForSelectedRow = tableView?.indexPathForSelectedRow {
            tableView!.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
        tableView!.reloadData()
    }
    
    private func setCell() {
        dataSource = RxTableViewSectionedReloadDataSource<PostListSectionModel> (
            configureCell: { _, tableView, indexPath, item in
                log.debug(item)
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? inputDataListCell
                item.keys.forEach{ cell?.myName.text = $0 }
                item.values.forEach{ cell?.targetName.text = $0 }
                return cell!
        })
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
    }
    
    private func bind() {
        let input = PostListViewModel
            .Input(onDeleteCell: tableView!.rx.itemDeleted.asObservable(),
                   onSelectedCell: tableView!.rx.itemSelected.asObservable())
        
        let output = viewmodel.transform(input: input)
        //表示用cellデータ
        output.cellObj?
        .debug()
            .bind(to: tableView!.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
            
        
        //cellタップ
        output.selectedPairName?
            .subscribe(onNext: { pair in
                let sb = R.storyboard.main()
                let vc = sb.instantiateViewController(withIdentifier: "editVC") as? EditViewController
                vc?.pairName = pair
                log.debug(pair)
                self.navigationController?.pushViewController(vc!, animated: true)
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

//    func tappedCell() {
//        tableView.rx.itemSelected.map { indexPath in
//            return(indexPath, self.dataSource[indexPath])
//        }
//        .subscribe(onNext: { pair in
//            log.debug(pair.1)//[string: String]
//        })
//            .disposed(by: disposeBag)
//    }





