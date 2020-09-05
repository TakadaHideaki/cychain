import Foundation
import RxSwift
import RxCocoa
import Firebase

struct FirebaseObj {
    let my: String
    let target: String
    let icon: UIImage
    var setRef: DatabaseReference {
        get {
            Database.database().reference().child("\(my)/\(target)/\(USER_ID!)")
        }
    }
    var observeRef: DatabaseReference {
          get {
              Database.database().reference().child("\(my)/\(target)")
          }
      }
    var storageRef: StorageReference {
        get {
            STORAGE.child("\(my)/\(target)/\(USER_ID!)/\("imageData")")
        }
    }
}

class SetFirebase {
    
    var f = BehaviorRelay<[String:[String:Any]]?>(value: ["": ["": ""]])
      var data: Observable<[String:[String:Any]]?> {
          return f.asObservable()
      }
    
    /*     func set(data: Texts) -> Observable<Texts>  {
     return Observable.create { observer in
     let datas = FirebaseObj.init(my: data.my,target: data.target,icon: data.iconImage)
     
     switch datas.icon {
     case R.image.user12():
     datas.ref.setValue(["message": data.message])
     observer.onNext(data)
     return Disposables.create()
     default:
     setIconStorage(icon: datas.icon, ref: datas.storageRef, complete: { imageURL in
     datas.ref.setValue(["message": data.message as Any, "image": imageURL])
     })
     observer.onNext(data)
     return Disposables.create()
     
     }
     }
     }*/
    func set(data: Texts)  {
        let datas = FirebaseObj.init(my: data.my,target: data.target,icon: data.iconImage)
        switch datas.icon {
        case R.image.user12():
            datas.setRef.setValue(["message": data.message])
        default:
            setIconStorage(icon: datas.icon, ref: datas.storageRef, complete: { imageURL in
                datas.setRef.setValue(["message": data.message as Any, "image": imageURL])
            })
        }
    }
    
    
    func delete(data: [String: String]) {
        //                    let datas = FirebaseObj(my: key, target: value, icon: R.image.user10()!)
        //                    datas.ref.removeValue()
        //                    datas.storageRef.delete { error in
        //                        if let error = error {
        //                            let nsError = error as NSError
        //                            if nsError.domain == StorageErrorDomain &&
        //                                nsError.code == StorageErrorCode.objectNotFound.rawValue {
        //                                log.debug("Storage Nofile")
        //                            }
        //                        } else {
        //                            log.debug("Storege Delete Success")
        //                        }
        //                    }
        
    }
    
    /*
     func observe(value: SerachWord, complete: @escaping (String) -> ()) {
     
     var dataSnapshot = "初期"
     //
     let obj = FirebaseObj.init(my: value.userName,
     target: value.searchName,
     icon: R.image.user10()!
     )
     obj.ref.observeSingleEvent(of: .value, with: { (DataSnapshot) in
     
     if DataSnapshot.value is NSNull {
     dataSnapshot = "datasnapshot = nil"
     complete(dataSnapshot)
     
     } else {
     dataSnapshot =  "datasnapshot = Notnil"
     complete(dataSnapshot)
     }
     })
     
     }*/
    
    func observe(value: SearchWord) {
        
//        let obj = FirebaseObj.init(my: value.userName,
//                                   target: value.searchName,
//                                   icon: R.image.user10()!
//        )
//        obj.observeRef.observeSingleEvent(of: .value, with: { dataSnapshot in
//            if dataSnapshot.value is NSNull {
//                self.f.accept(nil)
//            } else {
//                let mutchiUserData = dataSnapshot.value
//                self.f.accept(mutchiUserData as? [String: [String : Any]])
//            }
//        })
        
        // SamyData
        
        self.f.accept(["TestIDA":["message": "TestMessage"], "TestIDB":["message": "Test"]])
//        self.f.accept(["TestIDA":["message": "TestMessage"]])


        
        
        
    }


    
 
    
    
    
}

/*    func observe(value: SerachWord, complete: @escaping ([String: [String : Any]]?) -> ()) {
    
    let obj = FirebaseObj.init(my: value.userName,
                               target: value.searchName,
                               icon: R.image.user10()!
    )
    obj.ref.observeSingleEvent(of: .value, with: { dataSnapshot in
        if dataSnapshot.value is NSNull {
            complete(nil)
        } else {
            let mutchiUserData = dataSnapshot.value
            complete(mutchiUserData as? [String: [String : Any]])
        }
    })
}
*/

    
    
    
    
    
    
    
    
    
    


    
    
    
    
    
//    let my: String = ""
//    let target: String = ""
//    let icon: UIImage = R.image.user12()!
//    var ref: DatabaseReference {
//        get {
//            Database.database().reference().child("\(my)/\(target)/\(USER_ID!)")
//        }
//    }
//    var storageRef: StorageReference {
//        get {
//            STORAGE.child("\(my)/\(target)/\(USER_ID!)/\("imageData")")
//        }
//    }
    
    /*
    func set(data: Texts) -> Texts {
        let datas = FirebaseObj.init(my: data.my,target: data.target,icon: data.iconImage)
        
        switch datas.icon {
        case R.image.user12(): return data
//            datas.ref.setValue(["message": data.message])
        default:
//            setIconStorage(icon: datas.icon, ref: datas.storageRef, complete: { imageURL in
//                datas.ref.setValue(["message": data.message as Any, "image": imageURL])
//            })
            return data
        }
 */
    

    
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

//        let my = data.my
//        let target = data.target
//        let icon = data.iconImage
//        let ref = Database.database().reference().child("\(my)/\(target)/\(USER_ID!)")
//        let storageRef = STORAGE.child("\(my)/\(target)/\(USER_ID!)/\("imageData")")
        
//        switch icon {
//        case R.image.user10():
//            ref.setValue(["message": data.message])
//
//        default:
//            setIconStorage(icon: icon, ref: storageRef, complete: { imageURL in
//                ref.setValue(["message": data.message as Any, "image": imageURL])
//            })
//        }
//    }
    
    
    
 

    
    
    
    
    /*
    func delete(data: [[String: String]]) {
        
        //        let my = data[0].keys
        //        let target = data[0].values
        //        let ref = Database.database().reference().child("\(my)/\(target)/\(USER_ID!)")
        //        let storageRef = STORAGE.child("\(my)/\(target)/\(USER_ID!)/\("imageData")")
        
        //        var datas: FirebaseObj
        
        
        
        
     /*
        data[0].forEach {
            let datas = FirebaseObj(my: $0.key, target: $0.value, icon: R.image.user10()!)
            datas.ref.removeValue()
            datas.storageRef.delete { error in
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
 */
    }
 */
    
    
