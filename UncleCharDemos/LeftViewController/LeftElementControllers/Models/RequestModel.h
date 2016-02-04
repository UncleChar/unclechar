//
//  RequestModel.h
//  UncleCharDemos
//
//  Created by LingLi on 16/2/4.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestModel : NSObject <NSCoding>


@property (nonatomic, strong) ASIHTTPRequest   *request;
@property (nonatomic, strong) NSString         *requestID;
@property (nonatomic, strong) NSString         *requestUrl;

@end
