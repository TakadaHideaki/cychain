import Foundation
import RxDataSources



struct PostListSectionModel {
    var items: [Item]
}

extension PostListSectionModel: SectionModelType {
    typealias Item = [String: String]
    
    init(original: PostListSectionModel, items: [Item] ) {
        self = original
        self.items = items
    }
}
