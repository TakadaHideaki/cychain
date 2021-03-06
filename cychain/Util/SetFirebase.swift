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
    
    let serchResultRelay = PublishRelay<[String:[String:Any]]?>()
    var serchResultdata: Observable<[String:[String:Any]]?> {
        return serchResultRelay.asObservable().share()
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
    
    func set(data: PostDatas)  {
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
    
    
    func observe(value: SearchWord) {
        
        let obj = FirebaseObj.init(my: value.userName,
                                   target: value.searchName,
                                   icon: R.image.user10()!
        )
        obj.observeRef.observeSingleEvent(of: .value, with: { dataSnapshot in
            if dataSnapshot.value is NSNull {
                self.serchResultRelay.accept(nil)
            } else {
                let mutchiUserData = dataSnapshot.value
                self.serchResultRelay.accept(mutchiUserData as? [String: [String : Any]])
            }
        })
        
        
 /*　テスト用ダミーデータ
//        self.serchResultRelay.accept(["TestIDA":["message": "TestMessage"], "TestIDB":["message": "Test"]])
//        self.serchResultRelay.accept(["TestIDA":["message": "TestMessage"]])
    }
 */


        
    }
    
    
    
}
