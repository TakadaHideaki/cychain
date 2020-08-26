import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class MatchModel {
    
    static let shared = MatchModel()
    private init() {}
    
    var singleMatch: [String: [String: Any]]?
    var reportData: Observable<[String: String]>?
    var blockID: Observable<String>?
    
    
    func setData(data: MatchData) {
        
        let user = data.searchWord.userName
        let search = data.searchWord.searchName
        let id = data.data.map{$0.0}[0]
        let msg = data.data.map{$0.1}[0]["message"]as? String ?? ""
        let icon = R.image.user12()!
        
        if let stringImage = data.data.map({$0.1})[0]["image"] as? String {
            log.debug(stringImage)
            convertURLtoUIImage(stringImage: stringImage, { complete in
                self.singleMatch = [id:["user": user, "search": search, "msg": msg, "image": complete]]
            })
        } else {
            self.singleMatch = [id:["user": user, "search": search, "msg": msg, "image": icon]]
        }
        
//        self.singleMatch = [id:["user": user, "search": search, "msg": msg, "image": icon]]
        self.reportData = Observable.just(["user": user, "search": search, "msg": msg])
        self.blockID = Observable.just(id)
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
    
    typealias Item = [String:[String: Any]]
    
    init(original: MatchSectionModel, items: [Item] ) {
        self = original
        self.items = items
    }
}

