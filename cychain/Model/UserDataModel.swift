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


    private init() {}
    static let sharead = UserDataModel()
    
    var userInputData: [String: Any]?
    var my: String?
    var target: String?
    var message: String?
    var icon: UIImage?

    func setData(userData: [String: Any]) {
        self.userInputData = userData
        self.my = userData["my"] as? String
        self.target = userData["target"] as? String
        self.message = userData["message"] as? String
        self.icon = userData["image"] as? UIImage
    }
    
    var ref: DatabaseReference? {
        get {
            return
                Database.database().reference().child("\(my!)/\(target!)/\(USER_ID!)")
        }
    }
    var storageRef: StorageReference {
        get {
            return
                STORAGE.child("\(my!)/\(target!)/\(USER_ID!)/\("imageData")")
        }
    }
     
//     
//    func getData() -> (my: String, target: String, message: String, icon: UIImage) {
//        return (my!, target!, message!, icon!)
//     }


//struct UserDataModel {
//
//    var userInputData: [String: Any]?
//    var my: String?
//    var target: String?
//    var message: String?
//    var icon: UIImage?
//
//    init(data: [String: Any]) {
//        self.userInputData = data
//        self.my = data["my"] as? String
//        self.target = data["target"] as? String
//        self.message = data["message"] as? String
//        self.icon = data["image"] as? UIImage
//    }
//}


//class UserDataModelSingleton {
    
//    var userDataModel = UserDataModel(data: ["" : (Any).self])
//    static let sharead = UserDataModelSingleton()
//    private init() {}
    
    
//    func setData(userData: [String: Any]) {
//        userDataModel.userInputData = userData
//    }
//
//
//    func getData() -> [String: Any] {
//        return userDataModel.userInputData!
//    }
    
    
    func setUserDfault() {
        
        if var UDData = UD.object(forKey: UDKey.keys.uniqueNmame.rawValue) as? [[String : String]] {
            
            if !UDData.contains([my!:target!]) {
                UDData += [[my!:target!]]
                UD.set(UDData, forKey: UDKey.keys.uniqueNmame.rawValue)
            }
        } else {
            UD.set([[my:target]], forKey: UDKey.keys.uniqueNmame.rawValue)
        }
    }
    
    
    func setFirebase() {
        
//        guard let message = userData["message"] as? String,
//            let icon = userData["image"] as? UIImage
//            else { return }
        
//        let ref = Database.database().reference().child("\(my!)/\(target!)/\(USER_ID!)")
        


//        let storageRef = STORAGE.child("\(my)/\(target)/\(USER_ID!)/\("imageData")")
        let defaultIcon = UIImage(named: "user10")
        
        switch icon {
        case defaultIcon:
            ref?.setValue(["message": self.message])
            
        default:
            setIconStorage(icon: icon!, ref: storageRef, complete: { imageURL in
                self.ref?.setValue(["message": self.message as Any, "image": imageURL])
            })
        }
    }
    
//}



}

    
    
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
    
    

    

    
//
//    func set(my: String, target: String, message: String, icon: UIImage){
//        self.my = my as String
//        self.target = target
//        self.message = message
//        self.icon = icon
//    }
    
    
    //""messageが　as Any にキャストできなかったら↓
    //    mutaing func setFirebase() {
    















            
            
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

    





