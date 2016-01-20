//
//  BaseViewController.m
//  ReconstructionQQSlide
//
//  Created by LingLi on 15/12/24.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import "SuperViewController.h"
#import "LocationViewController.h"

@implementation SuperViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(baseVC)];
    leftItem.image = [UIImage imageNamed:@"qq@3x"];
    self.navigationItem.leftBarButtonItem = leftItem;
    

}
- (void)baseVC{

    NSLog(@"leftBtnClicked");
    [[AppEngineManager sharedInstance].baseViewController leftControllerAppear];

}


@end
