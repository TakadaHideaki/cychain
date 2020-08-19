import Foundation
import RxSwift
import RxCocoa



class MatchPopupViewModel {
//    private var model  = PopupModel()
    private let disposeBag = DisposeBag()
}

extension MatchPopupViewModel: ViewModelType {
    
    struct Input {
        let nextViewButtonTapped: Observable<Void>
        let dismissButtonTapped: Observable<Void>
    }
    struct Output {
        let nextVC: Observable<Void>
        let dismiss: Observable<Void>

    }
    func transform(input: Input) -> Output {
          
        return Output(nextVC: input.nextViewButtonTapped, dismiss: input.dismissButtonTapped)
    }


    
}

