//
//  EaseMobViewController.m
//  UncleCharDemos
//
//  Created by LingLi on 16/1/13.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "EaseMobViewController.h"
//#import "EaseMob.h"
@interface EaseMobViewController ()

@end

@implementation EaseMobViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ConfigUITools colorRandomly];
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}



@end
