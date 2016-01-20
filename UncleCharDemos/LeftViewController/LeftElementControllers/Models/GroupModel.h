//
//  GroupModel.h
//  搜索框
//
//  Created by LingLi on 15/12/3.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;
@interface GroupModel : NSObject

@property (nonatomic, strong) NSString  *group_id;
@property (nonatomic, strong) NSString  *group_name;
@property (nonatomic, assign) BOOL       invited;
@property (nonatomic, strong) NSString  *user_count;
@property (nonatomic, strong) UserModel *usersAtGroModel;
@property (nonatomic, assign) BOOL       isSelected;
@property (nonatomic, strong) NSMutableArray *userModelArrWithGroup;



@end
