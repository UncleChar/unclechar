//
//  DynamicTableViewCell.h
//  UncleCharDemos
//
//  Created by LingLi on 16/2/2.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProgressView;
@class DynamicModel;
@class ASIHTTPRequest;
@protocol DynamicTableViewCellDelegate <NSObject>

- (void)requestStatus:(BOOL)isSuccess withModel:(DynamicModel *)model;

@end

@interface DynamicTableViewCell : UITableViewCell

@property (nonatomic, strong) DynamicModel    *model;
@property (nonatomic, strong) ASIHTTPRequest  *modelRequest;
@property (nonatomic, weak)   id<DynamicTableViewCellDelegate>delegate;
@property (nonatomic,retain)  UIProgressView *ProgressView;//这里是本地进度条

@end
