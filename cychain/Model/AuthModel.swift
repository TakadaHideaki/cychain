//
//  AuthModel.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/04/04.
//  Copyright © 2020 高田英明. All rights reserved.
//

import Firebase

protocol AuthModelDelegate: class {
    func toHome()
    func signUperrorDidOccur(error: Error)
    func logInerrorDidOccur(error: Error)
    func passwordErrorAlert()
    func passwordResetSuccessAlert()
}

class AuthModel {
    
    weak var delegate: AuthModelDelegate?
        
    func signUp(emai: String, password: String) {

        Auth.auth().createUser(withEmail: emai, password: password) { (authResult, error) in

            if (((authResult?.user) != nil) && error == nil) || Auth.auth().currentUser != nil {
                self.delegate?.toHome()
            } else {
                if let e = error {
                    self.delegate?.signUperrorDidOccur(error: e)
                }
            }
        }
    }
    
    func LogIn(mail: String, pass: String) {
        log.debug(mail)
        
        Auth.auth().signIn(withEmail: mail, password: pass) { (authResult, error) in
            
            if (((authResult?.user) != nil) && error == nil) {
                self.delegate?.toHome()
                log.debug("login sacsess")
                
            } else {
                if let e = error {
                    self.delegate?.logInerrorDidOccur(error: e)
                    log.debug("login error")
                }
            }
        }
    }
    
    func passwordReset(email: String) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            DispatchQueue.main.async {
                if error != nil {
                    self.delegate?.passwordErrorAlert()
                } else {
                    self.delegate?.passwordResetSuccessAlert()
                }
            }
        }
    }
    
}



