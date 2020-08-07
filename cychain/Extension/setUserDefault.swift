import Foundation
import RxSwift
import RxCocoa

class setUserDefault {

    private let key = Name.KeyName.uniqueNmame.rawValue
    private let disposeBag = DisposeBag()
    
    private var resetDataRelay = BehaviorRelay<[[String:String]]>(value: [["":""]])
    var resetUdData: Observable<[[String:String]]> {
        return resetDataRelay.asObservable()
    }
    
    func setUd(data: Texts) -> Texts {
        //        let names = [data.my: data.target]
        //
        //        if var UDData = UD.object(forKey: key) as? [[String: String]] {
        //
        //            if !UDData.contains(names) {
        //                UDData += [names]
        //            }
        //            UD.set([names], forKey: key)
        //        }
        log.debug(data)
        return data
    }
    
    

    
    func read() -> [[String: String]] {
          if let postNamesList = UD.object(forKey: key) as? [[String: String]] {
              return postNamesList
          }
          return [["":""]]
      }
    
//    func reset(data: [[String: String]]) -> [[String: String]]{
//        log.debug(data)
//        return data
//    }
    func reset(data: [[String: String]]) -> [[String: String]] {
         log.debug(data)
        return data
     }
    
 
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    func save(data: Observable<Texts>) -> Observable<Texts> {
    //         data.subscribe(onNext: { value in
    //            log.debug(value.my)
    //        })
    //            .disposed(by: disposeBag)
    //        return data
    //    }
    
    
    
    
    
    
    
    
    
    
    
    //    func save2(data: Texts) {
    //        let my = data.my, target = data.target
    //        let key = Name.KeyName.uniqueNmame.rawValue
    //
    //        if var UDData = UD.object(forKey: key) as? [[String: String]] {
    //            if !UDData.contains([my: target]) {
    //                UDData += [[my: target]]
    //                UD.set(UDData, forKey: key)
    //            }
    //        } else {
    //            UD.set([[my: target]], forKey: key)
    //        }
    //        log.debug(UD.object(forKey: key))
    //        log.debug(data.my)
    //    }
    
    
}
