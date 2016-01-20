//
//  UserSignViewController.m
//  UncleCharDemos
//
//  Created by UncleChar on 15/12/27.
//  Copyright © 2015年 hailong.xie. All rights reserved.
//

#import "UserSignViewController.h"


@interface UserSignViewController ()
{

    UITextView *tf;
}
@end

@implementation UserSignViewController


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSign)];
//    leftItem.image = [UIImage imageNamed:@"qq@3x"];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    tf = [[UITextView alloc]initWithFrame:CGRectMake(20, 100, kScreenWidth - 40, 100)];
    tf.text = self.signName;
    tf.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:tf];
    

    
    
    
    // Do any additional setup after loading the view.
}
- (void)saveSign {

    [[NSUserDefaults standardUserDefaults]setObject:tf.text forKey:kPersonalizedSignature];
    [self.navigationController popViewControllerAnimated:YES];

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
