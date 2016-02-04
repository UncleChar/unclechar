//
//  DynamicTableViewCell.m
//  UncleCharDemos
//
//  Created by LingLi on 16/2/2.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "DynamicTableViewCell.h"
#import "DynamicModel.h"
#import "ProgressView.h"
@interface DynamicTableViewCell ()
{
    UIImageView     *avatarImg;
    UILabel         *nameLabel;
    UIProgressView  *progress;
}
@end

@implementation DynamicTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.backgroundColor = [UIColor brownColor];
        [self createAllSubViews];
    }
    return self;
}


- (void)createAllSubViews {
    
    avatarImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 3, 38, 38)];
    avatarImg.layer.cornerRadius = 19;
    avatarImg.layer.masksToBounds = 1;
    [self.contentView addSubview:avatarImg];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(56, 2, kScreenWidth - 60, 25)];
    nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:nameLabel];
    

    
    
    
    
}

- (void)setModel:(DynamicModel *)model {
    
    _model= model;
    avatarImg.image = [UIImage imageNamed:@"aio_sm_cover_default@2x"];
    
    nameLabel.text = [NSString stringWithFormat:@"Name:%@",_model.itemTitle];
    
    

    if (_model.hasRequest) {
        
        
        _ProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(56, 29, kScreenWidth - 60, 20)];
//        _ProgressView.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
//        _ProgressView.popUpViewCornerRadius = 16.0;
//
//        [_ProgressView showPopUpViewAnimated:YES];
        
        
        [self.contentView addSubview:_ProgressView];
        

        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_model.url]];
        [request setValidatesSecureCertificate:NO];   //-----https
        [request setQueuePriority:NSOperationQueuePriorityNormal];
        
        [request setDelegate:self];
        __block ASIHTTPRequest *blockRequest = request;
        [request setCompletionBlock:^{
            [self dynamicModelrequestFinished:blockRequest];
        }];
        
        [request setFailedBlock:^{
            [self dynamicModelrequestFailed:blockRequest];
        }];
        [request setNumberOfTimesToRetryOnTimeout:1];
        [request setShowAccurateProgress:YES];
        [request setDownloadProgressDelegate:_ProgressView];
        
//        [request setShowAccurateProgress:YES];
//        [request setUploadProgressDelegate:_ProgressView];
        
        [request setTimeOutSeconds:30.0f];
        [request startAsynchronous];
        [ [NetworkManager shareInstance].downloadRequestArr addObject:request];
         NSLog(@"_upldffdfdfdf %ld", [NetworkManager shareInstance].downloadRequestArr.count);
         NSLog(@"&& %@", [NetworkManager shareInstance].downloadRequestArr);
         nameLabel.textColor = [UIColor lightGrayColor];
        
    }else {
    
        nameLabel.textColor = [UIColor blackColor];
    
    }

    
    
    
    
    
}

#pragma mark - ASIHttprequestDelegate

- (void)dynamicModelrequestFinished:(ASIHTTPRequest *)request {
    

    if ([_delegate respondsToSelector:@selector(requestStatus:withModel:)]) {
        
        [_delegate requestStatus:YES withModel:_model];
    }
     nameLabel.textColor = [UIColor blackColor];
    [_ProgressView removeFromSuperview];
    _ProgressView = nil;
    
}



- (void)dynamicModelrequestFailed:(ASIHTTPRequest *)request {

    if ([_delegate respondsToSelector:@selector(requestStatus:withModel:)]) {
        
        [_delegate requestStatus:NO withModel:_model];
    }
     nameLabel.textColor = [UIColor blackColor];
    [_ProgressView removeFromSuperview];
    _ProgressView = nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
