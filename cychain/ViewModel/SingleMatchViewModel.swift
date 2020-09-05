import Foundation
import RxSwift
import RxCocoa

protocol BaseViewModel {
    var cellObj: BehaviorRelay<[MatchSectionModel]> {get}
}

class SingleMatchViewModel: BaseViewModel  {
    
    var cellObj: BehaviorRelay<[MatchSectionModel]> {
           return
            BehaviorRelay<[MatchSectionModel]>(value:
                [MatchSectionModel(sectionTitle: model.sectionTitle[0],
                                         items: [model.singleMatch!]),

                       MatchSectionModel(sectionTitle: model.sectionTitle[1],
                                         items: [model.singleMatch!]
                   )
               ]
           )
       }
    
    private let model = MatchModel.shared
    let disposeBag = DisposeBag()
}

extension SingleMatchViewModel: ViewModelType {
  
    struct Input {
        let naviBarButtonTaaped: Observable<Void>
        let reportTapped: Observable<Void>
        let blockTapped: Observable<Void>
    }
    
    struct Output {
        let cellObj: Observable<[MatchSectionModel]>
        let naviBarButtonEvent: Observable<Void>
        let reportObj: Observable<[String: String]>
        let blockID: Observable<String>
        let indicator: Driver<Bool>
    }
    
     func transform(input: Input) -> Output {
        
        let indicator = cellObj
            .map{_ in false}
            .startWith(true)
            .asDriver(onErrorDriveWith: Driver.empty())

        
        let report = Observable.from(optional: model.reportData)
        let reportDataTapped = input.reportTapped.withLatestFrom(report)
        
        let blockTapped = input.blockTapped
            .skip(1)
            .withLatestFrom(model.blockID!)

//            .do(onNext: { self.model.registBlockID(blockID: $0)})

        
        return Output(cellObj: cellObj.asObservable(),
                      naviBarButtonEvent: input.naviBarButtonTaaped,
                      reportObj: reportDataTapped,
                      blockID: blockTapped,
                      indicator: indicator
        )
    }
    
}
