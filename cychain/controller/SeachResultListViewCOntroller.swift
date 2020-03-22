//
//  MatchResult2.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/03/10.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SeachResultListViewCOntroller: UIViewController, UINavigationControllerDelegate  {
    
    var names: [String]?
    var userID = [String]()
    var value = [[String:Any]]()
    var indicatorView = UIActivityIndicatorView()
    var mutchingUserData = [String: [String: Any]]()

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeUI()
        initializeTableView()
        indicator()
        
        userDataSet()
        
//        mutchingUserData.forEach {
//            userID += [$0.key]
//            value += [$0.value]
//        }
        tableView.reloadData()
    }
    
    func initalizeUI() {
        self.navigationItem.hidesBackButton = true
        customNavigationBar()
    }
    
    func initializeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)  
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    
    func userDataSet() {
        guard let userName = MatchData.sharedInstance.SingletonNames,
               let userData = MatchData.sharedInstance.SingletonUserData
               else { return }
        names = userName
        
        userData.forEach {
            userID += [$0.key]
            value += [$0.value]
        }
    }

    
    
    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()
}

extension SeachResultListViewCOntroller: UITableViewDataSource {
    
    
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
        
        indicatorView.startAnimating()
        
        let SeachResultMultipleVC = self.storyboard?.instantiateViewController(withIdentifier: "SeachResultMultipleViewCOntroller") as! SeachResultMultipleViewCOntroller
        SeachResultMultipleVC.names = names
        SeachResultMultipleVC.account = userID[indexPath.row]
        SeachResultMultipleVC.value = value[indexPath.row]
        self.navigationController?.pushViewController(SeachResultMultipleVC, animated: true)
        self.indicatorView.stopAnimating()
    }
}

