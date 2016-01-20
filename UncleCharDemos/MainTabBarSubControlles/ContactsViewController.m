//
//  ContactsViewController.m
//  ReconstructionQQSlide
//
//  Created by LingLi on 15/12/24.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import "ContactsViewController.h"

@implementation ContactsViewController

- (void)viewWillAppear:(BOOL)animated {
    
//    NSLog(@"CONTACTS");
    
}
- (void)viewDidLoad {
    
     [super viewDidLoad];
    self.view.backgroundColor = [ConfigUITools colorRandomly];
    self.navigationItem.title = @"Call me";

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(contactsBtn)];
    rightItem.image = [UIImage imageNamed:@"tabbar_items_calll@2x"];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    UIImageView *ff = [UIImageView alloc]initWithFrame:<#(CGRect)#>
    
}

- (void)contactsBtn {

    NSString *number = @"13775846635";// 此处读入电话号码
    
    // NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number]; //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表

    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    

}


@end
