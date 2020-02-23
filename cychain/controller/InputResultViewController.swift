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
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        log.debug(UD.object(forKey: UdKey.keys.uniqueNmame.rawValue) as? [[String: String]])
    }
    
    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var registData: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeTableView()
        tableView.reloadData()
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
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "postcardCell", for: indexPath) as! postcardCell

            cell.mynameLabael.text = registData?["my"] as? String ?? ""
            cell.targerNameLabel.text = registData?["target"] as? String ?? ""
            cell.photoImage.image = registData?["image"] as? UIImage ?? UIImage(named: "user12")
            cell.mynameLabael.adjustsFontSizeToFitWidth = true
            cell.targerNameLabel.adjustsFontSizeToFitWidth = true
            cell.mynameLabael.minimumScaleFactor = 0.5
            cell.targerNameLabel.minimumScaleFactor = 0.5

            return cell
            
        } else {
            
            let messagecell = tableView.dequeueReusableCell(withIdentifier: "messagecell", for: indexPath) as! MessageCell
            messagecell.messageLabel.text = registData?["message"] as? String ?? ""//メッセージ
            return messagecell
        }
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
    
    

