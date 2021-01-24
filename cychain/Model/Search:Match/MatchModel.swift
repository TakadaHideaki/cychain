import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class MatchModel {
    
    static let shared = MatchModel()
    private init() {}
    
    var matchdata = MatchData(searchWord: SearchWord(userName: "", searchName: ""), data: ["" : ["" : ""]])
    var matchData = [String: [String: Any]]()
    var reportRelay = PublishRelay<[String: String]>()
    var report: Observable<[String: String]> { return reportRelay.asObservable() }
    let blockRelay = BehaviorRelay<String>(value: "")
    var blockID: Observable<String> { return blockRelay.asObservable() }
    let sectionTitle = ["PostCard", "Message"]
   
    
    func setData(data: MatchData, row: Int = 0) {
        
        let user = data.searchWord.userName
        let search = data.searchWord.searchName
        let id = data.data.map{$0.0}[row]
        let msg = data.data.map{$0.1}[row]["message"]as? String ?? ""
        
        if let stringImage = data.data.map({$0.1})[row]["image"] as? String {
            
            convertURLtoUIImage(stringImage: stringImage, { complete in
                self.matchData = [id: ["user": user,
                                         "search": search,
                                         "msg": msg,
                                         "image": complete]] })
        } else {
            self.matchData = [id: ["user": user,
                                     "search": search,
                                     "msg": msg,
                                     "image": R.image.user12()!]]
        }
        self.reportRelay.accept(["user": user, "search": search, "msg": msg])
        self.blockRelay.accept(id)
        
    }
    
    func convertURLtoUIImage(stringImage: String, _ complete: @escaping (UIImage) -> ()) {

        let url = URL(string: stringImage) //let url = urlString.flatMap(URL.init)でも可
        DispatchQueue.global().async {
            do {
                let imageData = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    complete(UIImage(data:imageData as Data)!)
                }
            } catch {
                return
            }
        }
    }
    
    
    func registBlockID(blockID: String) {
        var block = UD.array(forKey: Name.KeyName.block.rawValue) ?? []
        block += [blockID]
        UD.set(block, forKey: Name.KeyName.block.rawValue)
    }
}

struct MatchSectionModel {
    var sectionTitle: String
    var items: [Item]
}

extension MatchSectionModel: SectionModelType {
    
    typealias Item = [String: [String: Any]]
    
    init(original: MatchSectionModel, items: [Item] ) {
        self = original
        self.items = items
    }
}

