//
//  ChatRoomViewController.m
//  UncleCharDemos
//
//  Created by LingLi on 16/1/8.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "ChatRoomViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UserTestModel.h"
#define kPicScrollerHeight 200
@interface ChatRoomViewController ()
{
    
    ALAssetsLibrary *library;
    
    
    NSMutableArray *mutableArray;
    
    UIScrollView   *picScrollView;
    BOOL            topPic;
    NSArray  *imageArray;
    BOOL     isOnce;
    
}
@property (nonatomic, strong) UIView       *inputBoxView;
@property (nonatomic, assign) CGFloat       inputBoxViewMinY;
@property (nonatomic, strong) UITextField  *inputTF;
@property (nonatomic, strong) UIImageView  *backIV;

@end

@implementation ChatRoomViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = 0;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow1:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide1:) name:UIKeyboardWillHideNotification object:nil];

    
    [self configChatRoomVCUI];
    
    
}


- (void)configChatRoomVCUI {
    
    

    _backIV = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_backIV];
    
    self.title = self.chatRoomTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _inputBoxView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40)];
    _inputBoxView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _inputBoxViewMinY = CGRectGetMinY(_inputBoxView.frame);
    [self.view addSubview:_inputBoxView];
    
    _inputTF = [[UITextField alloc]init];
    _inputTF.layer.cornerRadius = 6;
    _inputTF.layer.masksToBounds = 1;
    _inputTF.backgroundColor = [UIColor whiteColor];
    [_inputBoxView addSubview:_inputTF];
    

    picScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)];
    picScrollView.backgroundColor = [ConfigUITools colorRandomly];
    [self.view addSubview:picScrollView];
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addBtn addTarget:self action:@selector(addPic) forControlEvents:UIControlEventTouchUpInside];
//    [addBtn setBackgroundImage:[UIImage imageNamed:@"contacts_add@2x"] forState:UIControlStateNormal];
    [_inputBoxView addSubview:addBtn];
    
    
    [_inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_inputBoxView.mas_left).with.offset(10);
        make.top.equalTo(_inputBoxView.mas_top).with.offset(5);
        make.bottom.equalTo(_inputBoxView.mas_bottom).with.offset(-5);
        make.right.equalTo(addBtn.mas_left).with.offset(-5);
        
    }];
    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_inputTF.mas_right).with.offset(5);
        make.top.equalTo(_inputBoxView.mas_top).with.offset(2);
        make.bottom.equalTo(_inputBoxView.mas_bottom).with.offset(-2);
        make.right.equalTo(_inputBoxView.mas_right).with.offset(-5);
        make.width.equalTo(@(36));
        
    }];
    
    
    
}


#pragma mark - keyboard events

///键盘显示事件
- (void) keyboardWillShow1:(NSNotification *)notification {
    
    
    
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSLog(@"_inputBoxViewMinY%f",_inputBoxViewMinY);
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (topPic) {
        
        if (_inputBoxViewMinY + 40 > kScreenHeight -  kbHeight) {
           
//            if (kbHeight) {
//                <#statements#>
//            }
            NSLog(@"bbbbb");
            [UIView animateWithDuration:0.1 animations:^{

                _inputBoxView.frame = CGRectMake(0, _inputBoxViewMinY -((_inputBoxViewMinY + 40) - (kScreenHeight -  kbHeight)), kScreenWidth, 40);
                picScrollView.hidden = YES;
                topPic = NO;
                
            }];
            
        }

        
    }else {
    

        
          if (kbHeight > 0) {
        [UIView animateWithDuration:duration animations:^{

            _inputBoxView.frame = CGRectMake(0, _inputBoxViewMinY - kbHeight, kScreenWidth, 40);
            
        }];
        
    }
    }

    //注明：这里不需要移除通知
}

- (void) keyboardWillHide1:(NSNotification *)notify {
    CGFloat kbHeight = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    NSLog(@"hidenheight%f",kbHeight);
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{

         _inputBoxView.frame = CGRectMake(0, _inputBoxViewMinY, kScreenWidth, 40);
    }];
}






- (void)addPic {
    

    imageArray = [[NSMutableArray alloc]init];
    NSArray *allDataArray = [NSArray array];
    allDataArray = [[DBManager sharedDBManager] allDataWithTableName:@"UserInfo"];
    imageArray = (NSMutableArray *)allDataArray;


    topPic = YES;
    [_inputTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        
        _inputBoxView.frame = CGRectMake(0, kScreenHeight - 240, kScreenWidth, 40);
        picScrollView.frame = CGRectMake(0, kScreenHeight - 200, kScreenWidth, 200);

        
    }];
    
    [self allPhotosCollected:imageArray];
        

    
}

-(void)allPhotosCollected:(NSArray*)imgArray

{
    
    //write your code here after getting all the photos from library...
    
//    NSLog(@"all pictures are %@",imgArray);
    
  
    if (isOnce) {
        
        picScrollView.hidden = NO;
        
    }else {
    
    
        isOnce = YES;
        CGFloat length = 1;
        CGFloat margin = 5;
        for (UserTestModel *model in imgArray) {
            UIImageView *iv = [[UIImageView alloc]init];
            iv.image = [UIImage imageWithData:model.biggerData];
            
            CGFloat ratio = iv.image.size.width / iv.image.size.height;
            
            if (iv.image.size.height >= kPicScrollerHeight - 2 * margin) {
                
                iv.frame = CGRectMake(length, margin, ratio * (kPicScrollerHeight - 2 * margin), (kPicScrollerHeight - 2 * margin));
                
            }else {
                
                iv.frame = CGRectMake(length, kPicScrollerHeight / 2.0 - iv.image.size.height / 2.0, iv.image.size.width, iv.image.size.height);
                
            }
            
            length = CGRectGetMaxX(iv.frame) + margin;
            [picScrollView addSubview:iv];
            
//            NSLog(@"%@",NSStringFromCGSize(iv.image.size));
            
        }
        picScrollView.contentSize = CGSizeMake(length, kPicScrollerHeight);
    
    }
    
}




- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

   [_inputTF resignFirstResponder];
    
    topPic = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _inputBoxView.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
        picScrollView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 200);

    }];
    
}


@end
