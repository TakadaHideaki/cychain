import Foundation
import RxSwift
import RxCocoa
import Firebase

struct SerachWord {
    let userName: String
    let searchName: String
    var isvalid: Bool {
        return ![userName, searchName].map { checkChars($0) }.contains(false)
    }
    private func checkChars(_ text: String) -> Bool {
        return text.count > 0 && text.count < 5
    }
}

    


struct SearchViewModel {
    private let userdefault = SetUserDefault()
    private let firebase = SetFirebase()
    private let disposeBag = DisposeBag()
}

extension SearchViewModel: ViewModelType {

    struct Input {
        let userName: Observable<String>
        let searchName: Observable<String>
        let searchButtonTapped: Observable<Void>
        
    }
    struct Output {
        let ButtonEnabled: Driver<Bool>
        let noMatch: Driver<Bool>
        let match: Observable<[String:[String:Any]]>
        let nextVC: Observable<Void>
        
    }
    func transform(input: Input) -> Output {

        let substitutionToText = Observable
                .combineLatest(input.userName.asObservable(),
                               input.searchName.asObservable()) { user, search  in
                                SerachWord(userName: user,
                                      searchName: search
                                )
            }
        // 文字数チェックしてButtonEnabled切り替え
        let buttonEnabled = substitutionToText.map{$0.isvalid}.asDriver(onErrorDriveWith: Driver.empty())
        //SearchButton →文字数チェック　→Fireaseで検索
        let ddd = input.searchButtonTapped
            .withLatestFrom(substitutionToText)
            .do(onNext: { self.firebase.observe(value: $0)})
            .map{_ in () }

        // ① 検索結果から、マッチ無しを抽出
        let obseved_NoMatch = firebase.data.map{ $0 != nil}
        // ② 検索結果から、マッチ有りを抽出
        let obseved_match = firebase.data.flatMap{Observable.from(optional: $0)}
        // ③ ユーザーがブロックしたIDを取得
        let blockID = self.userdefault.readBlockUaser()
        // ④ ②に③が含まれるかチェック
        let filterID = obseved_match.map { $0.filter { !blockID.contains($0.key) }}
        // ⑤ ④の結果から、マッチ無しのみを抽出
        let filter_NoMatch = filterID.map{ !$0.isEmpty }
        // ①と⑤をMerge
        let noMatch = Observable
            .of(obseved_NoMatch, filter_NoMatch)
            .merge()
            .asDriver(onErrorDriveWith: Driver.empty())
            .startWith(true)
      
        
        
        
        


        
//        var a: Observable<[String : [String : Any]]>? = filterBlockID
//            .filter{ $0.isEmpty}
    
        

        
        
    
  

    
    
//            .subscribe(onNext: { _ in
//
//            })
//            .disposed(by: disposeBag)

        

    

        return Output( ButtonEnabled: buttonEnabled,
                       noMatch: noMatch,
                       match: filterID,
                       nextVC: ddd
        )
        
    }
    
    
    
    
    
    
    
    
    
    
 
    
    
}


        


//        let noMatc = firebase.data
//            .filter{ $0 == nil}
//            .map{ _ in false }
//            .asDriver(onErrorDriveWith: Driver.empty())
//            .startWith(true)
        
