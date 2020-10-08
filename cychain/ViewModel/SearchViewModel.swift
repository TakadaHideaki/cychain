import Foundation
import RxSwift
import RxCocoa

struct MatchData {
    let searchWord: SearchWord
    let data: [String:[String:Any]]
    private let disposeBag = DisposeBag()
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
        let btnEnabled: Driver<Bool>
        let noMatch: Driver<Bool>
        let match: Observable<MatchData>
        let contolIndicator: Driver<Bool>
        let matchUI: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        //userName & SearchNameを、SearchWordにSet
        let substitutionToText = Observable
                .combineLatest(input.userName.asObservable(),
                               input.searchName.asObservable()) { user, search  in
                                SearchWord(userName: user,
                                      searchName: search
                                )
            }
        // 文字数チェックしてButtonEnabled切り替え
        let btnEnabled = substitutionToText.map{$0.isvalid}.asDriver(onErrorDriveWith: Driver.empty())
        //SearchButton →文字数チェック　→Fireaseで検索
        let searchStart = input.searchButtonTapped
            .withLatestFrom(substitutionToText)
            .do(onNext: { self.firebase.observe(value: $0)})
            .map{_ in true }
            .startWith(false)

        // ① 検索結果、N/A
        let obseved_NoMatch = firebase.serchResultdata.filter{$0 == nil}.map{ _ in false }
        // ③ Block登録してあるIDを取得
        let blockID = self.userdefault.readBlockUaser()
        // ④ マッチ結果からブロックIDを排除
        let obseved_Match = firebase.serchResultdata
            .compactMap{$0}
            .map{ $0.filter{ a in !blockID.contains(a.key)}}
        // ⑤ ④の結果マッチデータが１つもなくなったケースのみを抽出(⑥にfalseを送る為↓の記述)
        let noData = obseved_Match.map{ !$0.isEmpty }.filter{ $0 == false }
        // ⑥ ① & ⑤ Merge
        let noMatch = Observable
            .of(obseved_NoMatch, noData)
            .merge()
            .asDriver(onErrorDriveWith: Driver.empty())
        //　⑦ MatchしたらMatchDataにマッチデータをセット
        let match = Observable
            .combineLatest(
                substitutionToText,
                obseved_Match.filter{ !$0.isEmpty }) { searchWord, value in
                    MatchData(searchWord: searchWord, data: value)
        }
        // ⑧ machした時のUI表示/非表示切り替え(マッチしたらtrue)
        let machUI = match
        .map{_ in true }
        .startWith(true)
        .asDriver(onErrorDriveWith: Driver.empty())

        // ⑩ ①と⑨をmeage
        let indicator = Observable
            .of(searchStart,
                obseved_NoMatch,
                obseved_Match.map{ _ in false })
            .merge()
            .asDriver(onErrorDriveWith: Driver.empty())
        
        return Output( btnEnabled: btnEnabled,
                       noMatch: noMatch,
                       match: match,
                       contolIndicator: indicator,
                       matchUI: machUI
        )
        
    }
    
    
    
 
    
    
    
}
