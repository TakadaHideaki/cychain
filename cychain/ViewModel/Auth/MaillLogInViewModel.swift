import Foundation
import RxSwift
import RxCocoa

struct MaillLogInViewModel {
    private let model = AuthModel()
    private let disposeBag = DisposeBag()
}

extension MaillLogInViewModel: ViewModelType {
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let logInTap: Observable<Void>
        let securityButtonTapped: Observable<Void>
        let pasdswordResetTap: Observable<Void>
    }
    struct Output {
        let isValid: Driver<Bool>
        let logInResult : Observable<Void>
        let boolToggle: Observable<Bool>
        let passwordReset: Observable<Void>
        let insufficientMaill: Observable<Void>
        let resetMailAdress: Observable<Void>
        let watingUI: Driver<Bool>
    }
    func transform(input: Input) -> Output {
        //mail,passをcombine
        let mailAndPass = Observable
                       .combineLatest(input.email,
                                      input.password){($0,$1)}
        //loginBtnのEnabled(mail,passの文字数チェック)
        let isValid = mailAndPass
                  .map { return $0.count > 5 && $1.count > 5 }
                  .share()
                  .asDriver(onErrorDriveWith: Driver.empty())

        let logInResult = input.logInTap
            .withLatestFrom(mailAndPass)
            .flatMapLatest{ self.model.logIn(mail: $0, pass: $1) }
        
        //password(伏字/平字)
        let boolToggle = input.securityButtonTapped
            .scan(true) { state, _ in !state}
        
        //indicator&CoverView
        let watingUI = Observable
            .of(input.logInTap, logInResult)
            .merge()
            .scan(false) { state, _ in !state}
            .asDriver(onErrorDriveWith: Driver.empty())
        
        //mailAdress忘れ
        let mail = input.pasdswordResetTap
            .withLatestFrom(input.email)
        
        //MaillAddressの文字数不足
        let insufficientMaill = mail
            .map{$0.count <= 7 }
            .filter{ $0 }
            .map { _ in () }
        
        //Result_MaillAddressReset
        let resetMaillAdress = mail
            .filter { $0.count > 7 }
            .flatMap{ self.model.passwordReset(email: $0) }

        return Output(isValid: isValid,
                      logInResult: logInResult,
                      boolToggle: boolToggle,
                      passwordReset: input.pasdswordResetTap,
                      insufficientMaill: insufficientMaill,
                      resetMailAdress: resetMaillAdress,
                      watingUI: watingUI
        )
    }
}




