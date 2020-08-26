import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import GoogleMobileAds

class PostResultViewController: UIViewController {
        
    final private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel>!
    final private let viewModel = PostResultViewModel()
    final private let disposeBag = DisposeBag()
    final var posedtData: Texts?
    var tableView: UITableView!
    /*
    static func returnVC(data: Texts) -> InputResultViewController {
     let storyboard = UIStoryboard(name: "Main", bundle: nil)
     let vc = storyboard.instantiateViewController(withIdentifier: "PostCardeTableViewCell") as? InputResultViewController
     vc?.posedtData = data
     return vc!
     }
     
     init(data: Texts) {
//     self.posedtData = data


     super.init(nibName: nil, bundle: nil)
     }
     required init?(coder: NSCoder) {

     fatalError("init(coder:) has not been implemented")
     }
 */
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        registCell()
        setCell()
        bind()
        
    }
    
//    func setTableView() {
//          self.tableView = {
//          let tableView = UITableView(frame: self.view.bounds, style: .plain)
//          tableView.autoresizingMask = [
//            .flexibleWidth,
//            .flexibleHeight
//          ]
//          self.view.addSubview(tableView)
//
//          return tableView
//
//        }()
//    }
   
    
    func initializeTableView() {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
                tableView.autoresizingMask = [
                  .flexibleWidth,
                  .flexibleHeight
                ]
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
        dataSource = RxTableViewSectionedReloadDataSource<SectionModel> (
            configureCell: { _, tableView, indexPath, item in
                switch indexPath.section {
                case 0:
                    let profileCell = tableView.dequeueReusableCell(withIdentifier: "P_Cell", for: indexPath) as! ProfileCell
                    
                    profileCell.mynameLabel.text = item["my"] as? String
                    profileCell.targetLabel.text = item["target"] as? String
                    profileCell.profileImage.image = item["icon"] as? UIImage
                    
                    profileCell.mynameLabel.adjustsFontSizeToFitWidth = true
                    profileCell.targetLabel.adjustsFontSizeToFitWidth = true
                    profileCell.mynameLabel.minimumScaleFactor = 0.5
                    profileCell.targetLabel.minimumScaleFactor = 0.5
                    return profileCell
                    
                case 1:
                    let messagecell = tableView.dequeueReusableCell(withIdentifier: "M_Cell", for: indexPath) as! MessageCell
                    messagecell.messageLabel.text = item["message"] as? String
                    return messagecell
                    
                default: break
                }
                return UITableViewCell()
        })
    }
    
    
     func bind() {
        guard let posedtData = self.posedtData else {return}
        let input = PostResultViewModel.Input(postData: Observable.just([posedtData]))
        let output = viewModel.transform(input: input)

        
        output.cellObj
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
}



extension PostResultViewController: UITableViewDelegate {
    
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
