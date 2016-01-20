//
//  ConfigUITools.m
//  TestDemoByXhl
//
//  Created by LingLi on 15/11/24.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import "ConfigUITools.h"

@implementation ConfigUITools

//初始化index控制器的诸多按钮
/**
 *
 *  @param title     按钮的标题
 *  @param color     按钮的颜色
 *  @param size      标题的字号
 *  @param frame     按钮的位置
 *  @param superView 按钮的父视图
 */
+ (UIButton *)configButtonWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)size frame:(CGRect)frame superView:(UIView *)superView {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = color;
    btn.titleLabel.font = [UIFont systemFontOfSize:size];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:0];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = 1;
    [superView addSubview:btn];
    
    return btn;


}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)balck A:(CGFloat)alpha {

    return [UIColor colorWithRed:red /255.0 green:green/255.0 blue:balck / 255.0 alpha:alpha];
}

+ (UIColor *)colorRandomly{

    return [UIColor colorWithHue:( arc4random() % 256 / 256.0 )
           saturation:( arc4random() % 128 / 256.0 ) + 0.5
           brightness:( arc4random() % 128 / 256.0 ) + 0.5
                alpha:1];
}
@end
