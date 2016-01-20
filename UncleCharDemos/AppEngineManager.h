//
//  AppEngineManager.h
//  UncleCharDemos
//
//  Created by UncleChar on 15/12/25.
//  Copyright © 2015年 hailong.xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppBaseViewController;//相当于整个容器
@class MainTabBarController;
@class UINavigationController;

@interface AppEngineManager : NSObject

@property (nonatomic, strong) UINavigationController    *baseNavController;
@property (nonatomic, strong) AppBaseViewController     *baseViewController;
@property (nonatomic, strong) MainTabBarController      *mainTabBarController;
@property (nonatomic, strong) NSString                  *dirDocument;
@property (nonatomic, strong) NSString                  *dirCache;
@property (nonatomic, strong) NSString                  *dirTemp;
@property (nonatomic, strong) NSString                  *dirDBSqlite;

@property (nonatomic, strong) NSString                  *leftViewElementsPath;

+ (instancetype)sharedInstance;

/**
 *  这是完成把数据存入沙盒的方法
 *
 *  @param data      要写入的数据
 *  @param fileName  数据命名为
 *  @param directory 写入的目标目录
 */
- (void)writeDataToDirectoryWithData:(NSData *)data fileNameForData:(NSString *)fileName underSuperDirecotry:(NSString *)directory;

- (void)createSubDirectoryName:(NSString *)subDirectoryName underSuperDirectory:(NSString *)superDirectory;

- (void)baseViewControllerPushViewController:(UIViewController *)targetViewController animated:(BOOL)animated;
@end
