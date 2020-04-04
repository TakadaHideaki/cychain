//
//  AuthModel.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/04/04.
//  Copyright © 2020 高田英明. All rights reserved.
//

import Firebase

protocol AuthModelDelegate: class {
    func didSignUp()
}

class AuthModel {
    
    weak var delegate: AuthModelDelegate?
    
    
    func signUp(emai: String, password: String) {
        
        Auth.auth().createUser(withEmail: emai, password: password) { (authResult, error) in
            
            if (((authResult?.user) != nil) && error == nil) || Auth.auth().currentUser != nil {
                self.delegate?.didSignUp()
            }
        }
    }
    
    
}
