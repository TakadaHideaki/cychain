import Foundation
import RxCocoa

class MultiMatchViewModel: SingleMatchViewModel  {
    private let model = multiMatchModel.shared
    
    override var cellObj: BehaviorRelay<[MatchSectionModel]> {
        return
            BehaviorRelay<[MatchSectionModel]>(value:
                
                [MatchSectionModel(sectionTitle: "PostCard",
                                   items: [model.matchData!]),
                 
                 MatchSectionModel(sectionTitle: "Message",
                                   items: [model.matchData!])
            ])
    }
}
