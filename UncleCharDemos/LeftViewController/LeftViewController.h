//
//  LeftViewController.h
//  SlideLikeQQ
//
//  Created by UncleChar on 15/12/22.
//  Copyright © 2015年 hailong.xie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController

@property (nonatomic, strong) UITableView  *listTableView;
@property (nonatomic, strong) UITapGestureRecognizer *tapOnSignNameLabel;

- (void)refreshUserAvatar;
- (void)refreshSignName;

@end
