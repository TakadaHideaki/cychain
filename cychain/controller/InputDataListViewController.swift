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
    var myNames: [String]?
    var targetNames: [String]?
    var indicatorView = UIActivityIndicatorView()
    var dataListModel: DataListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeTableView()
    }
    
    func initializeUI() {
        self.navigationItem.hidesBackButton = true
        customNavigationBar()
        dataListModel = DataListModel.sharead
        dataListModel?.setUserDataList()
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
        tableView.reloadData()
    }
}



extension InputDataListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataListModel?.list?.count ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        cell.myName.text = dataListModel?.myArray?[indexPath.row] ?? ""
        cell.targetName.text = dataListModel?.targetArray?[indexPath.row] ?? ""
        return cell
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        dataListModel?.row = indexPath.row
        dataListModel?.rowDelerte()
        
//        let myname = myNames?[indexPath.row] ?? ""
//        let targetname = targetNames?[indexPath.row] ?? ""
//        let ref = Database.database().reference().child("\(myname)/\(targetname)/\(USER_ID!)")
//        let storageRef = STORAGE.child("\(myname)/\(targetname)/\(USER_ID!)/\("imageData")")
//
//        if editingStyle == .delete {
//            // firebaseのデータ削除
//            ref.removeValue()
//            // fireStorageの写真削除
//            storageRef.delete { error in
//                if let error = error {
//                    let nsError = error as NSError
//                    if nsError.domain == StorageErrorDomain &&
//                        nsError.code == StorageErrorCode.objectNotFound.rawValue {
//                        log.debug("Storage Nofile")
//                    }
//                } else {
//                    log.debug("Storege Delete Success")
//                }
//            }
//            //UDから削除
//            namesList?.remove(at: indexPath.row)
//            myNames?.remove(at: indexPath.row)
//            targetNames?.remove(at: indexPath.row)
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
        dataListModel?.getFirebase(complete: { userData in

            let singleton = EditData.sharedInstance
            singleton.SingletonUserData = userData
            self.presentVC(view: "EditNC", animation: true)
        })
        
//        let myName = myNames?[indexPath.row] ?? ""
//        let searchName = targetNames?[indexPath.row] ?? ""
//        let ref = Database.database().reference().child("\(myName)/\(searchName)/\(USER_ID!)")

//        ref.observeSingleEvent(of: .value, with: { (DataSnapshot) in
//
//            var UserData = DataSnapshot.value as? [String: String]//[message:メッセージ, image:写真]
//            UserData?["my"] = myName
//            UserData?["target"] = searchName
//
//            let singleton = EditData.sharedInstance
//            singleton.SingletonUserData = UserData

//            self.presentVC(view: "EditNC", animation: true)
//        })
    }
}
