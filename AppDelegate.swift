/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
   
*/

import UIKit
import Firebase

/// A standard app delegate.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Properties

    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
        -> Bool {
            FirebaseApp.configure()
            return true
    }

    
}

