import Foundation
import RxSwift
import RxCocoa

struct SingleMatchViewModel {
    private let model = MatchModel.shared
    private let disposeBag = DisposeBag()
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
        
        let cellObj = BehaviorRelay<[MatchSectionModel]>(value: [MatchSectionModel(sectionTitle: "PostCard",
                                                                                   items: [model.singleMatch!]),
                                                                 MatchSectionModel(sectionTitle: "Message",
                                                                                   items: [model.singleMatch!])
        ])
        
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
    
    
    //        var cellObj = BehaviorRelay<[MatchSectionModel]>(value: [])
      //        cellObj.accept([MatchSectionModel(items: [model.singleMatch])])
//
//        let matchData = model.matchData
//        let userNmae = (matchData?.searchWord.userName)!
//        let searchName = (matchData?.searchWord.searchName)!
//        let matchUserID = (matchData?.data.map({$0.0})[0])!
//        let values = matchData?.data.map{$0.1}
//        var msg = ""
//        values?.forEach {
//            if let message = $0["message"] as? String {
//                msg = message
//            }
//        }
//
//        var items: Observable<[MatchSectionModel]> {
//
//       return
//                [MatchSectionModel(
//                    items: [[matchUserID:["user": userNmae,
//                                          "search": searchName,
//                                          "msg": msg]]]
//            )]
//
//
//
//
//    }
//
//    return

    


//        var report: Observable<[String:String]> { Observable<[String:String]>.create { observer in
//            let matchUser = self.model.singleMatch.map{$0}
//            matchUser?.forEach{
//                guard let user = $0.1["user"] as? String,
//                    let search = $0.1["search"] as? String,
//                    let msg = $0.1["msg"] as? String  else { return }
//                let matchData = ["user": user, "search": search, "msg": msg]
//                observer.onNext(matchData)}
//            return Disposables.create()
//            }
//        }
//
//        var blockUser: Observable<String> { Observable<String>.create { observer in
//            let matchUser = self.model.singleMatch.map{$0}
//            matchUser?.forEach{ observer.onNext($0.0)}
//            return Disposables.create()
//            }
//        }
