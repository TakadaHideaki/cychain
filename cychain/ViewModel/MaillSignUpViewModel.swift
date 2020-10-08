import Foundation
import RxSwift
import RxCocoa

struct MaillSignUpViewModel {
    private let model = AuthModel()
    private let disposeBag = DisposeBag()
}

extension MaillSignUpViewModel: ViewModelType {
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let signUpTap: Observable<Void>
        let securityButtonTapped: Observable<Void>
    }
    struct Output {
        let isValid: Driver<Bool>
        let signUpResult : Observable<Void>
        let boolToggle: Observable<Bool>
        let watingUI: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        //mail,passをcombine
        let mailAndPass = Observable
            .combineLatest(input.email,
                           input.password){($0,$1)}
        //SignUpBtnのEnabled(mail,passの文字数チェック)
        let isValid = mailAndPass
                 .map { return $0.count > 5 && $1.count > 5 }
                 .share()
                 .asDriver(onErrorDriveWith: Driver.empty())
        
        //firevaseSignUpの結果
        let signUpResult = input.signUpTap
            .withLatestFrom(mailAndPass)
            .flatMapLatest{ self.model.signUp(mail: $0, pass: $1) }
        
        //伏せ字Btn用Toggle
        let boolToggle = input.securityButtonTapped
            .scan(true) { state, _ in !state}
        
        //indicator&CoverView
        let watingUI = Observable
            .of(input.signUpTap, signUpResult)
            .merge()
            .scan(true) { state, _ in !state}
            .asDriver(onErrorDriveWith: Driver.empty())

        return Output(isValid: isValid,
                      signUpResult: signUpResult,
                      boolToggle: boolToggle,
                      watingUI: watingUI)
    }
}
