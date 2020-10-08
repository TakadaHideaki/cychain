import Foundation
import RxSwift
import RxCocoa
import Firebase

struct EditModel {
    static let shared = EditModel()
    private init() {}
    
    let dataRelay = PublishRelay<PostDatas>()
    var data: Observable<PostDatas> { return dataRelay.asObservable() }
    
    let noDetaRelay = PublishRelay<(m:String, t:String)>()
    var noData: Observable<(m:String, t:String)> { return noDetaRelay.asObservable() }
    
    func observe(value: [String: String]) {
        let my = value.map{$0.key}[0]
        let target = value.map{$0.value}[0]
        let dafaultImg = R.image.user12()!
        let ref: DatabaseReference =
            Database.database().reference().child("\(my)/\(target)/\(USER_ID!)")
        
        var editData = PostDatas(my: my,
                             target: target,
                             message: "",
                             iconImage: dafaultImg)
        
        ref.observeSingleEvent(of: .value, with: { dataSnapshot in
            if dataSnapshot.value is NSNull {
                //                self.dataRelay.accept(nil)
                self.noDetaRelay.accept((m:my, t:target))
            } else {
                let data = dataSnapshot.value as? [String : Any]
                editData.message = data?["message"] as? String ?? ""
                
                if let stringImg = data?["image"] as? String {
                    self.convertURLtoUIImage(stringImg: stringImg, { complete in
                        editData.iconImage = complete
                        self.dataRelay.accept(editData)
                        log.debug(complete)
                    })
                } else {
                    self.dataRelay.accept(editData)
                }
                
            }
        })
        //        self.f.accept(["TestIDA":["message": "TestMessage"]])
    }
    
    func convertURLtoUIImage(stringImg: String,  _ complete: @escaping (UIImage) -> ())  {
        log.debug("convertURLtoUIImage")
        let url = URL(string: stringImg)
        DispatchQueue.global().async {
            do {
                let imageData = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    complete(UIImage(data:imageData as Data)!)
                    log.debug(UIImage(data:imageData as Data)!)
                }
            } catch {
                return
            }
        }
    }
    
    func deletePostData(data: (m:String, t:String)) {
        let key = Name.KeyName.uniqueNmame.rawValue
        let errorData = [data.m: data.t]
        let UDData = UD.array(forKey: key) as? [[String: String]] ?? []
        let correctData = UDData.filter{ $0 != errorData }
        UD.set(correctData, forKey: key)
    }
}
