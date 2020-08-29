import Foundation
import RxSwift
import RxCocoa

struct MultiMatchViewModel {
    private let model = multiMatchModel()
    private let disposeBag = DisposeBag()
}

extension MultiMatchViewModel: ViewModelType {
    struct Input {}
    
    struct Output {
        let cellObj: Observable<[multiMatchSectionModel]>
    }
    
    func transform(input: Input) -> Output {
          let cellObj = BehaviorRelay<[multiMatchSectionModel]>(value: [multiMatchSectionModel(sectionTitle: "PostCard",
                                                                                         items: [model.matchData!]),
                                                                       multiMatchSectionModel(sectionTitle: "Message",
                                                                                         items: [model.matchData!])
              ])
        return Output(cellObj: cellObj.asObservable())
    }

    
 
}
