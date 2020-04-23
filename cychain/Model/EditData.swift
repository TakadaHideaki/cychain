//
//  EditData.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/03/14.
//  Copyright © 2020 高田英明. All rights reserved.
//


class EditData {
    var SingletonUserData: [String: Any]?
    static let sharedInstance = EditData()
    private init() {}
}



