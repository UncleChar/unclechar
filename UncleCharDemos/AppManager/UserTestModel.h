//
//  UserTestModel.h
//  UncleCharDemos
//
//  Created by LingLi on 15/12/28.
//  Copyright © 2015年 hailong.xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTestModel : NSObject


@property (nonatomic, strong)   NSString *userName;
@property (nonatomic, strong)   NSString *userID;
@property (nonatomic, assign)   NSString *country;
@property (nonatomic, assign)   NSString *sex;
@property (nonatomic, strong)   NSData   *userMusic;
@property (nonatomic, strong)   NSData   *biggerData;
@property (nonatomic, strong)   NSString *telephone;


@end
