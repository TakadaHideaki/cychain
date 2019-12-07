//
//  AppDelegate.swift
//  abcd
//
//  Created by takadahideaki007 on 2018/12/31.
//  Copyright © 2018 高田英明. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import GoogleMobileAds
import XCGLogger

let UD = UserDefaults.standard
let USER_ID = Auth.auth().currentUser?.uid
let STORAGE = Storage.storage().reference(forURL: "gs://cychain-6d3b6.appspot.com")
let ADMB_ID = "ca-app-pub-4828313011342220/3054790632"
let ADDRESS = "cychaincontact@gmail.com"


//let log: XCGLogger? = {

let log = XCGLogger.default
//    let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)



//    let emojiLogFormatter = PrePostFixLogFormatter()
//        emojiLogFormatter.apply(prefix: "🗯🗯🗯 ", postfix: " 🗯🗯🗯", to: .verbose)
//        emojiLogFormatter.apply(prefix: "🔹🔹🔹 ", postfix: " 🔹🔹🔹", to: .debug)
//        emojiLogFormatter.apply(prefix: "ℹ️ℹ️ℹ️ ", postfix: " ℹ️ℹ️ℹ️", to: .info)
//        emojiLogFormatter.apply(prefix: "✳️✳️✳️ ", postfix: " ✳️✳️✳️", to: .notice)
//        emojiLogFormatter.apply(prefix: "⚠️⚠️⚠️ ", postfix: " ⚠️⚠️⚠️", to: .warning)
//        emojiLogFormatter.apply(prefix: "‼️‼️‼️ ", postfix: " ‼️‼️‼️", to: .error)
//        emojiLogFormatter.apply(prefix: "💣💣💣 ", postfix: " 💣💣💣", to: .severe)
//        emojiLogFormatter.apply(prefix: "🛑🛑🛑 ", postfix: " 🛑🛑🛑", to: .alert)
//        emojiLogFormatter.apply(prefix: "🚨🚨🚨 ", postfix: " 🚨🚨🚨", to: .emergency)
//        log.formatters = [emojiLogFormatter]
//    return log
//    }()





@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
//    log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: "path/to/file", fileLevel: .debug)
    
    

//    let log: XCGLogger = _xcode_workaround_log

    
    

    var window: UIWindow?
    
    
    func toSelectView() {
      self.window = UIWindow(frame: UIScreen.main.bounds)
      let storyboad = UIStoryboard(name: "Main", bundle: nil)
      let tabVC = storyboad.instantiateViewController(withIdentifier: "tabVC")
      self.window?.rootViewController = tabVC
      self.window?.makeKeyAndVisible()
      }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
//        GADMobileAds.configure(withApplicationID: "ca-app-pub-4828313011342220~4730834380")
//        GADMobileAds.start(startWithCompletionHandler: 4828313011342220~4730834380")
        GADMobileAds.sharedInstance().start()
        
        

        
        
  
        if Auth.auth().currentUser != nil {
            print("--Logged in--\(String(describing: Auth.auth().currentUser?.uid))")
            // ログイン状態ならログイン画面スルー
            toSelectView()

        } else {
            // 非ログインならログイン画面へ
            print("--Logout--")
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboad = UIStoryboard(name: "Main", bundle: nil)
            self.window?.rootViewController = storyboad.instantiateInitialViewController()
            self.window?.makeKeyAndVisible()
        }
        return true
    }
    
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url)
                                                     //sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     //annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

        Auth.auth().signIn(with: credential) { (user, error) in
            print("--Sign on Firebase successfully")

            // ログイン後遷移
            self.toSelectView()
        }
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}








