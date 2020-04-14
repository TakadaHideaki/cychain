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
        tableView.register(UINib(nibName: "PostCardeTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCardeTableViewCell")

    }
    
    func initializeUI() {
        customNavigationBar()
    }
    
    func initializeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
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
        
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "PostCardeTableViewCell", for: indexPath) as! PostCardeTableViewCell

        
        if indexPath.section == 0 {
            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "postcardCell", for: indexPath) as! postcardCell
            
            
            guard let myName = registData?["my"] as? String,
                let targetName = registData?["target"] as? String,
                let profile = registData?["image"] as? UIImage ?? UIImage(named: "user12")
                else { return cell2 }
            
            cell2.mynameLabel.text = myName
            cell2.targetLabel.text = targetName
            cell2.profileImage.image = profile
            
            cell2.mynameLabel.adjustsFontSizeToFitWidth = true
            cell2.targetLabel.adjustsFontSizeToFitWidth = true
            cell2.mynameLabel.minimumScaleFactor = 0.5
            cell2.targetLabel.minimumScaleFactor = 0.5

//            cell.mynameLabael.text = registData?["my"] as? String ?? ""
//            cell.targerNameLabel.text = registData?["target"] as? String ?? ""
//            cell.photoImage.image = registData?["image"] as? UIImage ?? UIImage(named: "user12")
//            cell.mynameLabael.adjustsFontSizeToFitWidth = true
//            cell.targerNameLabel.adjustsFontSizeToFitWidth = true
//            cell.mynameLabael.minimumScaleFactor = 0.5
//            cell.targerNameLabel.minimumScaleFactor = 0.5

            return cell2
            
        }
        return cell2
//        else {
//
//            let messagecell = tableView.dequeueReusableCell(withIdentifier: "messagecell", for: indexPath) as! MessageCell
//            messagecell.messageLabel.text = registData?["message"] as? String ?? ""//メッセージ
//            return messagecell
//        }
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
    
    

