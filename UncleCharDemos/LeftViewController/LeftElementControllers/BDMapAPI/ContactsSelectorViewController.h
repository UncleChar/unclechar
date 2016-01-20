//
//  ContactsSelectorViewController.h
//  UncleCharDemos
//
//  Created by LingLi on 16/1/5.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsSelectorViewController : UIViewController

@property (nonatomic, assign) CGFloat       firstResponderTFMaxY;
@property (nonatomic, strong) UITextField  *firstResponderTF;
@property (nonatomic, strong) UIView       *baseView;

@end
