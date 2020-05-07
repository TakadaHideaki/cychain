//
//  setting.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/08/30.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import GoogleSignIn
import MessageUI

class SettingsViewController: UIViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate  {
    
    
    @IBOutlet weak var tableView: UITableView!

    var settingModel: SettingModel?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeTableview()
        settingModel = SettingModel()
        settingModel?.delegate = self
    }
    
    func initializeUI() {
        customNavigationBar()
    }
    
    func initializeTableview() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
}



extension SettingsViewController: UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EnumCells.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let account = settingModel?.account,
            let other = settingModel?.other
            else { return 0 }
        
        switch Section(rawValue: section) {
        case .account: return account.count
        case .other: return other.count
        case .none: return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let account = settingModel?.account,
                let other = settingModel?.other
                else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch Section(rawValue: indexPath.section ) {
        case .account:
            cell.textLabel?.text = account[indexPath.row]
        case .other:
            cell.textLabel?.text = other[indexPath.row]
        default : break
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingModel?.sectionTitle[section]
    }
}
    


    
extension SettingsViewController: UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let titles = tableView.cellForRow(at: indexPath)?.textLabel?.text! else { return }
        
        switch titles {
        case ("ログアウト"): settingModel?.logOut()
        case ("アカウント削除"): settingModel?.signOut()
        case ("問い合わせ"): sendMail()
        case ("利用規約"): switchVC(view: "terms1", animation: true)
        case ("プライバシーポリシー"): switchVC(view: "privacyPolicy", animation: true)
        default: break
        }
    }
    
    
    //    メールviewの処理
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            print("\(error!)")//送信失敗
        } else {
            controller.dismiss(animated: true)
        }
    }

}

extension SettingsViewController: SettingModelDelegate {
    
    func logoutAlert() {
        logOutAlert()
    }
    func sendmailErrorAlert() {
        sendMailErrorAlert()
    }
    func signoutErrorAlert() {
        signOutErrorAlert()
    }
    func signoutAlert() {
        signOutAlert()
    }
}




