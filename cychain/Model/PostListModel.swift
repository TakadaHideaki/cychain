import UIKit
import RxDataSources
import Firebase

struct PostListSectionModel {
    var items: [Item]
}

extension PostListSectionModel: SectionModelType {
    typealias Item = [String: String]
    
    init(original: PostListSectionModel, items: [Item] ) {
        self = original
        self.items = items
    }
}





/*

class DataListModel {
    
    
    private init() {}
    static let sharead = DataListModel()
    
    var list: [[String: String]]?
    var myArray: [String]?
    var targetArray: [String]?
    var row: Int?
    var ref: DatabaseReference? {
        get {
            guard let row = row,
                let my = myArray,
                let target = targetArray
                else { return Database.database().reference() }
            return
                Database.database().reference().child("\(my[row])/\(target[row])/\(USER_ID!)")
        }
    }
    var storageRef: StorageReference {
        get {
            guard let row = row,
                let my = myArray,
                let target = targetArray
                else { return STORAGE }
            return
                STORAGE.child("\(my[row])/\(target[row])/\(USER_ID!)/\("imageData")")
        }
    }
    
    
    func setUserDataList() {
        if let UDNamesList = UD.object(forKey: Name.KeyName.uniqueNmame.rawValue) as? [[String: String]] {
            
            list = UDNamesList
            myArray = (UDNamesList.map{ $0.keys.sorted()}).flatMap{$0}      // mynameだけのarray
            targetArray = (UDNamesList.map{$0.values.sorted()}).flatMap{$0} 
        }
    }

    
    func deleteRowsAction() {
        deleteFirebaseData()
        deleteFireStorage()
        updateUserDefault()
    }
    
    func deleteFirebaseData() {
        ref?.removeValue()
    }
    
    func deleteFireStorage() {
        storageRef.delete { error in
            if let error = error {
                let nsError = error as NSError
                if nsError.domain == StorageErrorDomain &&
                    nsError.code == StorageErrorCode.objectNotFound.rawValue {
                    log.debug("Storage Nofile")
                }
            } else {
                log.debug("Storege Delete Success")
            }
        }
    }
    
    func updateUserDefault() {
        guard let row = row else { return }
        list?.remove(at: row)
        self.myArray?.remove(at: row)
        self.targetArray?.remove(at: row)
        UD.set(list, forKey: Name.KeyName.uniqueNmame.rawValue)
    }
    
    
    
    func downloadFirebaseData(complete: @escaping ([String: String]) -> ()) {
        
        ref?.observeSingleEvent(of: .value, with: { (DataSnapshot) in
            
            if var userData = DataSnapshot.value as? [String: String] {//userData = [message:メッセージ, image:写真]
                userData["my"] = self.myArray![self.row!]
                userData["target"] = self.targetArray![self.row!]
                complete(userData)
                
            } else {
                let userData = ["my": self.myArray![self.row!],
                "target": self.targetArray![self.row!]]
                complete(userData)
            }
        })
    }
    
}*/
