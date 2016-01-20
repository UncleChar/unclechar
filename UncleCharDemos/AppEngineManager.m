//
//  AppEngineManager.m
//  UncleCharDemos
//
//  Created by UncleChar on 15/12/25.
//  Copyright © 2015年 hailong.xie. All rights reserved.
//

#import "AppEngineManager.h"
#import "AppBaseViewController.h"
#import "MainTabBarController.h"
#import "NSString+Extension.h"
static  AppEngineManager *sharesElement = nil;
@implementation AppEngineManager


+ (instancetype)sharedInstance {
    
    @synchronized(self) {
        
        if (sharesElement == nil) {
            
            sharesElement = [[self alloc]init];
        }
    }
    
    return sharesElement;
}

+(id)allocWithZone:(struct _NSZone *)zone {
    
    @synchronized(self) {
        
        if (sharesElement == nil) {
            
            sharesElement = [super allocWithZone:zone];
            return  sharesElement;
        }
        
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    
    return self;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.baseViewController = [[AppBaseViewController alloc]init];
        
        self.baseNavController = [[UINavigationController alloc]initWithRootViewController:self.baseViewController];
        
        self.mainTabBarController = [[MainTabBarController alloc]init];
        
        self.dirDocument = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];

        self.dirCache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        
        self.dirTemp  = NSTemporaryDirectory();
        
        self.dirDBSqlite = [self.dirDocument stringByAppendingPathComponent:@"MyAppDataBase.sqlite"];


        NSLog(@"    BaseViewController : %@",self.baseViewController);
        NSLog(@"          BaseViewCNav : %@",self.baseViewController.navigationController);
        NSLog(@"BaseViewControllerNavC : %@",self.baseNavController);
        NSLog(@"               MainTBC : %@",self.mainTabBarController);
        NSLog(@"          DocumentPath : %@",self.dirDocument);
        NSLog(@"          DocumentSize : %ld",[self.dirDocument fileSize]);
        NSLog(@"             CachePath : %@",self.dirCache);
        NSLog(@"              TempPath : %@",self.dirTemp);
    }
    return self;
}


- (void)writeDataToDirectoryWithData:(NSData *)data fileNameForData:(NSString *)fileName underSuperDirecotry:(NSString *)directory {


    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 创建目录
    BOOL res=[fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res) {
        NSLog(@"目录-%@创建成功",directory);
        [self writeDirWithData:data withFileName:fileName atTargetPath:directory];
    }else{
        NSLog(@"目录-%@-创建失败",directory);
    }
    

}
-(void )writeDirWithData:(NSData *)data withFileName:(NSString *)fileName atTargetPath:(NSString *)path{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [path stringByAppendingPathComponent:fileName];

    BOOL res=[fileManager createFileAtPath:testDirectory contents:data attributes:nil];
    
    if (res) {
        NSLog(@"%@写入成功:",fileName );
    }else{
        NSLog(@"%@写入失败",fileName);}

}

- (void)createSubDirectoryName:(NSString *)subDirectoryName underSuperDirectory:(NSString *)superDirectory {

     NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [NSString stringWithFormat:@"%@/%@",superDirectory,subDirectoryName];
    // 创建目录
    BOOL res = [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res) {
        NSLog(@"目录-%@创建成功",subDirectoryName);
        self.leftViewElementsPath = directory;
    }else{
        NSLog(@"目录-%@-创建失败",subDirectoryName);
        self.leftViewElementsPath = nil;
    }
}


- (void)baseViewControllerPushViewController:(UIViewController *)targetViewController animated:(BOOL)animated {

    [[AppEngineManager sharedInstance].baseViewController.navigationController pushViewController:targetViewController animated:animated];

}

@end
