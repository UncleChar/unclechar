//
//  ContactTableViewCell.m
//  搜索框
//
//  Created by LingLi on 15/12/2.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "AddressBookModel.h"
#import "ContactModel.h"
#import "UserModel.h"
#import "GroupModel.h"
#import "DivideContactsViewController.h"
//#import "UIImageView+WebCache.h"
@interface ContactTableViewCell ()
{
    
    UIButton     *selectBtn;
    UILabel      *nameLabel;
    UILabel      *emailLabel;
    UIImageView  *headImageView;
    UIImageView  *sexImg;
    
}

@end

@implementation ContactTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.backgroundColor = [ConfigUITools colorRandomly];
        self.backgroundColor = [UIColor whiteColor];

        [self creatSelectBtn];
        
    }
    return self;

    
}

- (void)creatSelectBtn {

    
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(10, 9.5, 25, 25);
//    selectBtn.backgroundColor = [UIColor lightGrayColor];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"common_checxbox_null@2x"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"common_checxbox_sel@2x"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:selectBtn];
    
    headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(47, 2, self.frame.size.height-4, self.frame.size.height - 4)];
    [self.contentView addSubview:headImageView];
    
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 2, 150, 20)];
    [nameLabel setTextColor:[UIColor whiteColor]];
    nameLabel.textColor = [ConfigUITools colorRandomly];
//    emailLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:nameLabel];
    
    emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 26, 300, 18)];
    [emailLabel setTextColor:[ConfigUITools colorRandomly]];
    emailLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:emailLabel];
    
    sexImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - (self.frame.size.height / 2 - 7.5 + 15 + 5), self.frame.size.height / 2 - 7.5, 15, 15)];
    [self.contentView addSubview:sexImg];

}

- (void)btnClicked:(UIButton *)sender {
    
    selectBtn.selected = !selectBtn.selected;
    
    if (selectBtn.selected) {
        
        if ([_sendModel isKindOfClass:[GroupModel class]]) {
            GroupModel *gmodel = _sendModel;
            if (gmodel.invited) {
                selectBtn.selected = NO;
                [selectBtn setBackgroundImage:[UIImage imageNamed:@"common_checxbox_selected@2x"] forState:UIControlStateNormal];
                UIAlertView *alret = [[UIAlertView alloc]initWithTitle:@"已经邀请过组" message:gmodel.group_name delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alret show];
                
            }else {
                
                gmodel.isSelected = YES;
            }
        }else if ([_sendModel isKindOfClass:[UserModel class]]) {
            UserModel *umodel = _sendModel;
            if (umodel.invited) {
                
                selectBtn.selected = NO;
                [selectBtn setBackgroundImage:[UIImage imageNamed:@"common_checxbox_selected@2x"] forState:UIControlStateNormal];
                UIAlertView *alret = [[UIAlertView alloc]initWithTitle:@"已邀请过成员" message:umodel.real_name delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alret show];
                
            }else {
                
                umodel.isSelected = YES;
            }
        }else {
            AddressBookModel *admodel = _sendModel;
            admodel.isSelected = YES;
            
        }
        
        if ([_delegate respondsToSelector:@selector(btnSelected: withModel:)]) {
            [_delegate btnSelected:sender withModel:_sendModel];
        }
        
        
    }else {
        
        if ([_sendModel isKindOfClass:[UserModel class]]) {
            
            UserModel *umodel = _sendModel;
            umodel.isSelected = NO;
            
        }else if([_sendModel isKindOfClass:[GroupModel class]]) {
            
            GroupModel *gmodel = _sendModel;
            gmodel.isSelected = NO;
            
        }else {
            AddressBookModel *admodel = [[AddressBookModel alloc]init];
            admodel.isSelected = NO;
        }
        
        if ([_delegate respondsToSelector:@selector(btnUnSelected:withModel:)]) {
            [_delegate btnUnSelected:sender withModel:_sendModel];
        }
        
    }
    
}

-(void)setModel:(id)model {

    if ([model isKindOfClass:[UserModel class]]) {
        
        
        _userModel  = model;
        _sendModel = _userModel;
        nameLabel.frame  = CGRectMake(100, 2, 150, 20);
        emailLabel.frame = CGRectMake(100, 24, 300, 18);
//        [headImageView setImageWithURL:[NSURL URLWithString:_userModel.avatar] placeholderImage:[UIImage imageNamed:@""]];
        //        [headImageView sd_setImageWithURL: placeholderImage:];
        headImageView.image = [UIImage imageNamed:@"buddy_friends_none@2x"];
        nameLabel.text  = _userModel.real_name;
        emailLabel.text = _userModel.phone;
        if (_userModel.invited) {
            
            selectBtn.selected = NO;
            [selectBtn setBackgroundImage:[UIImage imageNamed:@"common_checxbox_selected@2x"] forState:UIControlStateNormal];
            
        }else {
            
            [selectBtn setBackgroundImage:[UIImage imageNamed:@"common_checxbox_null"] forState:UIControlStateNormal];
            if (_userModel.isSelected) {
                
                selectBtn.selected = YES;
            }else {
                selectBtn.selected = NO;
            }
            
        }
        
        if (_userModel.sex) {
            
            sexImg.image = [UIImage imageNamed:@"avatar_male@2x"];
            
        }else {
        
            sexImg.image = [UIImage imageNamed:@"avatar_famale@2x"];
        }
        
        
        
        
    }else if ([model isKindOfClass:[GroupModel class]]){
        
        _groupModel = model;
        _sendModel = _groupModel;
        nameLabel.frame = CGRectMake(100, 4, 200, 28);
        
        nameLabel.text  = [NSString stringWithFormat:@"%@(%ld)",_groupModel.group_name,_groupModel.userModelArrWithGroup.count];
        emailLabel.frame = CGRectMake(100, 34, 300, 10);
//        emailLabel.text = @"";
        headImageView.image = [UIImage imageNamed:@"buddy_group_none@2x"];
        if (_groupModel.invited) {
            
            selectBtn.selected = NO;
            [selectBtn setBackgroundImage:[UIImage imageNamed:@"common_checxbox_selected@2x"] forState:UIControlStateNormal];
            
        }else {
            
            [selectBtn setBackgroundImage:[UIImage imageNamed:@"common_checxbox_null"] forState:UIControlStateNormal];
            
            if (_groupModel.isSelected) {
                
                selectBtn.selected = YES;
            }else {
                selectBtn.selected = NO;
            }
            
        }
        sexImg.image = [UIImage imageNamed:@"group_section"];
        
    }else  {
        
        _localModel  = model;
        _sendModel = _localModel;
        nameLabel.frame = CGRectMake(100, 2, 150, 20);
        emailLabel.frame = CGRectMake(100, 26, 300, 18);
        nameLabel.text  = _localModel.name;
        emailLabel.text = _localModel.email;
        headImageView.image = [UIImage imageNamed:@"main_menu_profile_photo_default"];
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"common_checxbox_null"] forState:UIControlStateNormal];
        if (_localModel.isSelected) {
            
            selectBtn.selected = YES;
        }else {
            selectBtn.selected = NO;
        }
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:YES animated:YES];
    
    // Configure the view for the selected state
}

@end
