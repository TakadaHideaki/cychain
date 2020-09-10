import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import GoogleMobileAds

class SeachResultListViewCOntroller: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate  {

    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel> (
        configureCell: { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
            cell.textLabel?.text = ("\([indexPath.row + 1])件目")
            return cell
    })
    private let viewModel = MatchListViewModel()
    private let disposeBag = DisposeBag()
    private var model = multiMatchModel.shared
    
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
        initializeTableView()
//        setCell()
        bind()
        didSelectCell()
       
    }
    func initalizeUI() {
        self.navigationItem.hidesBackButton = true
        customNavigationBar()
    }
    func initializeTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    func didSelectCell() {
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
    }
    
 
    
//    func setCell() {
//        dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel> (
//            configureCell: { _, tableView, indexPath, item in
//                let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
//                cell.textLabel?.text = ("\([indexPath.row + 1])件目")
//                return cell
//        })
//        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
//            return true
//        }
//    }
    
    private func bind() {
        let input = MatchListViewModel
            .Input(onSelectedCell: tableView.rx.itemSelected.asObservable())
        
        
        let output = viewModel.transform(input: input)
        //表示用cellデータ
        output.cellObj
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
//
        output.selectCellObj
            .subscribe(onNext: {
                self.model.setData(selectIndexPathRow: $0)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SeachResultMultipleViewCOntroller") as? MultiMatchViewController
                self.presentVC(vc: vc!, animation: true)
            })
        .disposed(by: disposeBag)

        
        
    }
    
    
    
    
    
}

    
    

    


    
    
    
    


/*extension SeachResultListViewCOntroller: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userID.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        cell.textLabel?.text = ("\([indexPath.row + 1])件目")
        return cell
    }
}

extension SeachResultListViewCOntroller: UITableViewDelegate {
    
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let SeachResultMultipleVC = self.storyboard?.instantiateViewController(withIdentifier: "SeachResultMultipleViewCOntroller") as! SeachResultMultipleViewCOntroller
        
        SeachResultMultipleVC.nameArray = names
        SeachResultMultipleVC.account = userID[indexPath.row]
        SeachResultMultipleVC.value = value[indexPath.row]
        self.navigationController?.pushViewController(SeachResultMultipleVC, animated: true)
    }
}*/





//    func userDataSet() {
//        matchDataModel = MatchData.shared
//        guard let userName = matchDataModel?.names,
//               let muchData = matchDataModel?.muchData
//               else { return }
//
//        names = userName
//        muchData.forEach {
//            userID += [$0.key]
//            value += [$0.value]
//        }
//    }

