//
//  PostResultViewModel.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/06/30.
//  Copyright © 2020 高田英明. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class PostResultViewModel {
    
    
    //OutPut
//    let items = BehaviorRelay<[String]>(value: [])
    let myName: Observable<String>
    
    init(text1: String) {
        self.myName = Observable.just(text1)
//        items.accept([text1])
        
    }

}
