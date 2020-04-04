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


class UserDataModel {
    
    var my: String?
    var target: String?
    var message: String?
    var icon: UIImage?
    
    
//     init(my: String, target: String, message: String, icon: UIImage){
//           self.my = my as String
//           self.target = target
//           self.message = message
//           self.icon = icon
//        super.init(nibName: nil, bundle: nil)
//       }
    
   
    

    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    

    
    init(data: [String: Any]) {
        self.my = data["my"] as? String
        self.target = data["target"] as? String
        self.message = data["message"] as? String
        self.icon = data["image"] as? UIImage
    }
    
//
//    func set(my: String, target: String, message: String, icon: UIImage){
//        self.my = my as String
//        self.target = target
//        self.message = message
//        self.icon = icon
//    }
    
    
    func setFirebase() {
        
        let ref = Database.database().reference().child("\(my!)/\(target!)/\(USER_ID!)")
        let storageRef = STORAGE.child("\(my!)/\(target!)/\(USER_ID!)/\("imageData")")
        let defaultIcon = UIImage(named: "user10")
        
        switch icon {
        case defaultIcon:
            ref.setValue(message)
        default:
            let iconImage = setIconStorage(icon: self.icon!, ref: storageRef)
            ref.updateChildValues(["message": self.message as Any, "image": iconImage])
        }
    }
    
 

    
    
    
    
    
    
    
    
    
}













            
            
            //            if let imageData = icon?.pngData() {
            //                storageRef.putData(imageData, metadata: nil){ (metadata, error)in
            //
            //                    guard metadata != nil else { return }
            //                    storageRef.downloadURL { (url, error) in
            //                        guard let downloadURL = url else { return }
            //                        let profileimage = downloadURL.absoluteString
            
            // Firebaseに写真 + message保存
            //   ref.updateChildValues(["message": self.message as Any, "image": profileimage])
//        }
//    }
//}
        
    
    
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

    





