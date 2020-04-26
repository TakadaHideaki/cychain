//
//  DataListModel.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/04/25.
//  Copyright © 2020 高田英明. All rights reserved.
//

import UIKit
import Firebase


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
        if let UDNamesList = UD.object(forKey: UDKey.keys.uniqueNmame.rawValue) as? [[String: String]] {
            
            list = UDNamesList
            myArray = (UDNamesList.map{ $0.keys.sorted()}).flatMap{$0}      // mynameだけのarray
            targetArray = (UDNamesList.map{$0.values.sorted()}).flatMap{$0} 
        }
    }
    
//    func rowDelerte(row: Int) {
//
//        guard let my = my?[row],
//            let target = target?[row]
//            else { return }
        
//        let ref = Database.database().reference().child("\(my)/\(target)/\(USER_ID!)")
//        let storageRef = STORAGE.child("\(my)/\(target)/\(USER_ID!)/\("imageData")")
    
    func rowDelerte() {
        
        ref?.removeValue() // firebaseデータ削除
        // fireStorage写真削除
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
        //UDを更新
        guard let row = row else { return }
        list?.remove(at: row)
        self.myArray?.remove(at: row)
        self.targetArray?.remove(at: row)
        UD.set(list, forKey: UDKey.keys.uniqueNmame.rawValue)
    }
    
    func getFirebase(complete: @escaping ([String: String]) -> ()) {
        
        let names: [String: String] = ["my": self.myArray![self.row!],
                                          "target": self.targetArray![self.row!]]
        
        
        ref?.observeSingleEvent(of: .value, with: { (DataSnapshot) in
            
            if let userdata = DataSnapshot.value as? [String: String] {//[message:メッセージ, image:写真]
                
                let userData = names.merging(userdata, uniquingKeysWith: +)
                //
                
                
                //                userdata["my"] = self.myArray?[self.row!]
                //                userdata["target"] = self.targetArray?[self.row!]
                //                let userData = userdata
                
                complete(userData)
                
            } else {
                
                //            guard let userData = userdata else { return }
                let userData = names
                complete(userData)
            }
            
            
            
            
            
        })
        
    }
    
}
