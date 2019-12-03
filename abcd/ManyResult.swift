//
//  MatchResult2.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/03/10.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ManyResult: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate  {
    
    var names: [String]!
    var account: [String]!
    var value = [[String:Any]]()
    var indicator = UIActivityIndicatorView()
    var admobView: GADBannerView!
    var indicatorView = UIActivityIndicatorView()


   

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.hidesBackButton = true
        
        admob()
        indicator()
        tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return account.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        cell.textLabel?.text = ("\([indexPath.row + 1])件目")
        return cell
    }
    
    
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indicatorView.startAnimating()
        
        let result3: result3 = self.storyboard?.instantiateViewController(withIdentifier: "result3") as! result3
        result3.names = names
        result3.value = value[indexPath.row]
        result3.account = account[indexPath.row]
        self.navigationController?.pushViewController(result3, animated: true)
        self.indicatorView.stopAnimating()
    }
}
