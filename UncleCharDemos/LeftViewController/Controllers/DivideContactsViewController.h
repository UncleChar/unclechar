//
//  DivideContactsViewController.h
//  UncleCharDemos
//
//  Created by LingLi on 16/1/5.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^catchModelsBlock)(NSMutableArray *modelsArray);

@interface DivideContactsViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *usersModelArray;
@property (nonatomic, strong) NSMutableArray *groupsModelArray;
@property (nonatomic, strong) catchModelsBlock    catchBlock;
@property (nonatomic, strong) NSMutableArray *catchModelsArray;
@property (nonatomic, strong) NSMutableArray        *dataAddressSourceArray;  //本地联系人

@end
