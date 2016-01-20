//
//  MainTabBarController.m
//  ReconstructionQQSlide
//
//  Created by LingLi on 15/12/24.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import "MainTabBarController.h"
#import "LeftViewController.h"
#import "MessageViewController.h"
#import "ContactsViewController.h"
#import "ActiveViewController.h"


@interface MainTabBarController ()
{

}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self createSubViewControllers];

    [self setTabBarItems];
   

}




- (void)createSubViewControllers {

    MessageViewController *limitVC = [[MessageViewController alloc]init];
    UINavigationController *limitNav = [[UINavigationController alloc]initWithRootViewController:limitVC];

    ContactsViewController  *saleVC = [[ContactsViewController alloc]init];
    UINavigationController *saleNav = [[UINavigationController alloc]initWithRootViewController:saleVC];
    
    ActiveViewController  *sale = [[ActiveViewController alloc]init];
    UINavigationController *salNav = [[UINavigationController alloc]initWithRootViewController:sale];
    
    self.viewControllers = @[limitNav,saleNav,salNav];
    
}
#pragma mark 设置所有的分栏元素项
- (void)setTabBarItems {
    
    NSArray *titleArr = @[@"Chat",@"Contacts",@"Active"];
    NSArray *normalImgArr = @[@"tabbar_items_1_normal@2x",@"tabbar_items_2_normal@2x",@"tabbar_items_3_normal@2x"];
    NSArray *selectedImgArr = @[@"tabbar_items_1_selected@2x",@"tabbar_items_2_selected@2x",@"tabbar_items_3_selected@2x"];
    //循环设置信息
    for (int i = 0; i<3; i++) {
        UIViewController *vc = self.viewControllers[i];
        
        vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:titleArr[i] image:[UIImage imageNamed:normalImgArr[i]] selectedImage:[[UIImage imageNamed:selectedImgArr[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
        vc.tabBarItem.tag = i;

        
    }
    //tabbar的背景图片
    //    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar_bg"];
    //item被选中时背景文字颜色
    //权限最高
    [[UITabBarItem appearance]setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    
    //self.navigationController.navigationBar 这个的话会有一个专题改不了，所以这用最高权限
    //获取导航条最高权限
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
}


//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    
//    switch (item.tag) {
//        case 0:
//        {
//            
//        }
//            
//            break;
//            
//        case 1:
//        {
//            
//            
//            NSLog(@"kaishi  222");
//        }
//            
//            break;
//            
//        case 2:
//        {
//            
//        }
//            
//            break;
//            
//        default:
//            break;
//    }
//    
//    
//}






































@end
