//
//  RenewUserAvatarViewController.m
//  UncleCharDemos
//
//  Created by LingLi on 15/12/28.
//  Copyright © 2015年 hailong.xie. All rights reserved.
//

#import "RenewUserAvatarViewController.h"
#import "LoginViewController.h"
#import "LeftViewController.h"
#import "UncleCharAppDelegate.h"



@interface RenewUserAvatarViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic, strong) UIImageView *userAvatar;
@property(nonatomic, strong) NSData *fileData;


@property (nonatomic, strong) UITextField  *userAccount;
@property (nonatomic, strong) UITextField  *userPassword;
//@property (nonatomic, strong) UITextField  *userPhone;
//@property (nonatomic, strong) UITextField  *userEmail;

@property (nonatomic, strong) UITextField  *firstResponderTF;
@property (nonatomic, strong) UIButton     *loginBtn;
@property (nonatomic, strong) UIButton     *registerBtn;
@property (nonatomic, strong) UIView       *baseView;

@property (nonatomic, strong) UIImageView    *loginHeadImg;

@property (nonatomic, assign) CGFloat       btnMaxY;


@end
@implementation RenewUserAvatarViewController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ConfigUITools colorRandomly];
    self.userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50 , 100, 100, 100)];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"修改头像" style:UIBarButtonItemStylePlain target:self action:@selector(takePictureClick:)];
    self.navigationItem.rightBarButtonItem = left;
    [self.view addSubview:self.userAvatar];

    if (nil == [AppEngineManager sharedInstance].leftViewElementsPath) {
        
        [[AppEngineManager sharedInstance] createSubDirectoryName:kAvatarImgFloderName underSuperDirectory:[AppEngineManager sharedInstance].dirDocument];
            NSLog(@"headImageFile-->%@",[AppEngineManager sharedInstance].leftViewElementsPath);
    }

    NSString *imageFilePath = [[AppEngineManager sharedInstance].leftViewElementsPath stringByAppendingPathComponent:@"/userAvatar.jpg"];

    
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//
    self.userAvatar.image = selfPhoto;
    [self.userAvatar.layer setCornerRadius:CGRectGetHeight([self.userAvatar bounds]) / 2];
    self.userAvatar.layer.masksToBounds = YES;
    
    
    UIButton *exitBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, self.view.frame.size.height - 80, 200, 40)];
    exitBtn.backgroundColor = [UIColor redColor];
    [exitBtn setTitle:@"Exit login" forState:UIControlStateNormal];
    exitBtn.titleLabel.textAlignment = 1;
    [exitBtn setTitleColor:[ConfigUITools colorRandomly] forState:UIControlStateNormal];
    exitBtn.layer.cornerRadius = 5;
    exitBtn.layer.masksToBounds = 1;
    exitBtn.tag = 100 + 1;
    [self.view addSubview:exitBtn];
    [exitBtn addTarget:self action:@selector(exitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    

}
//从相册获取图片
-(void)takePictureClick:(UIButton *)sender
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择头像来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self presentViewController:alert animated:YES completion:nil];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *localAction = [UIAlertAction actionWithTitle:@"本地相簿" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cameraAction];
    [alert addAction:localAction];
    [alert addAction:cancelAction];

}

#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {

    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *imageFilePath = [[AppEngineManager sharedInstance].leftViewElementsPath stringByAppendingPathComponent:@"/userAvatar.jpg"];

    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(100, 100)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    self.userAvatar.image = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)exitBtnClicked {
    
    
        NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
        [store setBool:NO forKey:kUserLoginStatus];
        [store synchronize];


    for (UIView *subView in self.view.subviews) {
        
        [subView removeFromSuperview];
        
    }
    
    [self configLoginViews];
    
}

//#pragma mark -
//#pragma mark UIImagePickerControllerDelegate methods
////完成选择图片
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
//{
//    //加载图片
//    self.img.image = image;
//    //选择框消失
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
////取消选择图片
//-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (IBAction)cameraBtn:(id)sender
//
//{
//
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//
//    imagePicker.delegate = self;
//
//    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//获取类型是摄像头，还可以是相册
//
//    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//
//    imagePicker.allowsEditing = NO;//如果为NO照出来的照片是原图，比如4s和5的iPhone出来的尺寸应该是（2000+）*（3000+），差不多800W像素，如果是YES会有个选择区域的方形方框
//
//    //    imagePicker.showsCameraControls = NO;//默认是打开的这样才有拍照键，前后摄像头切换的控制，一半设置为NO的时候用于自定义ovelay
//
////    UIImageView *overLayImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
////    overLayImg.image = [UIImage imageNamed:@"overlay.png"];
//
////    imagePicker.cameraOverlayView = overLayImg;//3.0以后可以直接设置cameraOverlayView为overlay
////    imagePicker.wantsFullScreenLayout = YES;
//
//    [self presentModalViewController:imagePicker animated:YES];
//
//}


//
//- (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize
//{
//    UIImage *newimage;
//    if (nil == image) {
//        newimage = nil;
//    }
//    else{
//        UIGraphicsBeginImageContext(asize);
//        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
//        newimage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }
//    return newimage;
//}
//
//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}



- (void)configLoginViews {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.navigationController.navigationBarHidden = 1;
    _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, - self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    _baseView.alpha = 0.0;
    [self.view addSubview:_baseView];
    
    _loginHeadImg = [[UIImageView alloc]init];
    _loginHeadImg.image = [UIImage imageNamed:@"head_login.jpg"];
    _loginHeadImg.layer.cornerRadius = 6;
    _loginHeadImg.layer.masksToBounds = 1;


    
    _userAccount = [[UITextField alloc]init];
    _userAccount.borderStyle = UITextBorderStyleRoundedRect;
    _userAccount.backgroundColor = [UIColor whiteColor];
    _userAccount.placeholder = @"Account";
    _userAccount.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _userPassword = [[UITextField alloc]init];
    _userPassword.borderStyle = UITextBorderStyleRoundedRect;
    _userPassword.backgroundColor = [UIColor whiteColor];
    _userPassword.placeholder = @"Password";
    _userPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userPassword.secureTextEntry = YES;
    
    _registerBtn = [[UIButton alloc]init];
    _registerBtn.backgroundColor = [ConfigUITools colorRandomly];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    _registerBtn.layer.cornerRadius = 6;
    _registerBtn.layer.masksToBounds = 1;
    _registerBtn.tag = 100 + 0;
    
    
    _loginBtn = [[UIButton alloc]init];
    _loginBtn.backgroundColor = [ConfigUITools colorRandomly];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius = 6;
    _loginBtn.layer.masksToBounds = 1;
    _loginBtn.tag = 100 + 1;
    
    
    
    [_baseView addSubview:_loginHeadImg];
    [_baseView addSubview:_userAccount];
    [_baseView addSubview:_userPassword];
    [_baseView addSubview:_registerBtn];
    [_baseView addSubview:_loginBtn];
    

    __weak typeof(self) weakSelf = self;
    int padding = 20;
    
    [_loginHeadImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(_baseView.mas_centerX);
        make.left.equalTo(_baseView.mas_left).with.offset(_baseView.frame.size.width / 7);
        make.right.equalTo(_baseView.mas_right).with.offset(- _baseView.frame.size.width / 7);
        make.bottom.equalTo(_userAccount.mas_top).with.offset(- padding);
        make.top.equalTo(_baseView.mas_top).with.offset(_baseView.frame.size.height / 10);
        make.height.mas_equalTo(@(weakSelf.view.frame.size.width / 7 * 5 /(820.0/470.0)));
        
        
    }];
    
    [_userAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_baseView.mas_centerX);
        make.left.equalTo(_baseView.mas_left).with.offset(padding);
        make.right.equalTo(_baseView.mas_right).with.offset(-padding);
        make.bottom.equalTo(_userPassword.mas_top).with.offset(- 1.5 * padding);
        make.top.equalTo(_loginHeadImg.mas_bottom).with.offset(padding);
        make.height.mas_equalTo(@40);
        make.width.equalTo(_userPassword);
    }];
    [_userPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_baseView.mas_centerX);
        make.left.equalTo(_baseView.mas_left).with.offset(padding);
        make.right.equalTo(_baseView.mas_right).with.offset(-padding);
        make.top.equalTo(_userAccount.mas_bottom).with.offset(1.5 * padding);
        make.height.mas_equalTo(@40);
        make.width.equalTo(_userAccount);
    }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userPassword.mas_left).with.offset(padding);
        make.top.equalTo(_userPassword.mas_bottom).with.offset(1.5 *padding);
        make.right.equalTo(_loginBtn.mas_left).with.offset(-padding);
        make.height.mas_equalTo(@40);
        make.width.equalTo(_loginBtn);
        
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_registerBtn.mas_right).with.offset(padding);
        make.top.equalTo(_userPassword.mas_bottom).with.offset(1.5 * padding);
        make.right.equalTo(_userPassword.mas_right).with.offset(-padding);
        make.height.mas_equalTo(@40);
        make.width.equalTo(_registerBtn);
        
    }];
    
    
    [UIView animateWithDuration:1.5 animations:^{
        
        _baseView.alpha = 1.0;
        _baseView.frame = self.view.frame;
        
    } completion:^(BOOL finished) {

        [_registerBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }];

    
}


- (void)loginBtnClicked:(UIButton *)sender {
    
    switch (sender.tag - 100) {
        case 0:
        {
        
            
        }
            break;
        case 1:
        {
            [self.view endEditing:YES];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showWithStatus:@"Logging..."];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                [NSThread sleepForTimeInterval:2];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([_userAccount.text isEqualToString:@"123456"] && [_userPassword.text isEqualToString:@"123456"]) {
                        
                        UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:[AppEngineManager sharedInstance].baseViewController];
                        [UncleCharAppDelegate getUncleCharAppDelegateDelegate].window.rootViewController = rootNav;
                        
                        NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
                        [store setBool:YES forKey:kUserLoginStatus];
                        [store synchronize];
                        
                    }else {
                        
                        [SVProgressHUD showErrorWithStatus:@"Account or password error"];
                        
                    }
                    
                });
            });
            
        }
            
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark - keyboard events

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    
    
    
    _btnMaxY = CGRectGetMaxY(_loginBtn.frame);
    
    
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if(_btnMaxY >(self.view.frame.size.height - kbHeight)) {
        
        [UIView animateWithDuration:duration + 0.3 animations:^{
            
            _baseView.frame = CGRectMake(_baseView.frame.origin.x,-( _btnMaxY - (self.view.frame.size.height - kbHeight) + 10), _baseView.frame.size.width, _baseView.frame.size.height);
            
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}


@end
