//
//  NetworkManager.m
//  UncleCharDemos
//
//  Created by LingLi on 16/2/3.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "NetworkManager.h"

static NetworkManager  *sharedElement = nil;
@implementation NetworkManager

+ (instancetype) shareInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        sharedElement = [[self alloc]init];
        
    });
    return sharedElement;

}


+ (id)allocWithZone:(struct _NSZone *)zone {

    @synchronized(self) {
        
        if (sharedElement == nil) {
            
            sharedElement = [super allocWithZone:zone];
            return  sharedElement;
        }
        
    }
    return nil;

}

- (id)copyWithZone:(NSZone *)zone {
    
    return self;
}

- (NSMutableArray *)getDownloadRequestList {

    if (nil == _downloadRequestArr) {
        
        _downloadRequestArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    
    return _downloadRequestArr;

}

- (NSMutableArray *)getModelList {
    
    if (nil == _modelArr) {
        
        _modelArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    
    return _modelArr;
    
}
@end
