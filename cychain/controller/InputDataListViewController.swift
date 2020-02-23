//
//  profileViewController2.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/01/31.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds



class InputDataListViewController: UIViewController, UINavigationControllerDelegate {


    @IBOutlet var tableView: UITableView!
    
    var namesList: [[String:String]]? //[[myname, targetname]]
    //mynameとtargetnameに分けたが分けづにnamesでアクセスした方がいいか
    //分けた理由は分けた方が自分が分かりやすかったから
    var myNames: [String]?
    var targetNames: [String]?
    var indicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeTableView()
    }
    
    func initializeUI() {
        self.navigationItem.hidesBackButton = true
        customNavigationBar()
    }
    
    func initializeTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
        
        //投稿データが有れば
        if let UDNamesList = UD.object(forKey: UdKey.keys.uniqueNmame.rawValue) as? [[String: String]] {
            self.namesList = UDNamesList
            myNames = (UDNamesList.map{ $0.keys.sorted()}).flatMap{$0}      // mynameだけのarray
            targetNames = (UDNamesList.map{$0.values.sorted()}).flatMap{$0} //targetだけのarray
        }
        tableView.reloadData()
    }
}



extension InputDataListViewController: UITableViewDataSource {


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesList?.count ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        cell.myName.text = myNames?[indexPath.row] ?? ""
        cell.targetName.text = targetNames?[indexPath.row] ?? ""
        return cell
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let myname = myNames?[indexPath.row] ?? ""
        let targetname = targetNames?[indexPath.row] ?? ""
        let ref = Database.database().reference().child("\(myname)/\(targetname)/\(USER_ID!)")
        let storageRef = STORAGE.child("\(myname)/\(targetname)/\(USER_ID!)/\("imageData")")
        
        
        if editingStyle == .delete {
            // firebaseのデータ削除
            ref.removeValue()
            // fireStorageの写真削除
            storageRef.delete { error in
                if let error = error {
                    let nsError = error as NSError
                    if nsError.domain == StorageErrorDomain &&
                        nsError.code == StorageErrorCode.objectNotFound.rawValue {
                        print("nofile")
                    }
                } else {
                    print("success")
                }
            }
            //UDから削除
            if var names = namesList {
                names.remove(at: indexPath.row)
                self.namesList = names
                tableView.deleteRows(at: [indexPath], with: .fade)
                UD.set(names, forKey: UdKey.keys.uniqueNmame.rawValue)
            }
            tableView.reloadData()
        }
    }
}


extension InputDataListViewController: UITableViewDelegate {


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    //EditViewへ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indicatorView.startAnimating()
        
        let myName = myNames?[indexPath.row] ?? ""
        let searchName = targetNames?[indexPath.row] ?? ""
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "DataEditVC") as! EditViewController
        let ref = Database.database().reference().child("\(myName)/\(searchName)/\(USER_ID!)")
        
        ref.observeSingleEvent(of: .value, with: { (DataSnapshot) in
            
            var UserData = DataSnapshot.value as? [String: String]//[message:メッセージ, image:写真]
            UserData?["my"] = myName
            UserData?["target"] = searchName
            
            //写真が投稿されていれば写真データをEditVewのimageに値た渡し
            if let imageUrl = UserData?["image"] {
                let url = URL(string: imageUrl)
                // image変換
                do {
                    let imageData = try Data(contentsOf: url!)
                    let image = UIImage(data:imageData as Data)
                    editVC.iconImage = image
                } catch {
                    print(error)
                }
            }
            editVC.userData = UserData
            self.navigationController?.pushViewController(editVC, animated: true)
            self.indicatorView.stopAnimating()
        })
    }
}
