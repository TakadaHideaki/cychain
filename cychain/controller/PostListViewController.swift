import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import GoogleMobileAds


class PostListViewController: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate {
        
    private lazy var dataSource =
        RxTableViewSectionedReloadDataSource<PostListSectionModel> (
            configureCell: {
                [weak self] _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostListTableViewCell
                item.forEach{ cell?.userNameLabel.text = $0.key }
                item.forEach{ cell?.targetNameLabel.text = $0.value }
                return cell!
            }
    )
    
    lazy var tableView = { () -> UITableView in
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.tableFooterView = UIView(frame: .zero)
        let nib = UINib(nibName: "PostListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        return tableView
    }()
    
    private let disposeBag = DisposeBag()
    private let userDefaultClass = SetUserDefault()
    private let indicatorView = UIActivityIndicatorView()
    private let viewmodel = PostListViewModel()
    private let editModel = EditModel.shared
    
    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canSelectCell()
        customNavigationBar()
        bind()
     }

    func canSelectCell() {
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
    }
    
    private func bind() {
        let input = PostListViewModel
            .Input( onDeleteCell: tableView.rx.itemDeleted.asObservable(),
                    onSelectedCell: tableView.rx.itemSelected.asObservable())
        
        let output = viewmodel.transform(input: input)
        //表示用cellデータ
        output.cellObj?
        .debug()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //cellタップ        
        output.selectedPairName?
                  .bind(onNext: { pair in
                    self.editModel.observe(value: pair)
                    self.presentVC(vc: R.storyboard.main.editNC()! , animation: true)
//                      self.pushVC(vc: R.storyboard.main.editNC()! , animation: true)
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
