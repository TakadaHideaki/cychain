import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import GoogleMobileAds
import Rswift
    
class MatchListViewController: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate  {
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel> (
        configureCell: { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
            item.forEach { cell.textLabel?.text = "ID: \($0)さんからの投稿" }
            return cell
    })
    
    lazy var tableView = { () -> UITableView in
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "resultCell")
        self.view.addSubview(tableView)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        return tableView
    }()
    
    private let viewModel = MatchListViewModel()
    private let disposeBag = DisposeBag()
    private var model = MatchModel.shared
    
    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeUI()
        didSelectCell()
        bind()
    }
    
    func initalizeUI() {
        self.navigationItem.hidesBackButton = true
    }

    func didSelectCell() {
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
    }
    
    private func bind() {
        let input = MatchListViewModel
            .Input(onSelectedCell: tableView.rx.itemSelected.asObservable())
        
        let output = viewModel.transform(input: input)
        //表示用cellデータ
        output.cellObj
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.selectCellObj
            .bind(onNext: {
                self.model.setData(data: self.model.matchdata, row: $0)
                self.pushVC(vc: R.storyboard.main.seachResultVC()!, animation: false)
            })
            .disposed(by: disposeBag)
    }
    
}
