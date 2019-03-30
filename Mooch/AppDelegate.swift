////
//  AppDelegate.swift
//  MoochApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import LDLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    // MARK: - Properties
    var window: UIWindow?
    var mainCoordinator: MainCoordinator?
    
    // MARK: - Developer
    var devMode = false
    var shouldStartOnTabbar = false

    // MARK: - Application
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        if devMode {
            print(devModeText)
            try! Auth.auth().signOut()
        }
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        let nav = UINavigationController()
        nav.navigationBar.barTintColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
        nav.navigationBar.tintColor = .white
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        mainCoordinator = MainCoordinator(nav: nav)
        
        if shouldStartOnTabbar {
            mainCoordinator?.mainApp()
        } else {
            mainCoordinator?.start()
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        Messaging.messaging().apnsToken = deviceToken
        InstanceID.instanceID().instanceID { (result, error) in
            guard error == nil else {
                Log.s(error!.localizedDescription)
                return
            }
            
            guard let result = result else {
                Log.s("No result!")
                return
            }
            
            Session.currentDeviceToken = result.token
            Auth.auth().setAPNSToken(deviceToken, type: .prod)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.s(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
     
        let data = userInfo["gcm.message_id"]
        Log.d(data)
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
    
    }

    // MARK: - Firebase Cloud Messaging
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        Log.d(fcmToken)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        Log.d("Remote Message", remoteMessage)
    }
    

    // MARK: - Testing
    var devModeText = """
**************************************************
Dev mode Enabled. Signout happening automatically.
**************************************************
"""
    
}

