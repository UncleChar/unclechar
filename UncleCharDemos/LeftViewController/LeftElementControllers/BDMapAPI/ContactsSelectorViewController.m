//
//  ContactsSelectorViewController.m
//  UncleCharDemos
//
//  Created by LingLi on 16/1/5.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "ContactsSelectorViewController.h"
#import "DivideContactsViewController.h"

#import "UserModel.h"
#import "GroupModel.h"

@interface ContactsSelectorViewController ()

@property (nonatomic, strong) UITextField *userAccount;
@property (nonatomic, strong) UITextField *userPassword;
@property (nonatomic, strong) UITextField *userPhone;
@property (nonatomic, strong) UITextField *userEmail;

@property (nonatomic, strong) NSMutableArray *userModelArr;
@property (nonatomic, strong) NSMutableArray *grouprModelArr;


@end

@implementation ContactsSelectorViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = 0;
//    self.navigationController.hidesBarsWhenKeyboardAppears = YES;
    
}
- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.view.backgroundColor = [ConfigUITools colorRandomly];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self configNavItems];
    
    [self configContactsVCUI];
    
    [self handleContactsData];
    
    
}

- (void)configNavItems {

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(contactBackBtn)];
    leftItem.image = [UIImage imageNamed:@"left@2x"];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(addContanctsBtnClicked)];
    rightItem.image = [UIImage imageNamed:@"contact_add_btnNormal@2x"];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
}

- (void)configContactsVCUI {


     _baseView = [[UIView alloc]initWithFrame:self.view.frame];
//    _baseView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_baseView];
     _userAccount = [[UITextField alloc]init];
     _userAccount.borderStyle = UITextBorderStyleRoundedRect;
     _userAccount.backgroundColor = [UIColor whiteColor];
    
     _userPassword = [[UITextField alloc]init];
     _userPassword.borderStyle = UITextBorderStyleRoundedRect;
     _userPassword.backgroundColor = [UIColor whiteColor];
    
     _userPhone = [[UITextField alloc]init];
     _userPhone.borderStyle = UITextBorderStyleRoundedRect;
     _userPhone.backgroundColor = [UIColor whiteColor];
    
     _userEmail = [[UITextField alloc]init];
     _userEmail.borderStyle = UITextBorderStyleRoundedRect;
     _userEmail.backgroundColor = [UIColor whiteColor];
    
    [_baseView addSubview:_userPhone];
    [_baseView addSubview:_userPassword];
    [_baseView addSubview:_userEmail];
    [_baseView addSubview:_userAccount];
    
//    __weak typeof(self) weakSelf = self;
    int padding1 = 20;
    
//    [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.edges.equalTo(weakSelf.view).width.insets(UIEdgeInsetsMake(0, padding1, padding1, padding1));
//        
//    }];
    
    
    
    [_userAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_baseView.mas_centerX);
        make.left.equalTo(_baseView.mas_left).with.offset(padding1);
        make.right.equalTo(_baseView.mas_right).with.offset(-padding1);
        make.bottom.equalTo(_userPassword.mas_top).with.offset(- padding1);
        make.top.equalTo(_baseView.mas_top).with.offset(10 * padding1);
        make.height.mas_equalTo(@40);
        make.width.equalTo(_userPassword);
    }];
    [_userPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_baseView.mas_centerX);
        make.left.equalTo(_baseView.mas_left).with.offset(padding1);
        make.right.equalTo(_baseView.mas_right).with.offset(-padding1);
        make.top.equalTo(_userAccount.mas_bottom).with.offset(padding1);
        make.height.mas_equalTo(@40);
        make.width.equalTo(_userAccount);
    }];
    
    [_userEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_baseView.mas_centerX);
        make.left.equalTo(_baseView.mas_left).with.offset(padding1);
        make.right.equalTo(_baseView.mas_right).with.offset(-padding1);
        make.top.equalTo(_userPassword.mas_bottom).with.offset(padding1);
        make.height.mas_equalTo(@40);
        make.width.equalTo(_userPassword);
    }];
    [_userPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_baseView.mas_centerX);
        make.left.equalTo(_baseView.mas_left).with.offset(padding1);
        make.right.equalTo(_baseView.mas_right).with.offset(-padding1);
        make.top.equalTo(_userEmail.mas_bottom).with.offset(padding1);
        make.height.mas_equalTo(@40);
        make.width.equalTo(_userPassword);
    }];
    
    UIImageView *avatarImg = [[UIImageView alloc]initWithFrame:CGRectMake(4, 2, 36, 36)];
    avatarImg.image = [UIImage imageNamed:@"one_avatar@2x"];
    _userAccount.leftViewMode = UITextFieldViewModeAlways;
    _userAccount.leftView = avatarImg;
    
    //添加观察者 这个第三方的额效果并不好。自己实现了方法在下面
//            [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];

    

    
   
}


- (void)handleContactsData {

    
    if (nil == _userModelArr) {
        
        _userModelArr = [NSMutableArray array];
    }
    
    if (nil == _grouprModelArr) {
        
        _grouprModelArr = [NSMutableArray array];
    }

    
    ///--------groupModel 货值-----------------

            
    
    
    for (int i = 0; i < 5; i ++) {
        
        GroupModel *gmodel = [[GroupModel alloc]init];
        gmodel.userModelArrWithGroup = [NSMutableArray array];
        gmodel.group_name = [NSString stringWithFormat:@"rose_%d",i];
        if (i % 3 == 0) {
            
            gmodel.invited = 1;
        }else {
        
            gmodel.invited = 0;
        }
 
        int k = arc4random() % 8 + 1;
        for (int j = 0;j < k ; j ++) {
            UserModel *model = [[UserModel alloc]init];
            
            model.avatar = @"http://b.zol-img.com.cn/desk/bizhi/image/1/960x600/13479490300.jpg";
            model.real_name = [NSString stringWithFormat:@"问ijack_%d",i];
            model.phone = [NSString stringWithFormat:@"1%ld",random() % 1000000000];
            [gmodel.userModelArrWithGroup addObject: model];
            
        }
        
        [_grouprModelArr addObject:gmodel];
        NSLog(@"%@,%ld",gmodel.group_name,gmodel.userModelArrWithGroup.count);
    }
    

    
    ///--------userModel 货值-----------------
    NSArray *arr =  @[@"张飞 No.1 StinCN.",
                      @"卢布 Valoran",
                      @"吕布 Noxus",
                      @"前程司机 ",
                      @"布拉德皮特 PT",
                      @"战争学院 The Institute of War",
                      @"祖安 Zaun",
                      @"巫毒之地 Voodoo Lands",
                      @"水晶之痕 Crystal Scar",
                      @"ss",
                      @"Chambers",
                      @"试炼之地Proving Grounds",
                      @"扭曲丛林 Twisted Treeline"];
    
    for(int i = 0;i < 25;i ++){
    
        UserModel *model = [[UserModel alloc]init];

        model.avatar = @"http://b.zol-img.com.cn/desk/bizhi/image/1/960x600/13479490300.jpg";
         model.phone = [NSString stringWithFormat:@"Tel:1%ld",random() % 10000000000];
        if (i % 3 == 0) {
            
            model.invited = 1;
            model.sex = 0;
            model.real_name = arr[i / 3];
        }else {
        
            model.invited = 0;
            model.sex = 1;
            model.real_name = [NSString stringWithFormat:@"dsfnsiug_%d",i];
        }
        [_userModelArr addObject:model];
        
    }
    
    

}

- (void)addContanctsBtnClicked {

    DivideContactsViewController *divideVC = [[DivideContactsViewController alloc]init];
    divideVC.usersModelArray = _userModelArr;
    divideVC.groupsModelArray = _grouprModelArr;
    divideVC.catchBlock = ^(NSMutableArray *modelsArray){
    
        NSLog(@"model %@",modelsArray);
    };
    [self.navigationController pushViewController:divideVC animated:YES];
    
}

- (void)contactBackBtn {

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - keyboard events

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    
    
    
    if ([_userAccount isFirstResponder]) {
        
        _firstResponderTFMaxY = CGRectGetMaxY(_userAccount.frame);
        _firstResponderTF = _userAccount;
    }
    if ([_userPassword isFirstResponder]) {
        
        _firstResponderTFMaxY = CGRectGetMaxY(_userPassword.frame);
        _firstResponderTF = _userPassword;
    }
    if ([_userEmail isFirstResponder]) {
        
        _firstResponderTFMaxY = CGRectGetMaxY(_userEmail.frame);
         _firstResponderTF = _userEmail;
    }
    if ([_userPhone isFirstResponder]) {
        
        _firstResponderTFMaxY = CGRectGetMaxY(_userPhone.frame);
         _firstResponderTF = _userPhone;
    }
    
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
 
    if(_firstResponderTFMaxY >(self.view.frame.size.height - kbHeight)) {

        [UIView animateWithDuration:duration + 0.3 animations:^{
           
            _baseView.frame = CGRectMake(_baseView.frame.origin.x,-( _firstResponderTFMaxY - (self.view.frame.size.height - kbHeight) + 10), _baseView.frame.size.width, _baseView.frame.size.height);

        }];
    }
    //注明：这里不需要移除通知
}

- (void) keyboardWillHide:(NSNotification *)notify {

    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration + 0.3 animations:^{
        _baseView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

@end
