import Foundation
import FirebaseAuth
import RxSwift
import GoogleSignIn

struct AuthModel {
    
    func signUp(mail: String, pass: String) -> Observable<Void> {
        return
            Observable<Void>.create { Observer in
                Auth.auth().createUser(withEmail: mail, password: pass) { result, error in
                    
                    if result?.user != nil && error == nil || Auth.auth().currentUser != nil {
                        Observer.onNext(())
                    } else {
                        if let error = error {
                            Observer.onError(error)
                        }
                    }
                }
                return Disposables.create()
        }
    }
    
    func logIn(mail: String, pass: String) -> Observable<Void> {
        return
            Observable<Void>.create { Observer in
                Auth.auth().signIn(withEmail: mail, password: pass) { result, error in
                    
                    if result?.user != nil && error == nil {
                        Observer.onNext(())
                    } else {
                        if let error = error {
                            Observer.onError(error)
                        }
                    }
                }
                return Disposables.create()
        }
    }
    
    func passwordReset(email: String) -> Observable<Void> {
        return
            Observable<Void>.create { Observer in
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    DispatchQueue.main.async {
                        if error != nil {
                            Observer.onError(error!)
                        } else {
                            Observer.onNext(())
                        }
                    }
                }
                return Disposables.create()
        }
    }
    
    func googleSignUP() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func firebaseSignIn(credential: AuthCredential) {
          // Firebaseにログインする。
          log.debug("firebaseSignIn")
          Auth.auth().signIn(with: credential) { (user, error) in
              if error != nil { return }
          }
      }
    
     func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                        withError error: NSError!) {
        //失敗時
        return
    }
}
