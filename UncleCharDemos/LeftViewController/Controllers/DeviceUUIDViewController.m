//
//  DeviceUUIDViewController.m
//  UncleCharDemos
//
//  Created by LingLi on 16/1/25.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "DeviceUUIDViewController.h"
#import "SSKeychain.h"
#import "ConfigParameterTools.h"

@interface DeviceUUIDViewController ()

@end

@implementation DeviceUUIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ConfigUITools colorRandomly];

    NSLog(@"gggg %@",[ConfigParameterTools gen_uuid]);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
