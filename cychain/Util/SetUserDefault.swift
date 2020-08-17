import Foundation
import RxSwift
import RxCocoa

class SetUserDefault {

    private let key = Name.KeyName.uniqueNmame.rawValue
    private let disposeBag = DisposeBag()
//    private var resetDataRelay = BehaviorRelay<[[String:String]]>(value: [["":""]])
//    var resetUdData: Observable<[[String:String]]> {
//        return resetDataRelay.asObservable()
//    }
    
  /*  func setUd(data: Texts) -> Observable<Texts> {
        return Observable.create { [unowned self] observer in
            let names = [data.my: data.target]
            
            UD.rx.observe([[String: String]].self, self.key)
                .subscribe(onNext: {
                    if var value = $0 {
                        if !value.contains(names) {
                            value += [names]
                            UD.set(value, forKey: self.key)
                            log.debug("追加登録")
                        }
                        log.debug("重複")
                    } else {
                        UD.set([names], forKey: self.key)
                        log.debug("新規登録")
                    }
                })
                .disposed(by: self.disposeBag)
            observer.onNext(data)
            return Disposables.create()
        }
    }*/
//        func setUd(data: Texts)  {
//            guard let ud = UD.array(forKey: key) as? [[String:String]] else { return }
//            var names = [[data.my: data.target]]
//            if !ud.contains(names[0]) {
//                ud.forEach { _ in names += [ud[0]]
//                }
//            } else { return }
//            UD.set([names], forKey: self.key)
//            UD.accessibilityElementCount()
//        }
    
    
/*    func setUd(data: Texts)  {
    guard let ud = UD.array(forKey: key) as? [[String:String]] else { return }
    
    var names = [[data.my: data.target]]
    if !ud.contains(names[0]) {
        ud.forEach { _ in names += [ud[0]]
        }
    } else { return }
    //        UD.set([names], forKey: self.key)
}*/
    
    func setUd(data: Texts)  {
        let names = [data.my: data.target]
        if var value = UD.array(forKey: self.key) as? [[String: String]] {
            
            if !value.contains(names) {
                value += [names]
                UD.set(value, forKey: self.key)
            }
        } else {
            UD.set([names], forKey: self.key)
        }
    }
    

    
    func read() -> [[String: String]] {
          if let value = UD.array(forKey: key) as? [[String: String]] {
              return value
          }
          return []
      }
    
    func readBlockUaser() -> [String] {
        if let value = UD.object(forKey: Name.KeyName.block.rawValue) as? [String] {
                return value
            }
            return []
        }
    
  func reset(indexPath: IndexPath) -> Observable<[String: String]> {
        return Observable.create { [unowned self] observer in
            var value = self.read()
            let deletePairNames = value[indexPath.row]
            value.remove(at: indexPath.row)
            UD.set(value, forKey: self.key)
            observer.onNext(deletePairNames)
            return Disposables.create()
        }
    }
    
}


      /*  func setUd(data: Texts)  {
              
              guard let ud = UD.array(forKey: key) as? [[String:String]] else { return }
              
              var names = [[data.my: data.target]]
              if !ud.contains(names[0]) {
                  ud.forEach { _ in names += [ud[0]]
                      log.debug("追加登録")
                      log.debug(names)
                  }
              } else {
                  log.debug("重複")
              }
      //        UD.set([names], forKey: self.key)
              log.debug("新規登録")
              log.debug(names)
              log.debug(UD.array(forKey: self.key))

          }
         */
     

//    func readUserdefault(indexPath: IndexPath) -> Observable<[String: String]> {
//      return Observable.create { [unowned self] observer in
//          var ud = [String:String]()
//          UD.rx.observe([[String:String]].self, self.key)
//              .subscribe(onNext: {
//                  if let value = $0 {
//                    ud = value[indexPath.row]
//                  }
//              })
//              .disposed(by: self.disposeBag)
//          observer.onNext(ud)
//          return Disposables.create()
//      }
//  }
