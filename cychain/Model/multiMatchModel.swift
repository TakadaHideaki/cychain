import Foundation
import RxSwift
import RxDataSources

class multiMatchModel {
    
    static let shared = multiMatchModel()
    private init() {}
    
    private let model = MatchModel.shared
    var selectIndexPathRow: Int?
    var matchData: [String: [String: Any]]?
    var reportData: [String: String]?
    var blockID: Observable<String>?

     func setData(selectIndexPathRow: Int) {
        let user = model.reportData?["user"] ?? ""
        let search = model.reportData?["search"] ?? ""
        let id = model.iDAray[selectIndexPathRow]
        let msg = model.values[selectIndexPathRow]["msg"] as? String ?? ""
        let icon = model.values[selectIndexPathRow]["image"] ?? R.image.user12()!
        
        self.matchData = [id: ["user": user, "search": search, "msg": msg, "image": icon]]
        self.reportData = ["user": user, "search": search, "msg": msg]
        self.blockID = Observable.just(id)
    }
}

struct multiMatchSectionModel {
    var sectionTitle: String
    var items: [Item]
}

extension multiMatchSectionModel: SectionModelType {
    
    typealias Item = [String:[String: Any]]
    
    init(original: multiMatchSectionModel, items: [Item] ) {
        self = original
        self.items = items
    }
}


