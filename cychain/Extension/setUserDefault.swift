import Foundation
import RxSwift
import RxCocoa

class setUserDefault {
    
    private let disposeBag = DisposeBag()
    
    func save(data: Texts) {
        //        let names = [data.my: data.target]
        //        let key = Name.KeyName.uniqueNmame.rawValue
        //
        //        if var UDData = UD.object(forKey: key) as? [[String: String]] {
        //
        //            if !UDData.contains(names) {
        //                UDData += [names]
        //            }
        //            UD.set([names], forKey: key)
        //        }
        log.debug(data.my)
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
