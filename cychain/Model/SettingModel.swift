import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Firebase

struct SettingSectionModel {
    var sectionTitle: String
    var items: [Item]
}

extension SettingSectionModel: SectionModelType {
    
    typealias Item = String
    
    init(original: SettingSectionModel, items: [Item] ) {
        self = original
        self.items = items
    }
}

enum LogOut {
    case success
    case error
}

enum SignOut {
    case success
    case error
}

class SettingModel {

    let sectionTitle = ["アカウント", "その他"]
    let account = ["ログアウト", "アカウント削除"]
    let other = ["問い合わせ", "利用規約", "プライバシーポリシー"]
    
    let logOutRelay = PublishRelay<LogOut>()
    var logOutEvent: Observable<LogOut> { return logOutRelay.asObservable() }
   
    let signOutRelay = PublishRelay<SignOut>()
    var signOutEvent: Observable<SignOut> { return signOutRelay.asObservable() }
    
    func logOut() {
        do {
            logOutRelay.accept(LogOut.success)
            try Auth.auth().signOut()

        } catch _ as NSError {
            logOutRelay.accept(LogOut.error)
        }
    }
    
    func signOut() {
        
//        func haveData() {
//            guard let names = UD.array(forKey: Name.KeyName.uniqueNmame.rawValue) as? [[String : String]] else { return }
//            names.forEach {
//                $0.forEach {
//                    //  firebase削除
//                    let ref = Database.database().reference().child("\($0)/\($1)/\(USER_ID!)")
//                    ref.removeValue()
//
//                    //  fireStorage削除
//                    let storageRef = STORAGE.child("\($0)/\($1)/\(USER_ID!)/\("imageData")")
//                    storageRef.delete { error in
//                        if error != nil {
//                            log.debug("Storage delete error")
//                        } else {
//                            log.debug("Storage delete success")
//                        }
//                    }
//                }
//            }
//        }
//
//        haveData()
//        let domain = Bundle.main.bundleIdentifier!
//        UD.removePersistentDomain(forName: domain)
//
//        Auth.auth().currentUser?.delete { error in
//            if error != nil {
        signOutRelay.accept(SignOut.error)
//            } else {
        signOutRelay.accept(SignOut.success)
//            }
//        }
    }
    
}
//
//enum EnumCells: Int {
//    case plofileCell = 0
//    case messageCell
//
//    static var count: Int {
//        return EnumCells.messageCell.rawValue + 1
//    }
//}

enum Section: Int {
    case account = 0
    case other
}
