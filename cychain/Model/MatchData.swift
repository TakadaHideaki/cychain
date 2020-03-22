//
//  MatchData.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/03/22.
//  Copyright © 2020 高田英明. All rights reserved.
//


class MatchData {
        var SingletonUserData: [String: [String: Any]]?
        var SingletonNames: [String]?
        static let sharedInstance = MatchData()
        private init() {}
    }
