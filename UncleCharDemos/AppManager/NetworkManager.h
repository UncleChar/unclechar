//
//  NetworkManager.h
//  UncleCharDemos
//
//  Created by LingLi on 16/2/3.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkManager : NSObject

@property (nonatomic, strong) NSMutableArray     *uploadRequestArr;
@property (nonatomic, strong) NSMutableArray     *downloadRequestArr;
@property (nonatomic, strong) NSMutableArray     *modelArr;

+ (instancetype) shareInstance;

- (NSMutableArray *)getDownloadRequestList;
- (NSMutableArray *)getModelList;
@end

