import Foundation
import RxSwift

struct SignUpSelectViewModel  {
    private var model = AuthModel()
    private let disposeBag = DisposeBag()

}
extension SignUpSelectViewModel: ViewModelType {
    struct Input {
        let mailTap: Observable<Void>
        let googleTap: Observable<Void>
    }
    struct Output {
        let mailTapEvent: Observable<Void>
        let googleTapEvent: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let signup = input.googleTap
            .do(onNext: { self.model.googleSignUP()})
        
        return Output(mailTapEvent: input.mailTap,
                      googleTapEvent: signup)
    }
        
}
