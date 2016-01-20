//
//  ChatTableViewCell.m
//  UncleCharDemos
//
//  Created by LingLi on 16/1/8.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "ChatTableViewCell.h"

@interface ChatTableViewCell ()
{

    UIImageView      *_avatarImgView;
    
}
@end

@implementation ChatTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        self.backgroundColor = [ConfigUITools colorRandomly];
        self.backgroundColor = [UIColor whiteColor];
        
        [self createSubviews];
        
    }
    return self;
    
    
}

- (void)createSubviews {

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
