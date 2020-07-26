import UIKit
import Firebase

protocol SettingModelDelegate: class {
    func logoutAlert()
    func sendmailErrorAlert()
    func signoutErrorAlert()
    func signoutAlert()
}

class SettingModel {

    weak var delegate: SettingModelDelegate?
    let sectionTitle = ["アカウント", "その他"]
    let account = ["ログアウト", "アカウント削除"]
    let other = ["問い合わせ", "利用規約", "プライバシーポリシー"]
    var array: [String:String]!

    
    func logOut() {
        do {
            log.debug("ログアウト成功")
            try Auth.auth().signOut()
            self.delegate?.logoutAlert()
            
        } catch _ as NSError {
            log.debug("ログアウト失敗")
            self.delegate?.sendmailErrorAlert()
        }
    }
    
    func signOut() {
        
        func haveData() {
            guard let names = UD.array(forKey: Name.KeyName.uniqueNmame.rawValue) as? [[String : String]] else { return }
            names.forEach {
                $0.forEach {
                    //  firebase削除
                    let ref = Database.database().reference().child("\($0)/\($1)/\(USER_ID!)")
                    ref.removeValue()
                    
                    //  fireStorage削除
                    let storageRef = STORAGE.child("\($0)/\($1)/\(USER_ID!)/\("imageData")")
                    storageRef.delete { error in
                        if error != nil {
                            log.debug("Storage delete error")
                        } else {
                            log.debug("Storage delete success")
                        }
                    }
                }
            }
        }
        
        haveData()
        let domain = Bundle.main.bundleIdentifier!
        UD.removePersistentDomain(forName: domain)
        
        Auth.auth().currentUser?.delete { error in
            if error != nil {
                self.delegate?.signoutErrorAlert()
            } else {
                self.delegate?.signoutAlert()
            }
        }
        
    }
    
}

enum EnumCells: Int {
    case plofileCell = 0
    case messageCell
    
    static var count: Int {
        return EnumCells.messageCell.rawValue + 1
    }
}

enum Section: Int {
    case account = 0
    case other
}
