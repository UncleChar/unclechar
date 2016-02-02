//
//  LeftViewController.m
//  SlideLikeQQ
//
//  Created by UncleChar on 15/12/22.
//  Copyright © 2015年 hailong.xie. All rights reserved.
//

#import "LeftViewController.h"
#import "UserSignViewController.h"
#import "RenewUserAvatarViewController.h"
#import "OperateDBViewController.h"
#import "LocationViewController.h"
#import "ContactsSelectorViewController.h"
#import "GifPlayViewController.h"
#import "VoiceRecognitionViewController.h"
#import "EaseMobViewController.h"
#import "JChatViewController.h"
#import "DeviceUUIDViewController.h"
#import "RichTextEditorViewController.h"
#import "DynamicShowViewController.h"

#define kAvatarImgWidth    kDriftXOfLeftView / 4
#define kAvatarImgHeight   kDriftXOfLeftView / 4

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIImageView  *avatarImageView;
@property (nonatomic, strong) UIImageView  *topBackgrooundImg;
@property (nonatomic, strong) UIImageView  *headImgView;
@property (nonatomic, strong) NSArray      *titleListArray;
@property (nonatomic, strong) UIView       *headView;
@property (nonatomic, strong) UILabel      *nameLabel;
@property (nonatomic, strong) UILabel      *signNameLabel;
@property (nonatomic, strong) UIView       *bottomView;

@end

@implementation LeftViewController

- (void)viewWillAppear:(BOOL)animated {

    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configElementsUI];
    
    [self addTargetWithTapGesture];
    
}
- (void)configElementsUI {

    self.view.frame = CGRectMake(-kDriftXOfLeftView, 0, kDriftXOfLeftView, kScreenHeight);
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width / 2)];
    [self.view addSubview:_headView];
    
    
    _topBackgrooundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDriftXOfLeftView, kDriftXOfLeftView / 2)];
    _topBackgrooundImg.alpha =0.6;
    _topBackgrooundImg.backgroundColor = [ConfigUITools colorRandomly];
    [_headView addSubview:_topBackgrooundImg];
    
    _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kDriftXOfLeftView / 12, kAvatarImgWidth / 2, kAvatarImgWidth, kAvatarImgHeight)];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
    _avatarImageView.image = [UIImage imageWithContentsOfFile:path];
    _avatarImageView.layer.cornerRadius = kAvatarImgWidth / 2;
    _avatarImageView.layer.masksToBounds = 1;
    _avatarImageView.userInteractionEnabled = 1;
    [_headView addSubview:_avatarImageView];
    

    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_avatarImageView.frame) + 10, _avatarImageView.center.y - 15, 100, 30)];
    _nameLabel.text = @"UncleChar";
    [_nameLabel setTextColor:[UIColor blackColor]];
    [_headView  addSubview:_nameLabel];
    
    
    _signNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_avatarImageView.frame), CGRectGetMaxY(_avatarImageView.frame) + (CGRectGetMaxY(_headView.frame) - CGRectGetMaxY(_avatarImageView.frame)) / 2 - 15, 200, 30)];
    _signNameLabel.textColor = [UIColor colorWithRed:253.0/255 green:229.0/255 blue:29.0/255 alpha:1];
    _signNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kPersonalizedSignature];
    _signNameLabel.userInteractionEnabled = 1;
    [_headView addSubview:_signNameLabel];

    
    _titleListArray = @[@"数据库测试-[FMDB]", @"MyLocation", @"UserAccount", @"GifPlayer", @"IflyMSC", @"EaseMob", @"JPushChat",@"DeviceUUID",@"RichText",@"动态刷新cell"];
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_topBackgrooundImg.frame),self.view.frame.size.width, self.view.frame.size.height-_headView.frame.size.height - self.view.frame.size.height / 8) style:UITableViewStylePlain];
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    _listTableView.backgroundColor = [UIColor colorWithRed:30.0/255 green:200.0/255 blue:249.0/255 alpha:1];
    _listTableView.alpha = 0.6;
    [self.view addSubview:_listTableView];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height * 7 / 8, self.view.frame.size.width, self.view.frame.size.height  / 8)];
    _bottomView.backgroundColor = [UIColor colorWithRed:30.0/255 green:200.0/255 blue:100.0/255 alpha:1];
    _bottomView.alpha = 0.6;
    [self.view addSubview:_bottomView];

//    UIButton *exitBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 80, 40)];
//    exitBtn.backgroundColor = [UIColor whiteColor];
//    [exitBtn setTitle:@"Exit" forState:UIControlStateNormal];
//    [exitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    exitBtn.layer.cornerRadius = 6;
//    exitBtn.layer.masksToBounds = 1;
//    exitBtn.tag = 100 + 1;
//    [_bottomView addSubview:exitBtn];
//    [exitBtn addTarget:self action:@selector(exitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
   
}

- (void)addTargetWithTapGesture {

    //给头像增加点按手势
    UITapGestureRecognizer *tapGestureWithAvatar = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(elementAvatarImgClicked)];
    [_avatarImageView addGestureRecognizer:tapGestureWithAvatar];
    
    //给个性签名增加点按手势
    UITapGestureRecognizer *tapGestureWithName = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(elementNameLabelClicked)];
    [_signNameLabel addGestureRecognizer:tapGestureWithName];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _titleListArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentify = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (nil == cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = _titleListArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    AppBaseViewController *baseVC = [AppEngineManager sharedInstance].baseViewController;
    [baseVC baseControllerAppear];

    switch (indexPath.row) {
        case 0:
        {
        
            OperateDBViewController *vc = [[OperateDBViewController alloc]init];
            vc.navigationTitle = _titleListArray[indexPath.row];
            [baseVC.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 1:
        {
            LocationViewController *locationVC = [[LocationViewController alloc]init];
            [baseVC.navigationController pushViewController:locationVC animated:YES];
            
        }
            
            break;
        case 2:
        {
            ContactsSelectorViewController *locationVC = [[ContactsSelectorViewController alloc]init];
            [baseVC.navigationController pushViewController:locationVC animated:YES];
            
        }
            
            break;
        case 3:
        {
            GifPlayViewController *gifVC = [[GifPlayViewController alloc]init];
            [baseVC.navigationController pushViewController:gifVC animated:YES];
            
        }
            
            break;
        case 4:
        {
            VoiceRecognitionViewController *voiceVC = [[VoiceRecognitionViewController alloc]init];
            [baseVC.navigationController pushViewController:voiceVC animated:YES];
            
        }
            break;
        case 5:
        {

            EaseMobViewController *voiceVC = [[EaseMobViewController alloc]init];
            [baseVC.navigationController pushViewController:voiceVC animated:YES];
            
        }
            
            break;
        case 6:
            
        {
            
            JChatViewController *voiceVC = [[JChatViewController alloc]init];
            [baseVC.navigationController pushViewController:voiceVC animated:YES];
            
        }
            break;
        case 7:
            
        {
            
            DeviceUUIDViewController *voiceVC = [[DeviceUUIDViewController alloc]init];
            [baseVC.navigationController pushViewController:voiceVC animated:YES];
            
        }
        case 8:
            
        {
            
            RichTextEditorViewController *voiceVC = [[RichTextEditorViewController alloc]init];
            [baseVC.navigationController pushViewController:voiceVC animated:YES];
            
        }
            
        case 9:
            
        {
            
            DynamicShowViewController *voiceVC = [[DynamicShowViewController alloc]init];
            [baseVC.navigationController pushViewController:voiceVC animated:YES];
            
        }
        default:
            break;
    }
    
   
    
}

- (void)elementAvatarImgClicked {

    AppBaseViewController *baseVC = [AppEngineManager sharedInstance].baseViewController;
    [baseVC baseControllerAppear];
    
    RenewUserAvatarViewController *userSignVC = [[RenewUserAvatarViewController alloc]init];
//    userSignVC.signName = _signNameLabel.text;
    [baseVC.navigationController pushViewController:userSignVC animated:YES];
    
    
    
}

- (void)elementNameLabelClicked {

    NSLog(@"tap");
  
            AppBaseViewController *baseVC = [AppEngineManager sharedInstance].baseViewController;
            [baseVC baseControllerAppear];
            
            UserSignViewController *userSignVC = [[UserSignViewController alloc]init];
            userSignVC.signName = _signNameLabel.text;
            [baseVC.navigationController pushViewController:userSignVC animated:YES];
    
}


- (void)refreshUserAvatar {

    if (_avatarImageView) {
        
        if (nil == [AppEngineManager sharedInstance].leftViewElementsPath) {
            
            [[AppEngineManager sharedInstance] createSubDirectoryName:@"LeftElementsFile" underSuperDirectory:[AppEngineManager sharedInstance].dirDocument];
        }
        
        NSString *imageFilePath = [[AppEngineManager sharedInstance].leftViewElementsPath stringByAppendingPathComponent:@"/userAvatar.jpg"];
        _avatarImageView.image = [UIImage imageWithContentsOfFile:imageFilePath];
        
    }

}


- (void)refreshSignName {

    if (_signNameLabel) {
        
        if (nil == [[NSUserDefaults standardUserDefaults] objectForKey:kPersonalizedSignature]) {
            
            _signNameLabel.text = @"个性签名";
            
        }else {
            
            _signNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kPersonalizedSignature];
            
        }

    }
   
}




- (void)exitBtnClicked {

}

@end
