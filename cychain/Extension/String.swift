//
//  String.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/04/24.
//  Copyright © 2020 高田英明. All rights reserved.
//

extension String {
     
    func deleteSpace() -> String {
        return replacingOccurrences(of: " ", with: "")
    }
}
