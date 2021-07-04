//
//  AppDelegate.swift
//  TimerS
//
//  Created by Dayeon Jung on 04/02/2020.
//  Copyright © 2020 Dayeon Jung. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleMobileAds
import LGSideMenuController
import AppTrackingTransparency
import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.setGoogleAds()
        self.setFCM(application)
        self.setWindow()
        
        return true
    }
    
    private func setGoogleAds() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    private func setFCM(_ application: UIApplication) {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
            
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in
                self.setRequestTrackingAuth()
            })
            
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

    }
    
    private func setRequestTrackingAuth() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
            }
        } else {
            // Fallback on earlier versions
        }
    }

    private func setWindow() {
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        
        let mainViewController = MainViewController()
        mainViewController.rootViewController = navigationController
        mainViewController.setup()
        
        window?.rootViewController = mainViewController
        
        UIView.transition(with: window ?? UIWindow(), duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)

    }
    
    private func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
      // Let FCM know about the message for analytics etc.
      Messaging.messaging().appDidReceiveMessage(userInfo)
      // handle your message
    }
    
    
    // token이 업데이트 될 때마다 알림.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      
      NotificationCenter.default.post(name: Notification.Name("FCMToken"),
                                      object: nil,
                                      userInfo: dataDict)
    }
    


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TimerS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([[.alert, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
      
        let userInfo = response.notification.request.content.userInfo
        print("receive FCM", userInfo)
        completionHandler()
    }
}
