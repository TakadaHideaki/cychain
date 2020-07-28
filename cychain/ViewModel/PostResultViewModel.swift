import Foundation
import RxSwift
import RxCocoa


protocol PostResultViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

struct PostResultViewModel {

}

extension PostResultViewModel: PostResultViewModelType {
    
    struct Input {
        let postData: Observable<Any>
    }
    struct Output {
        let cellData: Observable<Any>
    }
    func transform(input: Input) -> Output {
        return Output(cellData: input.postData)
    }
    
    
}

    




//    var eventSubject1: Observable<Any>
//    init (data: Texts) {
//        self.eventSubject1 = Observable.just(data)
//    }

    
    
    
    
    
    
    
    
    
    
    
    
//    func selectAtIndex(index: Int) {
//        log.debug(friends.value[index])
//    }
//
//    func add() {
//        friends.accept(["10"])
//
//    }
    

