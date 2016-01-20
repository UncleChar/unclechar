//
//  UserModel.h
//  搜索框
//
//  Created by LingLi on 15/12/3.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic, strong) NSString *avatar;//头像
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *real_name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) BOOL       invited;
@property (nonatomic, assign) BOOL       isSelected;
@property (nonatomic, assign) BOOL       sex;

 
@end
