import UIKit
import RxSwift
import RxCocoa
import GoogleMobileAds


//class InputResultViewController: UIViewController, UIImagePickerControllerDelegate {
class InputResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    private let viewModel = PostResultViewModel()
    
//    let viewModel: PostResultViewModel
    private let disposeBag = DisposeBag()
    
    
    
        var userpostData: Observable<Any>


    init(data: Texts) {
        self.userpostData = Observable.just(data)
//        self.viewModel = PostResultViewModel(data: data)
          super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PostCardeTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCardeTableViewCell")
        bind()
    }
    
    private func bind() {
        let input = PostResultViewModel.Input(postData: self.userpostData)

//
        let output = viewModel.transform(input: input)
//
//                 output.cellData.subscribe(onNext: { value in
//                    log.debug(value)
//                })
//                .disposed(by: disposeBag)

        output.cellData
            .bind(to: tableView.rx.items(cellIdentifier: "PostCardeTableViewCell", cellType: PostCardeTableViewCell.self)) { (row, element, cell) in

        }
        .disposed(by: disposeBag)
    }
    
    
        

        
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    /*
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//
//        self.viewModel.eventSubject1.subscribe(onNext: { value in
//            log.debug(value)
//        })
//        .disposed(by: disposeBag)
 
 */

        
        
        
        
        
//
//        tableView.register(UINib(nibName: "PostCardeTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCardeTableViewCell")
//
//        viewModel.items
//            .bind(to: tableView.rx.items(cellIdentifier: "PostCardeTableViewCell", cellType: PostCardeTableViewCell.self)) { (row, element, cell) in
//
                
//                cell.mynameLabel.text = element as? String
//                cell.mynameLabel.adjustsFontSizeToFitWidth = true
//                cell.targetLabel.adjustsFontSizeToFitWidth = true
//                cell.mynameLabel.minimumScaleFactor = 0.5
//                cell.targetLabel.minimumScaleFactor = 0.5
//        }
//    .disposed(by: disposeBag)
//
//        tableView.rx.itemSelected
//            .subscribe(onNext: { indexPath in
//                log.debug("itemSelected")
//            })
//        .disposed(by: disposeBag)
//
    
    
 
    
}

























        
        
        /*
        
        tableView.register(UINib(nibName: "PostCardeTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCardeTableViewCell")
        tableView.register(UINib(nibName: "PostCardMessageCell", bundle: nil), forCellReuseIdentifier: "PostCardMessageCell")
        

        
        
        self.items.asObservable().bind(to: tableView.rx.items) { (tableView, row, elemnt) in

            let indexPath = IndexPath(row: row, section: 0)
            if row % 2 == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCardeTableViewCell", for: indexPath) as? PostCardeTableViewCell else { fatalError() }

                cell.mynameLabel.text = elemnt
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostCardMessageCell", for: indexPath) as! PostCardMessageCell
                return cell
            }
        }

    .disposed(by: disposeBag)
        
    }
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
    /*
 
   override func viewWillLayoutSubviews() {
         _ = self.initViewLayout
     }
     lazy var initViewLayout : Void = {
         admob()
     }()
     
     override func viewDidLoad() {
         super.viewDidLoad()
 //        initializeUI()
 //        initializeTableView()
 //        tableView.reloadData()
 //        userDataModel = UserDataModel.sharead
     }}

    
    func initializeUI() {
        customNavigationBar()
    }
    
    func initializeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
//
//
////        tableView.register(UINib(resource:R.nib.postCardeTableViewCell), forCellReuseIdentifier: "PostCardeTableViewCell")
////        tableView.register(UINib(resource:R.nib.postCardMessageCell), forCellReuseIdentifier: "PostCardMessageCell")
//
        tableView.register(UINib(nibName: "PostCardeTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCardeTableViewCell")
        tableView.register(UINib(nibName: "PostCardMessageCell", bundle: nil), forCellReuseIdentifier: "PostCardMessageCell")
    }
}


    
extension InputResultViewController: UITableViewDataSource {


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
            userDataModel = UserDataModel.sharead

            profileCell.mynameLabel.adjustsFontSizeToFitWidth = true
            profileCell.targetLabel.adjustsFontSizeToFitWidth = true
            profileCell.mynameLabel.minimumScaleFactor = 0.5
            profileCell.targetLabel.minimumScaleFactor = 0.5
            return profileCell

        case 1:

            let messagecell = tableView.dequeueReusableCell(withIdentifier: "PostCardMessageCell", for: indexPath) as! PostCardMessageCell
//            userDataModel = UserDataModel.sharead
            return messagecell

        default: break
        }
        return UITableViewCell()
    }
}



extension InputResultViewController: UITableViewDelegate {
    
    func  tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        switch section {
        case 0: label.text = "posting card"
        case 1: label.text = "message"
        default: break
        }
        return label
    }
}
 
 
    
    */

 }*/
