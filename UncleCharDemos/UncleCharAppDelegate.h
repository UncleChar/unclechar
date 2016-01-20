//
//  UncleCharAppDelegate.h
//  UncleCharDemos
//
//  Created by UncleChar on 15/12/25.
//  Copyright © 2015年 hailong.xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

static NSString *appKey = @"df7f2abf395b36a2b6acc10a";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@class Reachability;
@interface UncleCharAppDelegate : UIResponder<UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow     *window;
@property (strong, nonatomic) Reachability *hostReach;
@property (strong, nonatomic) BMKMapManager *mapManager;

+ (UncleCharAppDelegate *)getUncleCharAppDelegateDelegate;

@end
