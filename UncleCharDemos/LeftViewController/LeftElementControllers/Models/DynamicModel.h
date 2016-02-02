//
//  dynamicModel.h
//  UncleCharDemos
//
//  Created by LingLi on 16/2/2.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASIHTTPRequest;
@interface DynamicModel : NSObject

@property (nonatomic, strong) NSString         *url;
@property (nonatomic, strong) ASIHTTPRequest   *request;
@property (nonatomic, strong) NSString         *itemTitle;
@property (nonatomic, assign) BOOL              hasRequest;
@end

