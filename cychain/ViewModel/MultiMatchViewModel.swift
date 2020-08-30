import Foundation
import RxSwift
import RxCocoa

struct MultiMatchViewModel {
    private let model = multiMatchModel.shared
    private let disposeBag = DisposeBag()
}

extension MultiMatchViewModel: ViewModelType {
     struct Input {
          let naviBarButtonTaaped: Observable<Void>
          let reportTapped: Observable<Void>
          let blockTapped: Observable<Void>
      }
    
    struct Output {
        let cellObj: Observable<[multiMatchSectionModel]>
        let naviBarButtonEvent: Observable<Void>
        let reportObj: Observable<[String: String]>
        let blockID: Observable<String>
        let indicator: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
          let cellObj = BehaviorRelay<[multiMatchSectionModel]>(value: [multiMatchSectionModel(sectionTitle: "PostCard",
                                                                                         items: [model.matchData!]),
                                                                       multiMatchSectionModel(sectionTitle: "Message",
                                                                                         items: [model.matchData!])
              ])
        
        //control_indicator
        let indicator = cellObj
            .map{_ in false}
            .startWith(true)
            .asDriver(onErrorDriveWith: Driver.empty())
        
        //Unwrap & DeleteNil( model.reportData)
        let report = Observable.from(optional: model.reportData)
        
        let reportDataTapped = input.reportTapped
            .withLatestFrom(report)
        
        let blockTapped = input.blockTapped
            .skip(1)
            .withLatestFrom(model.blockID!)
        
        return Output(cellObj: cellObj.asObservable(),
                      naviBarButtonEvent: input.naviBarButtonTaaped,
                      reportObj: reportDataTapped,
                      blockID: blockTapped,
                      indicator: indicator
        )
    }

    
 
}
