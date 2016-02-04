//
//  UncleCharAppDelegate.m
//  UncleCharDemos
//
//  Created by UncleChar on 15/12/25.
//  Copyright © 2015年 hailong.xie. All rights reserved.
//

#import "UncleCharAppDelegate.h"
#import "LoginViewController.h"
#import "CJNavigationController.h"
#import "Reachability.h"
#import "DBManager.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
//#import "EaseMob.h"
#import "CoreLaunchLite.h"
#import "CoreLaunchCool.h"
#import "CoreLaunchPro.h"
#import "CoreLaunchPlus.h"
//http://docs.jpush.io/client/im_sdk_ios/

#import <JMessage/JMessage.h>

#define JMSSAGE_APPKEY @"df7f2abf395b36a2b6acc10a"
#define CHANNEL @"Publish channel"
@interface UncleCharAppDelegate ()
{
    UIScrollView *_loginScrollView;
}

@end

@implementation UncleCharAppDelegate


+ (UncleCharAppDelegate *)getUncleCharAppDelegateDelegate
{
    return (UncleCharAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    AppEngineManager *engineManager = [[AppEngineManager alloc]init];
    NSLog(@"AppStart---%@",engineManager.baseViewController);
    
    
    DBManager *db = [[DBManager sharedDBManager]initDBDirectoryWithPath:engineManager.dirDBSqlite];//打开数据库
    [db createDBTableWithTableName:@"UserInfo"];
    [db createDBTableWithTableName:@"UserFavouriteAndSave"];
    [db createDBTableWithTableName:@"RequestInfo"];
    

    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"rChGCt4DtWI0XsC56Wnvj7ov" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    
    NetworkManager *net =  [NetworkManager shareInstance];
    NSLog(@"kkkkkkkkkkkk %ld",net.downloadRequestArr.count);
    
//    
//    [[EaseMob sharedInstance] registerSDKWithAppKey:@"unclechar#unclechardemos" apnsCertName:nil];
//    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
//    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:@"8001" password:@"111111" withCompletion:^(NSString *username, NSString *password, EMError *error) {
//        if (!error) {
//            NSLog(@"注册成功");
//        }
//    } onQueue:nil];
//    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"8001" password:@"111111" completion:^(NSDictionary *loginInfo, EMError *error) {
//        if (!error) {
//            NSLog(@"登陆成功");
//            // 设置自动登录
//            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
//        }
//    } onQueue:nil];
//    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatusDidChanged:) name:kReachabilityChangedNotification object:nil];
    _hostReach = [Reachability reachabilityWithHostName:@"www.google.com"];//可以以多种形式初始化
    [_hostReach startNotifier];  //开始监听,会启动一个run loop

    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *rootNav;

    if ([[NSUserDefaults standardUserDefaults]boolForKey:kUserLoginStatus]) {
        
        rootNav = [[UINavigationController alloc]initWithRootViewController:[AppEngineManager sharedInstance].baseViewController];
        
    }else {

        rootNav = [[UINavigationController  alloc]initWithRootViewController:[[LoginViewController alloc]init]];
        
    }

    self.window.rootViewController = rootNav;
    
//    UIView *rootView = self.window.rootViewController.view;
//    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    iv.image = [UIImage imageNamed:@"1"];
//    [rootView addSubview:iv];
//    [UIView animateWithDuration:3 animations:^{
//        iv.alpha = 0;
//    }];
    /** Lite版本 */
//        [CoreLaunchLite animWithWindow:self.window image:[UIImage imageNamed:@"Index"]];
    
    /** Plus版本 */
//        [CoreLaunchPlus animWithWindow:self.window image:[UIImage imageNamed:@"Index"]];
    
    /** Cool版本 */
        [CoreLaunchCool animWithWindow:self.window image:[UIImage imageNamed:@"home.JPG"]];
    
    /** Pro版本 */
//    [CoreLaunchPro animWithWindow:self.window image:[UIImage imageNamed:@"Index"]];
    [self.window makeKeyAndVisible];
    
    // init third-party SDK
    
    [JMessage setupJMessage:launchOptions
                     appKey:JMSSAGE_APPKEY
                    channel:CHANNEL
           apsForProduction:NO
                   category:nil];
    
    
    
    // Required - 注册 APNs 通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
        
         
    
    
    
    
    
    
    
    
    
    
    
    

    return YES;
}

- (void)go {

    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    iv.image = [UIImage imageNamed:@"Index"];
    [[UIApplication sharedApplication].keyWindow addSubview:iv];
    
    [UIView animateWithDuration:5 animations:^{
    
    iv.alpha = 0;
    
     } completion:^(BOOL finished) {

    

     }];

}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
      NSLog(@"ResignActive");
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     NSLog(@"Background");
}


//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    [[IFlySpeechUtility getUtility] handleOpenURL:url];
//    return YES;
//}

 // 应用程序即将进入前台的时候调用
 // 一般在该方法中恢复应用程序的数据,以及状态
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
     NSLog(@"Foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSLog(@"BecomeActive");
    [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // 应用程序即将被销毁的时候会调用该方法
    // 注意:如果应用程序处于挂起状态的时候无法调用该方法
     NSLog(@"terminate");
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {


    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {


     NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
//    [rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
//    [rootViewController addNotificationCount];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


#pragma mark - 监听网络状态的改变
- (void)netStatusDidChanged:(NSNotification *)noti {


    Reachability* curReach = [noti object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无网络连接！请检查网络" message:@"networking"  delegate:nil
                                              cancelButtonTitle:@"YES" otherButtonTitles:nil];
        
        [alert show];
        
        [self storeNetworkStatusWithBool:NO];
        
    }
    if (status == ReachableViaWiFi) {
    
        
        [self storeNetworkStatusWithBool:YES];
    }
    if (status == ReachableViaWWAN) {
        
        
        [self storeNetworkStatusWithBool:YES];
    }

}

- (void)storeNetworkStatusWithBool:(BOOL)isReachable {

    [[NSUserDefaults standardUserDefaults] setBool:isReachable forKey:kNetworkStatus];
    
}

@end
