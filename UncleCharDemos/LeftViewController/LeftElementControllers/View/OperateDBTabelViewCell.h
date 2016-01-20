//
//  OperateDBTabelViewCell.h
//  UncleCharDemos
//
//  Created by LingLi on 15/12/29.
//  Copyright © 2015年 hailong.xie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserTestModel;
@interface OperateDBTabelViewCell : UITableViewCell

@property (nonatomic, strong) UserTestModel *model;


+ (CGFloat)cellHeight;

@end
