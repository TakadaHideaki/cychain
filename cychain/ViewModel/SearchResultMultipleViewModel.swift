import Foundation
import RxSwift
import RxCocoa

struct SearchResultMultipleViewModel {
    private let model = MatchModel.shared
    private let disposeBag = DisposeBag()
}
extension SearchResultMultipleViewModel: ViewModelType {
    struct Input {
        let onSelectedCell: Observable<IndexPath>
    }
    struct Output {
        let cellObj: Observable<[MultipleSectionModel]>
        let selectCellObj: Observable<Int>
    }
    
    func transform(input: Input) -> Output {
        let cellObj = BehaviorRelay<[MultipleSectionModel]>(value: [MultipleSectionModel(
            items: model.values)])
                
        let selectCellObj = input.onSelectedCell
            .map{ $0.row }
        
        return Output(cellObj: cellObj.asObservable(),
                      selectCellObj: selectCellObj)
    }
    
}
