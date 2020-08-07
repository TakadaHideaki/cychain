import Foundation
import RxSwift

struct ReadUserDefault {
    
//    let postDataList: Observable<[[String: String]]?> = Observable.just(UD.object(forKey: Name.KeyName.uniqueNmame.rawValue) as? [[String: String]])
//}
    
//    let postDataList = UD.object(forKey: Name.KeyName.uniqueNmame.rawValue) as? [[String: String]]
    
    
    
    func a() -> [[String: String]] {
        if let r = UD.object(forKey: Name.KeyName.uniqueNmame.rawValue) as? [[String: String]] {
            return r
        }
        return [["":""]]
    }
    


    
    
    
}

