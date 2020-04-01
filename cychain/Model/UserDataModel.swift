//
//  UserDataModel.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/03/31.
//  Copyright © 2020 高田英明. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase


protocol modelDelegate {
    func did()
}

class UserDataModel {
    
    var delegate: modelDelegate?

    var my: String?
    var target: String?
    var message: String?
    var icon: UIImage?
    
    
    func set(my: String, target: String, message: String, icon: UIImage){
        self.my = my as String
        self.target = target
        self.message = message
        self.icon = icon
    }
    
    
    
    func setFirebase() {
        
        let ref = Database.database().reference().child("\(my!)/\(target!)/\(USER_ID!)")
        let storageRef = STORAGE.child("\(my!)/\(target!)/\(USER_ID!)/\("imageData")")
        let defaultIcon = UIImage(named: "user10")
        
        switch icon {
        case defaultIcon: ref.setValue(message)
        
        default:
//            if let imageData = icon?.pngData() {
//                storageRef.putData(imageData, metadata: nil){ (metadata, error)in
//
//                    guard metadata != nil else { return }
//                    storageRef.downloadURL { (url, error) in
//                        guard let downloadURL = url else { return }
//                        let profileimage = downloadURL.absoluteString
           let aaa = aa(icon: self.icon!, ref: storageRef)
        
                
                        
                        // Firebaseに写真 + message保存
//                        ref.updateChildValues(["message": self.message as Any, "image": profileimage])
            ref.updateChildValues(["message": self.message as Any, "image": aaa])

            
                    }
                }
            }
        
    
    
//    func aa(icon: UIImage, ref: StorageReference) -> String {
//        var profileimage = ""
//        if let imageData = icon.pngData() {
//            ref.putData(imageData, metadata: nil){ (metadata, error)in
//                
//                guard metadata != nil else { return }
//                ref.downloadURL { (url, error) in
//                    guard let downloadURL = url else { return }
//                    profileimage = downloadURL.absoluteString
//                }
//            }
//        }
//        return profileimage
//    }

    





