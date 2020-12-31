import Foundation
import RxSwift

enum Terms_Policy {
    case term, policy
    
    var sentence: String {
        let model = InitialModel()
        switch self {
        case .term:
            return model.sentence(fileName: "Term")
        case .policy:
            return model.sentence(fileName: "policy")
        }
    }
    var title: String {
        switch self {
        case .term:
            return "利用規約"
        case .policy:
            return "プライバシーポリシー"
        }
    }
}

struct InitialViewModel {
    private let model = InitialModel()
    private let disposeBag = DisposeBag()
}

extension InitialViewModel: ViewModelType {
    struct Input {
        let termsTap: Observable<Void>
        let policyTap: Observable<Void>
    }
    struct Output {
        let termsTapEvent: Observable<Terms_Policy>
        let policyTapEvent: Observable<Terms_Policy>
    }
    
    func transform(input: Input) -> Output {
        
        //利用規約タップ
        let termSentens = input.termsTap
            .map { return Terms_Policy.term }
        //ポリシータップ
        let policySentens = input.policyTap
            .map { return Terms_Policy.policy  }
        
        return
            Output(termsTapEvent: termSentens,
                   policyTapEvent: policySentens)
    }
        
}
