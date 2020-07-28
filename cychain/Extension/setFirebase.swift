import Foundation
import Firebase

class setFirebase {
    
    func setFirebae(data: Texts) {
        
//        let ref: DatabaseReference = Database.database().reference().child("\(data.my)/\(data.target)/\(USER_ID!)")
//
//        let storageRef: StorageReference = STORAGE.child("\(data.my)/\(data.target)/\(USER_ID!)/\("imageData")")
//
//        let icon = data.iconImage
//
//        switch icon {
//        case R.image.user10():
//            ref.setValue(["message": data.message])
//
//        default:
//            setIconStorage(icon: icon, ref: storageRef, complete: { imageURL in
//                ref.setValue(["message": data.message as Any, "image": imageURL])
//            })
//        }
        
        log.debug(data.iconImage)
        
        
        
    }

}
