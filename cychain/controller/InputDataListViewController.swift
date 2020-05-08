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
    
//    var namesList: [[String:String]]? //[[myname, targetname]]
//    var myNames: [String]?
//    var targetNames: [String]?
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! inputDataListCell
        cell.myName.text = dataListModel?.myArray?[indexPath.row] ?? ""
        cell.targetName.text = dataListModel?.targetArray?[indexPath.row] ?? ""
        return cell
    }


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
