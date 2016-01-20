//
//  ContactTableViewCell.h
//  搜索框
//
//  Created by LingLi on 15/12/2.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactTableViewCellDelegate <NSObject>

- (void)btnSelected:(UIButton *)btn withModel:(id)model;
- (void)btnUnSelected:(UIButton *)btn withModel:(id)model;

@end

@class AddressBookModel;
@class ContactModel;
@class UserModel;
@class GroupModel;
@interface ContactTableViewCell : UITableViewCell
@property (nonatomic, weak)id<ContactTableViewCellDelegate> delegate;
@property (nonatomic, strong)NSString *nameString;
@property (nonatomic, assign)BOOL     selectBtnBool;
@property (nonatomic, strong)id       model;
@property (nonatomic, strong)id       sendModel;
@property (nonatomic, strong)ContactModel      *contactModel;
@property (nonatomic, strong)UserModel      *userModel;
@property (nonatomic, strong)GroupModel     *groupModel;
@property (nonatomic, strong)AddressBookModel  *localModel;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
