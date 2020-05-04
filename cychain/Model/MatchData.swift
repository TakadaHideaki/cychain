//
//  MatchData.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/03/22.
//  Copyright © 2020 高田英明. All rights reserved.
//
import UIKit

class MatchData {
    
    static let shared = MatchData()
    private init() {}
    
    //    var SingletonUserData: [String: [String: Any]]? //[[UID: [message:メッセージ、image:写真]]
    //    var SingletonNames: [String]? // [myName, searchName]
    var names: [String]?
    var muchData: [String: [String: Any]]?
    var matchuserID: String?
    var message: String?
    var icon = UIImage(named: Name.ImageName.defaultIcon.rawValue)
    var URLImage: String?
    var indexPath: Int?
    
    
    func matchDataSet(matchData: [String: [String: Any]], names: [String]) {
        
        self.names = names
        self.muchData = matchData
        self.matchuserID = matchData.map{$0.0}[0]
        
        //message_image == ["message": Stirng, "image": String]
        let message_image: [String: Any] = matchData.map{$0.1}[0]
        //メッセージがあればmessageに代入
        if message_image["message"] != nil {
            self.message = message_image["message"] as? String
        }
        //アイコン登録があればiconに代入　なければデフォルトアイコンを表示
        guard let iconImage: String = message_image["image"] as? String else { return }
        self.URLImage = iconImage
    }
    
    
    
    func convertURLtoImage(URLImage: String, _ complete: @escaping (UIImage) -> ()) {
        
        let url = URL(string: URLImage)
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
 
    
    func blockUserRegistration(blockID: String) {
        //ブロックり履歴有り
        if var blocksUserID = UD.array(forKey: Name.KeyName.block.rawValue) {
            blocksUserID += [blockID]
            UD.set(blocksUserID, forKey: Name.KeyName.block.rawValue)
            
        } else {
            //初ブロック
            UD.set([blockID], forKey: Name.KeyName.block.rawValue)
        }
    }
    
    
}

