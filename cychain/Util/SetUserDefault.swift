import Foundation
import RxSwift
import RxCocoa

class SetUserDefault {
    private let key = Name.KeyName.uniqueNmame.rawValue
    private let BlockKey = Name.KeyName.block.rawValue
    private let disposeBag = DisposeBag()
    lazy var postListCellObj = UD.rx.observe([[String: String]].self, self.key)
    
    func setUd(data: PostDatas)  {
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
        return  UD.array(forKey: key) as? [[String: String]] ?? []
    }
    
    func readBlockUaser() -> [String] {
        return UD.object(forKey: BlockKey) as? [String] ?? []
        
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
