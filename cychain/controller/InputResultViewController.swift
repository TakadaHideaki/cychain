//
//  postCard.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/04/07.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMobileAds


//class InputResultViewController: UIViewController, UIImagePickerControllerDelegate {
class InputResultViewController: UIViewController {

        
    
    @IBOutlet weak var tableView: UITableView!
    
//    var registData: [String: Any]?
//    var userInputData: [String: Any]?
    var userDataModel: UserDataModel?
    private let disposeBag = DisposeBag()
    
    let viewModel: PostResultViewModel
    let items: BehaviorRelay<[String]>


    
    init(text1: String) {
//        self.viewModel = PostResultViewModel(text1: text1)
        self.viewModel = PostResultViewModel(text1: text1)
        self.items = BehaviorRelay(value: [text1])
        log.debug(text1)
        


        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.debug(self.items)
//        initializeUI()
//        initializeTableView()
//        tableView.reloadData()
//        userDataModel = UserDataModel.sharead
        
//        self.items.bind(to: tableView.rx.items(cellIdentifier: "PostCardeTableViewCell", cellType: PostCardeTableViewCell.self)) { row, elemnt, cell in
//            cell.mynameLabel.text = elemnt

    }}
        
        
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
