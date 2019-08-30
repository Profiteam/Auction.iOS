//
//  AppDelegate.swift
//  Auction
//
//  Created by Q on 18/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Starscream
import Firebase
import UserNotifications



//AAAAk9Ghgmc:APA91bEENun6jEDx1wCfPlglkSoUjs5D65oaZN6SsCjUPFinwvGPDvLbA4dyE84UttCyk6LOHZCo5YJe8drWfg7drn8mkeypjNipqElpNhyTR_msnZt8f7XGqtHfWyiYX939Q1eobssH

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var socket: WebSocket!
    
    let gcmMessageIDKey = "gcm.message_id"
    
    ///------ Setup HHTabBarView ------///
    
    let hhTabBarView = HHTabBarView.shared
    let referenceUITabBarController = HHTabBarView.shared.referenceUITabBarController
    
    func setupReferenceUITabBarController() -> Void {
        let homeViewController = HomeRouter.createModule()
        let walletViewController = WalletBalanceRouter.createModule()
        let profileViewController = ProfileRouter.createModule()
        let settingsViewController = SettingsRouter.createModule()
        
        self.referenceUITabBarController.setViewControllers([homeViewController, walletViewController, profileViewController, settingsViewController], animated: false)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().shadowImage = UIImage()
        
        // Setup HHTabBarView
        
        self.setupReferenceUITabBarController()
        self.setupHHTabBarView()
        
        // Setup Application Window
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: self.referenceUITabBarController)
        self.window!.rootViewController = navigationController
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        // Show if has no logged in
        
        if UserDefaults.standard.object(forKey: "token") == nil {
            let authorizationViewController = AuthorizationRouter.createModule()
            navigationController.pushViewController(authorizationViewController, animated: false)
        }
        
        IQKeyboardManager.shared.enable = true
        
        
        //Setup Firebbase
        let options = FirebaseOptions()
        options.apiKey = "AAAAk9Ghgmc:APA91bEENun6jEDx1wCfPlglkSoUjs5D65oaZN6SsCjUPFinwvGPDvLbA4dyE84UttCyk6LOHZCo5YJe8drWfg7drn8mkeypjNipqElpNhyTR_msnZt8f7XGqtHfWyiYX939Q1eobssH"
//        FirebaseApp.configure(options: options)
        
//        Messaging.messaging().delegate = self
        
        
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
        
//        application.registerForRemoteNotifications()
        
        return true
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
    
    // MARK: -
    // MARK: - WebSocket Setup
    
    func connectSocket(token: String, lotID: String) {
        var request = URLRequest(url: URL(string: "wss://testapp.pick2me.com:8443/channels_app/?token=\(token)&lot_id=\(lotID)")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }

    // MARK: -
    // MARK: - HHTabBarView Setup
    
    func setupHHTabBarView() -> Void {
        //Create Custom Tabs
        //Note: As tabs are subclassed of UIButton so you can modify it as much as possible.
        let t1 = HHTabButton(withTitle: nil, tabImage: UIImage(named: "ic_tab_home"), index: 0)
        t1.setImage(UIImage(named: "ic_tab_home_blue"), for: .selected)
        t1.imageVerticalAlignment = .top
        t1.imageHorizontalAlignment = .center
        
        let t2 = HHTabButton(withTitle: nil, tabImage: UIImage(named: "ic_tab_wallet"), index: 1)
        t2.setImage(UIImage(named: "ic_tab_wallet_blue"), for: .selected)
        t2.imageVerticalAlignment = .top
        t2.imageHorizontalAlignment = .center
        
        let t3 = HHTabButton(withTitle: nil, tabImage: UIImage(named: "ic_tab_profile"), index: 2)
        t3.setImage(UIImage(named: "ic_tab_profile_blue"), for: .selected)
        t3.imageVerticalAlignment = .top
        t3.imageHorizontalAlignment = .center
        
        let t4 = HHTabButton(withTitle: nil, tabImage: UIImage(named: "ic_tab_settings"), index: 3)
        t4.setImage(UIImage(named: "ic_tab_settings_blue"), for: .selected)
        t4.imageVerticalAlignment = .top
        t4.imageHorizontalAlignment = .center
        
        //Set Default Index for HHTabBarView.
        self.hhTabBarView.tabBarTabs = [t1, t2, t3, t4]
        
        //You should modify badgeLabel after assigning tabs array.
        /*
         t1.badgeLabel?.backgroundColor = .white
         t1.badgeLabel?.textColor = selectedTabColor
         t1.badgeLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
         */
        
        //Handle Tab Change Event
        self.hhTabBarView.selectTabAtIndex(withIndex: 0)
        
        //Show Animation on Switching Tabs
        self.hhTabBarView.tabChangeAnimationType = .pulsate
        
        //Handle Tab Changes
        self.hhTabBarView.onTabTapped = { (tabIndex) in
            
        }
    }
    
    func hideTabBar() -> Void {
        self.hhTabBarView.isHidden = true
    }
    
    func showTabBar() -> Void {
        self.hhTabBarView.isHidden = false
    }
    
    //Notifications
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error as? WSError {
            print("websocket is disconnected: \(e.message)")
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let dict: [String : Any] = ["message" : text]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "income_bet"), object: nil, userInfo: dict)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
    
    // MARK: Write Text Action
    
    @IBAction func writeText(_ sender: UIBarButtonItem) {
        socket.write(string: "hello there!")
    }
    
    // MARK: Disconnect Action
    
    @IBAction func disconnect(_ sender: UIBarButtonItem) {
        if socket.isConnected {
            sender.title = "Connect"
            socket.disconnect()
        } else {
            sender.title = "Disconnect"
            socket.connect()
        }
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}
