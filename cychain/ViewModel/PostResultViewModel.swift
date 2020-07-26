import UIKit
import RxSwift
import RxCocoa


class PostResultViewModel {
    
    
    //OutPut
//    let items = BehaviorRelay<[String]>(value: [])
    let myName: Observable<String>
    
    init(text1: String) {
        self.myName = Observable.just(text1)
//        items.accept([text1])
        
    }

}
