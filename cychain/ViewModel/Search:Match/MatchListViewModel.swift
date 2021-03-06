import Foundation
import RxSwift
import RxCocoa

struct MatchListViewModel {
    private let model = MatchModel.shared
    private let disposeBag = DisposeBag()
}
extension MatchListViewModel: ViewModelType {
    struct Input {
        let onSelectedCell: Observable<IndexPath>
    }
    struct Output {
        let cellObj: Observable<[MultipleSectionModel]>
        let selectCellObj: Observable<Int>
    }
    
    func transform(input: Input) -> Output {
        
        var ids: [[String]] = []
        self.model.matchdata.data.forEach{ ids += [[$0.0]] }
               
        let cellObj =
            BehaviorRelay<[MultipleSectionModel]>(value:
                [MultipleSectionModel(items: ids)])
 
                
        let selectCellObj = input.onSelectedCell
            .map{ $0.row }
        
        return Output(cellObj: cellObj.asObservable(),
                      selectCellObj: selectCellObj)
    }
    
}
