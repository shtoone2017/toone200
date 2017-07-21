//
//  AppDelegate.swift
//  ConcreteMix
//
//  Created by user on 15/9/29.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func registerPushForIOS8(){
        let os = NSProcessInfo().operatingSystemVersion
        if( os.majorVersion >= 8 ){
            //let types = UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert
            //Actions
            let acceptAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
            acceptAction.identifier = "ACCEPT_IDENTIFIER"
            acceptAction.title = "Accept"
            
            acceptAction.activationMode = UIUserNotificationActivationMode.Foreground
            acceptAction.destructive = false
            acceptAction.authenticationRequired = false
            
            //Categories
            let inviteCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
            inviteCategory.identifier = "INVITE_CATEGORY"
            inviteCategory.setActions([acceptAction], forContext: UIUserNotificationActionContext.Default)
            inviteCategory.setActions([acceptAction], forContext: UIUserNotificationActionContext.Minimal)
            //[acceptAction release];
            let categories:NSSet = NSSet(objects:inviteCategory)
            //[inviteCategory release];
            let mySettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Badge , UIUserNotificationType.Sound , UIUserNotificationType.Alert], categories: categories as? Set<UIUserNotificationCategory>)
            UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
        
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        XGPush.startApp(2200167451, appKey: "IP45R3PG15GB")
        
        //注销之后需要再次注册前的准备
        XGPush.initForReregister { () -> Void in
            if(!XGPush.isUnRegisterStatus()){
                //iOS8以上注册push方法
                print("OK")
                self.registerPushForIOS8()
            }
        }
        
        //角标清0
        //UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        //清除所有通知(包含本地通知)
        XGPush.handleLaunching(launchOptions, successCallback: { () -> Void in
            print("[XGPush]handleLaunching's successBlock")
            }) { () -> Void in
                print("XGPush]handleLaunching's errorBlock")
        }
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let deviceTokenStr:NSString = XGPush.registerDevice(deviceToken, successCallback:{ () -> Void in
            print("[XGPush]register successBlock")
            }) { () -> Void in
                print("[XGPush]register errorBlock")
        }
        con.deviceTokenStr = deviceTokenStr as String
        print("deviceTokenStr is \(deviceTokenStr)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        XGPush.handleReceiveNotification(userInfo)
        let userInfodict = userInfo as NSDictionary
        //插入消息记录
        let a = UserInfo()
        let msg = userInfodict.objectForKey("aps")?.objectForKey("alert") as! String
        let longdate = NSDate().timeIntervalSince1970
        a.insertTable_Data("", msg: msg, longdate: longdate)
//        if(application.applicationState == UIApplicationState.Active){
//            print("前台运行")
//            XGPush.localNotification(nil, alertBody:userInfodict.objectForKey("aps")?.objectForKey("alert") as! String, badge: 0, alertAction: "OK", userInfo: userInfo)
//        }
//        if(application.applicationState == UIApplicationState.Inactive){
//            print("后台运行")
//            NSNotificationCenter.defaultCenter().postNotificationName("presentView",object: userInfo)
//        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

