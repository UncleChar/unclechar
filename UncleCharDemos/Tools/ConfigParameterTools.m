//
//  ConfigParameterTools.m
//  UncleCharDemos
//
//  Created by LingLi on 16/1/25.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "ConfigParameterTools.h"
#import "SSKeychain.h"

#define kService  [NSBundle mainBundle].bundleIdentifier
#define  kAccount @"com.xhl.unclechar"

@implementation ConfigParameterTools


+ (NSString *)gen_uuid {

    if (![SSKeychain passwordForService:kService account:kAccount]) {
        
        NSString *uuid = [self getDeviceUUID];
        
        [SSKeychain setPassword:uuid forService:kService account:kAccount];
        
    }
    
    NSString *deviceNumber = [SSKeychain passwordForService:kService account:kAccount];
    
    NSLog(@"deviceNumber %@",deviceNumber);
    
    return deviceNumber;
}


+ (NSString *)getDeviceUUID {

        CFUUIDRef  uuid_ref = CFUUIDCreate(nil);
    
        CFStringRef uuid_string_ref = CFUUIDCreateString(nil, uuid_ref);
        CFRelease(uuid_ref);
        NSString *uuid = [NSString stringWithString:(__bridge NSString * _Nonnull)(uuid_string_ref)];
        
        CFRelease(uuid_string_ref);
        return uuid;
}

@end
