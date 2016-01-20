//
//  AddressBookModel.h
//  搜索框
//
//  Created by LingLi on 15/11/13.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookModel : NSObject


@property NSInteger sectionNumber;
@property NSInteger recordID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *tel;
@property (nonatomic, assign) BOOL       isSelected;

@end
