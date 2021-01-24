import Foundation
import RxSwift
import RxCocoa

protocol BaseViewModel {
    var cellObj: BehaviorRelay<[MatchSectionModel]> {get}
}

class MatchViewModel: BaseViewModel  {
    
    private let model = MatchModel.shared
    let disposeBag = DisposeBag()
    
    var cellObj: BehaviorRelay<[MatchSectionModel]> {
        return
            BehaviorRelay<[MatchSectionModel]>(value:
                [MatchSectionModel(sectionTitle: model.sectionTitle[0],
                                   items: [self.model.matchData]),
                 
                 MatchSectionModel(sectionTitle: model.sectionTitle[1],
                                   items: [self.model.matchData] )])
    }
}

extension MatchViewModel: ViewModelType {
  
    struct Input {
        let naviBarButtonTaaped: Observable<Void>
        let reportTapped: Observable<Void>
        let blockTapped: Observable<Void>
    }
    
    struct Output {
        let cellObj: Observable<[MatchSectionModel]>
        let naviBarButtonEvent: Observable<Void>
        let reportObj: Observable<[String: String]>
        let blockID: Observable<Void>
        let indicator: Driver<Bool>
    }
    
     func transform(input: Input) -> Output {
        
        let indicator = cellObj
            .map{_ in false}
            .startWith(true)
            .asDriver(onErrorDriveWith: Driver.empty())

        let reportDataTapped = input.reportTapped.withLatestFrom(model.report)
        
        let blockTapped = input.blockTapped.debug()
            .withLatestFrom(model.blockID)
            .do(onNext: { self.model.registBlockID(blockID: $0) })
            .map{ _ in () }

         return Output(cellObj: cellObj.asObservable(),
                      naviBarButtonEvent: input.naviBarButtonTaaped,
                      reportObj: reportDataTapped,
                      blockID: blockTapped,
                      indicator: indicator
        )
    }
    
}
