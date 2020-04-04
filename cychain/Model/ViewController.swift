//
//  ViewController.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/03/31.
//  Copyright © 2020 高田英明. All rights reserved.
//

import UIKit


protocol TestDeregate: class {
    func test(String: String)
}

class ViewController1 {
    
    weak var delegate: TestDeregate?
    
    
    func test() {
        delegate?.test(String: "aaa")
    }
    
//
//    var my:String?
//
//        init(my: String){
//            self.my = my as String
//        }
//    func a() {
//        log.debug(my)
//    }
    


        
    
    



}
