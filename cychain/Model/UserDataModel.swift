/*

import RxSwift
import RxCocoa
import Firebase
import FirebaseStorage
import FirebaseDatabase

class UserDataModel {
    
    
    private init() {}
    static let sharead = UserDataModel()
    
    let disposeBag = DisposeBag()
    
    var userInputData: [String: Any]?
    var my: String?
    var target: String?
    var message: String?
    var icon: UIImage?
 

//    convenience init
    

    func setData(userData: [String: Any]) {
        self.userInputData = userData
//        self.my = userData["my"] as? String
//        self.target = userData["target"] as? String
//        self.message = userData["message"] as? String

        //アイコンの登録がなければ登録アイコンをデフォルトアイコンに変換してself.iconにセット
        if userData["image"] as? UIImage == R.image.user10() {
            self.icon = R.image.user12()
        } else {
            //アイコンの登録があればそのままself.iconにセット
            self.icon = userData["image"] as? UIImage
        }
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
    
    
//    func setUserDefault() -> Observable<Bool> {
//
//        return Observable.create { obserber in
//
//            if var UDData = UD.object(forKey: Name.KeyName.uniqueNmame.rawValue) as? [[String : String]] {
//
//                if !UDData.contains([self.my!: self.target!]) {
//                    UDData += [[self.my!: self.target!]]
//                    UD.set(UDData, forKey: Name.KeyName.uniqueNmame.rawValue)
//                    obserber.onNext(true)
//                }
//            } else {
//                UD.set([[self.my: self.target]], forKey: Name.KeyName.uniqueNmame.rawValue)
//                obserber.onNext(true)
//            }
//            return Disposables.create()
//        }
//    }
    
    
    func setUserDefault() {
        
        if var UDData = UD.object(forKey: Name.KeyName.uniqueNmame.rawValue) as? [[String : String]] {
            
            if !UDData.contains([self.my!: self.target!]) {
                UDData += [[self.my!: self.target!]]
                UD.set(UDData, forKey: Name.KeyName.uniqueNmame.rawValue)
            }
        } else {
            UD.set([[self.my: self.target]], forKey: Name.KeyName.uniqueNmame.rawValue)
        }
    }
    
    
    
    
    
    
    
    
    
    func setFirebase() {

//        switch icon {
//        switch iconRelay.value {
//
//        case R.image.user12():
//            ref?.setValue(["message": self.message])
//
//        default:
//            setIconStorage(icon: iconRelay.value, ref: storageRef, complete: { imageURL in
//                self.ref?.setValue(["message": self.message as Any, "image": imageURL])
//            })
//        }
    }
    
    
}
 
 */
 

    

    






