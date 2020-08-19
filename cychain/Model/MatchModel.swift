import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct MatchModel {
    let userNmae: String
    let searchName: String
    let matchUserID: [String]
    let values: [[String: Any]]

    
     init(data: MatchData) {
        self.userNmae = data.searchWord.userName
        self.searchName = data.searchWord.searchName
        self.matchUserID = data.data.map{$0.key}
        self.values = data.data.map{$0.1}
//        values.forEach {
//            if let mess = $0["message"] as? String {
//                self.message = mess
//            }
//        }
            
            
            
        }
    }
    
    



struct MatchSectionModel {
    var matchNames: [String: String]
    var items: [Item]
}

extension MatchSectionModel: SectionModelType {
    
    typealias Item = [String:[String: String]]
    
    init(original: MatchSectionModel, items: [Item] ) {
        self = original
        self.items = items
    }
}

