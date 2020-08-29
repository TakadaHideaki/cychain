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
        let selectVellObj: Observable<Int>
    }
    
    func transform(input: Input) -> Output {
        let cellObj = BehaviorRelay<[MultipleSectionModel]>(value: [MultipleSectionModel(
            items: model.values)])
                
        let selectCellObj = input.onSelectedCell
            .map{ $0.row }
            .debug()
        
        return Output(cellObj: cellObj.asObservable(),
                      selectVellObj: selectCellObj)
    }
    
}
