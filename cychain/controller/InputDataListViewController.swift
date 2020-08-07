import UIKit
import Firebase
import RxSwift
import RxCocoa
import RxDataSources
import GoogleMobileAds


class InputDataListViewController: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!

    private var dataSource: RxTableViewSectionedReloadDataSource<PostListSectionModel>!
    private let disposeBag = DisposeBag()
    private let userDefaultClass = setUserDefault()
    var indicatorView = UIActivityIndicatorView()
    var viewmodel = PostListViewModel()
//    var dataListModel: DataListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeTableView()
//        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        setCell()
        tappedCell()
//        deleteCell()
        bind()
    }
    
    func initializeUI() {
        self.navigationItem.hidesBackButton = true
        customNavigationBar()
//        dataListModel = DataListModel.sharead
//        dataListModel?.setUserDataList()
    }
    
    func initializeTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
//    override func viewWillLayoutSubviews() {
//        _ = self.initViewLayout
//    }
//    lazy var initViewLayout : Void = {
//        admob()
//    }()
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        tabBarController?.tabBar.isHidden = false
//
//        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
//            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
//        }
//        tableView.reloadData()
//    }
    
    private func setCell() {
        dataSource = RxTableViewSectionedReloadDataSource<PostListSectionModel> (
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? inputDataListCell

                item.keys.forEach{ cell?.myName.text = $0 }
                item.values.forEach{ cell?.targetName.text = $0 }
                return cell!
        })
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
    }
    
    func tappedCell() {
        tableView.rx.itemSelected.map { indexPath in
            return(indexPath, self.dataSource[indexPath])
        }
        .subscribe(onNext: { pair in
//            log.debug(pair.1)//[string: String]
        })
            .disposed(by: disposeBag)
    }
    
//    func deleteCell() {
//        tableView.rx.itemDeleted
//            .subscribe(onNext: {
//
//                self.viewmodel.removeItem(at: $0)
//                //deleteudへedit
//                log.debug($0)
//            })
//        .disposed(by: disposeBag)
//    }
        
        private func bind() {
            
//            let input = PostListViewModel.Input(onDeleteCell: userDefaultClass.resetUdData)
            let input = PostListViewModel
                .Input(onDeleteCell: tableView.rx.itemDeleted.asObservable(), onSelectedCell: tableView.rx.itemSelected.asObservable())
                                                

            
            
            
            let output = viewmodel.transform(input: input)
//            let output = viewmodel.transform()

            output.cellObj
                .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
            
            output.deleteCompleted
                .subscribe(onNext: {
                log.debug($0)
            })
                .disposed(by: disposeBag)

          }
    
}

extension InputDataListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 80
       }
    
}



/*

extension InputDataListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataListModel?.list?.count ?? 0
    }


//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! inputDataListCell
//        cell.myName.text = dataListModel?.myArray?[indexPath.row] ?? ""
//        cell.targetName.text = dataListModel?.targetArray?[indexPath.row] ?? ""
//        return cell
//    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        dataListModel?.row = indexPath.row
        dataListModel?.deleteRowsAction()
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}


extension InputDataListViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //EditViewへ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dataListModel?.row = indexPath.row
        dataListModel?.downloadFirebaseData(complete: { userData in

            let singleton = EditData.sharedInstance
            singleton.SingletonUserData = userData
            self.presentVC(vc: R.storyboard.main.editNC()!, animation: true)
        })
        
    }
}
 */
