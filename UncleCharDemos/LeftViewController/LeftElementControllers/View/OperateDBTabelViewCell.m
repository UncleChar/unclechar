//
//  OperateDBTabelViewCell.m
//  UncleCharDemos
//
//  Created by LingLi on 15/12/29.
//  Copyright © 2015年 hailong.xie. All rights reserved.
//

#import "OperateDBTabelViewCell.h"
#import "UserTestModel.h"

@interface OperateDBTabelViewCell ()

{

    UIImageView   *avatarImg;
    UILabel       *nameLabel;
    UILabel       *userIDLabel;
}


@end

@implementation OperateDBTabelViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = [UIColor brownColor];
        [self createAllSubViews];
    }
    return self;
}


- (void)createAllSubViews {

    avatarImg = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 38, 38)];
    avatarImg.layer.cornerRadius = 19;
    avatarImg.layer.masksToBounds = 1;
    [self.contentView addSubview:avatarImg];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(56, 2, 100, 30)];
//    [nameLabel setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:nameLabel];
    
    userIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(56, 34, 100, 20)];
    [userIDLabel setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:userIDLabel];
    
    

    
}

- (void)setModel:(UserTestModel *)model {

    _model = model;
    avatarImg.image = [UIImage imageWithData:_model.biggerData];
    
    nameLabel.text = [NSString stringWithFormat:@"Name:%@",_model.userName];
    
    userIDLabel.text = [NSString stringWithFormat:@"ID:%@",_model.userID];
    
    
    
}

+ (CGFloat)cellHeight {

    return 50;
}
@end
