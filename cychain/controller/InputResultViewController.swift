//
//  postCard.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/04/07.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import GoogleMobileAds


class InputResultViewController: UIViewController, UIImagePickerControllerDelegate {
        
    
    @IBOutlet weak var tableView: UITableView!
    
    var registData: [String: Any]?
    var userInputData: [String: Any]?
    var userDataModel: UserDataModel?

    
    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeTableView()
        tableView.reloadData()
        userDataModel = UserDataModel.sharead
    }
    
    func initializeUI() {
        customNavigationBar()
    }
    
    func initializeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
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
            
            guard let myName = userDataModel?.my,
                let targetName = userDataModel?.target,
                let profile = userDataModel?.icon
                else { return profileCell }
//
//            let profile: UIImage?
//            if userDataModel?.icon == UIImage(named: "user10") {
//                     profile = UIImage(named: "user12")
//                 } else {
//                     profile = userDataModel?.icon
//                 }

            
            profileCell.mynameLabel.text = myName
            profileCell.targetLabel.text = targetName
            profileCell.profileImage.image = profile
            
            profileCell.mynameLabel.adjustsFontSizeToFitWidth = true
            profileCell.targetLabel.adjustsFontSizeToFitWidth = true
            profileCell.mynameLabel.minimumScaleFactor = 0.5
            profileCell.targetLabel.minimumScaleFactor = 0.5
            
            return profileCell
            
        case 1:
            
            let messagecell = tableView.dequeueReusableCell(withIdentifier: "PostCardMessageCell", for: indexPath) as! PostCardMessageCell
            userDataModel = UserDataModel.sharead


            guard let message = userDataModel?.message else { return messagecell }
            messagecell.messageLabel.text = message//メッセージ

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
    
    

