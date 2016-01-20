//
//  JChatViewController.m
//  UncleCharDemos
//
//  Created by LingLi on 16/1/20.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "JChatViewController.h"
#import <JMessage/JMessage.h>

#import <JMessage/JMSGUser.h>
#import "StartChatViewController.h"
@interface JChatViewController ()

@end

@implementation JChatViewController
- (void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBarHidden = 0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"JChat";
    [JMSGUser registerWithUsername:@"123456" password:@"123456" completionHandler:^(id resultObject, NSError *error) {
        
        if (error == nil) {
            
            NSLog(@"RESULT:%@",resultObject);
        }else {
        
            NSLog(@"error:%@",error);
        }
        
    }];
    
    NSString *username = @"123456";
    NSString *password = @"123456";
    [JMSGUser registerWithUsername:username
                          password:password
                 completionHandler:^(id resultObject, NSError *error) {
                     if (error == nil) {

                         [JMSGUser loginWithUsername:username
                                            password:password
                                   completionHandler:^(id resultObject, NSError *error) {
                                       if (error == nil) {

                                           JMSGUser *UU = [JMSGUser getMyInfo];
                                           NSLog(@"$%@",UU.username);
                                           
                                       } else {
                                           NSString *alert = @"用户登录失败";
                                           if (error.code == 898002) {
                                               alert = @"用户名不存在";
                                           } else if (error.code == 898004) {
                                               alert = @"密码错误！";
                                           } else if (error.code == 898003) {
                                               alert = @"用户名或者密码不合法！";
                                           }

                                       }
                                   }];
                     } else {
                         NSString *alert = @"注册失败";
                         if (error.code == 898001) {
                             alert = @"用户已经存在！";
                         } else if (error.code == 898003) {
                             alert = @"用户名或者密码不合法";
                         }

                         NSLog(@"alert %@",alert);
                     }
                 }];

    


    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"聊天" style:UIBarButtonItemStylePlain target:self action:@selector(btnClicked)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

- (void)btnClicked {

    [self.navigationController pushViewController:[[StartChatViewController alloc]init] animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
