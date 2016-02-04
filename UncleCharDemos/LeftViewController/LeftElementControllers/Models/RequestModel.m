//
//  RequestModel.m
//  UncleCharDemos
//
//  Created by LingLi on 16/2/4.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "RequestModel.h"

@implementation RequestModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.request forKey:@"request"];
    [encoder encodeObject:self.requestID forKey:@"requestID"];
    [encoder encodeObject:self.requestUrl forKey:@"requestUrl"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.request = [decoder decodeObjectForKey:@"request"];
        self.requestID = [decoder decodeObjectForKey:@"requestID"];
        self.requestUrl = [decoder decodeObjectForKey:@"requestUrl"];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
