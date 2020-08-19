import Foundation
import RxSwift
import RxCocoa

struct MatchData {
    let searchWord: SearchWord
    let data: [String:[String:Any]]
}

struct SearchWord {
    let userName: String
    let searchName: String
    var isvalid: Bool {
        return ![userName, searchName].map { checkChars($0) }.contains(false)
    }
    private func checkChars(_ text: String) -> Bool {
        return text.count > 0 && text.count < 10
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
        let match: Observable<MatchData>
        let searchStart: Driver<Bool>
        let hidden: Driver<Bool>
        let stopIndicator: Driver<Bool>
        
    }
    func transform(input: Input) -> Output {

        let substitutionToText = Observable
                .combineLatest(input.userName.asObservable(),
                               input.searchName.asObservable()) { user, search  in
                                SearchWord(userName: user,
                                      searchName: search
                                )
            }
        // 文字数チェックしてButtonEnabled切り替え
        let buttonEnabled = substitutionToText.map{$0.isvalid}.asDriver(onErrorDriveWith: Driver.empty())
        //SearchButton →文字数チェック　→Fireaseで検索
        let searchStart = input.searchButtonTapped
            .withLatestFrom(substitutionToText)
            .do(onNext: { self.firebase.observe(value: $0)})
            .map{_ in true }
            .startWith(false)
            .asDriver(onErrorDriveWith: Driver.empty())

        // ① 検索結果、マッチ無し
        let obseved_NoMatch = firebase.data.map{ $0 != nil}.filter{ $0 == false }
        // ② 検索結果、マッチ有り
        let obseved_match = firebase.data.flatMap{Observable.from(optional: $0)}
        // ③ ユーザーがブロックしたIDを取得
        let blockID = self.userdefault.readBlockUaser()
        // ④ ②に③が含まれるかチェック
        let filter_BlockID = obseved_match.map { $0.filter { !blockID.contains($0.key) }}
        // ⑤ ④の結果から、マッチ無しのみを抽出
        let noData = filter_BlockID.map{ !$0.isEmpty }.filter{ $0 == false }
        // ①と⑤をMerge
        let noMatch = Observable
            .of(obseved_NoMatch, noData)
            .merge()
            .asDriver(onErrorDriveWith: Driver.empty())
            .startWith(true)
        
        let match = Observable
            .combineLatest(
                substitutionToText,
                filter_BlockID.skip(1).filter{ !$0.isEmpty }) { searchWord, value in
                    MatchData(searchWord: searchWord,
                               data: value)
        }
        
        let hidden = match
        .map{_ in true }
        .startWith(true)
        .asDriver(onErrorDriveWith: Driver.empty())
        
        let stopindicator = match
        .map{_ in false }
        .startWith(false)
        .asDriver(onErrorDriveWith: Driver.empty())
   
                                        

        return Output( ButtonEnabled: buttonEnabled,
                       noMatch: noMatch,
                       match: match,
                       searchStart: searchStart,
                       hidden: hidden,
                       stopIndicator: stopindicator
        )
        
    }
    
    
    
    
    
    
    
    
    
    
 
    
    
}


        


//        let noMatc = firebase.data
//            .filter{ $0 == nil}
//            .map{ _ in false }
//            .asDriver(onErrorDriveWith: Driver.empty())
//            .startWith(true)
        
