//
//  ConfigUITools.h
//  TestDemoByXhl
//
//  Created by LingLi on 15/11/24.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigUITools : NSObject

+ (UIButton *)configButtonWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)size frame:(CGRect)frame superView:(UIView *)superView ;

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)balck A:(CGFloat)alpha;

+ (UIColor *)colorRandomly;
@end
