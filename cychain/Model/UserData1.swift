//
//  UserData1.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/04/16.
//  Copyright © 2020 高田英明. All rights reserved.
//

import UIKit

class UserData1 {

    var userData: [String: Any]?

    init(useData: [String: Any]) {
        self.userData = useData
    }
}


class Singleton {
    
    var editdata = UserData1(useData: ["" : (Any).self])
    static let sharead = Singleton()
    private init() {}
    
    func setData(userData: [String: Any]) {
          editdata.userData = userData
      }
      
    func getData() -> [String: Any] {
          return editdata.userData!
      }
}
