//
//  AppDelegate.swift
//  RWReminder
//
//  Created by Iavor Dekov on 5/15/17.
//  Copyright © 2017 Iavor Dekov. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    FirebaseApp.configure()
    
    handlePushNotifications(application)
    
    return true
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    saveFCMToken()
  }

}

extension AppDelegate {
  
  func handlePushNotifications(_ application: UIApplication) {
    if #available(iOS 10.0, *) {
      // For iOS 10 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
  }
  
  func saveFCMToken() {
    let ref = Database.database().reference()
    Auth.auth().signInAnonymously() { (user, error) in
      if let user = user {
        ref.child("users").child(user.uid).setValue(["token": Messaging.messaging().fcmToken!])
      }
    }
  }
  
}
