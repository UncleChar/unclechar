//
//  StartChatViewController.m
//  UncleCharDemos
//
//  Created by LingLi on 16/1/20.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "StartChatViewController.h"
#import <JMessage/JMSGUser.h>
#import <JMessage/JMSGMessage.h>
#import <JMessage/JMSGConversation.h>

@interface StartChatViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView       *inputBoxView;
@property (nonatomic, assign) CGFloat       inputBoxViewMinY;
@property (nonatomic, strong) UITextField  *inputTF;
@property (nonatomic, strong) UIImageView  *backIV;
@end

@implementation StartChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendMessageResponse:)
                                                 name:JMSGNotification_SendMessageResult object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMessageNotification:)
                                                 name:JMSGNotification_ReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow1:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide1:) name:UIKeyboardWillHideNotification object:nil];


    self.view.backgroundColor = [ConfigUITools colorRandomly];
    [self configChatRoomVCUI];
    JMSGUser *uu = [JMSGUser getMyInfo];
    NSLog(@"%@",uu.username);
    
    
    [[[JMSGConversation alloc]init] getMessage:@"tyyyyyy" completionHandler:^(id resultObject, NSError *error) {
        
       
        NSLog(@" messssssssss :%@",resultObject);
        
    }];
}

- (void)configChatRoomVCUI {

    _backIV = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_backIV];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _inputBoxView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40)];
    _inputBoxView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _inputBoxViewMinY = CGRectGetMinY(_inputBoxView.frame);
    [self.view addSubview:_inputBoxView];
    
    _inputTF = [[UITextField alloc]init];
    _inputTF.delegate = self;
    _inputTF.layer.cornerRadius = 6;
    _inputTF.layer.masksToBounds = 1;
    _inputTF.backgroundColor = [UIColor whiteColor];
    [_inputBoxView addSubview:_inputTF];
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addBtn addTarget:self action:@selector(sendMessageBtn) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"contacts_add@2x"] forState:UIControlStateNormal];
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

///键盘显示事件
- (void) keyboardWillShow1:(NSNotification *)notification {
    
    
    
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSLog(@"_inputBoxViewMinY%f",_inputBoxViewMinY);
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

        
        if (_inputBoxViewMinY + 40 > kScreenHeight -  kbHeight) {
            
            //            if (kbHeight) {
            //                <#statements#>
            //            }
            NSLog(@"bbbbb");
            [UIView animateWithDuration:duration animations:^{
                
                _inputBoxView.frame = CGRectMake(0, _inputBoxViewMinY -((_inputBoxViewMinY + 40) - (kScreenHeight -  kbHeight)), kScreenWidth, 40);


                
            }];
            
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




- (BOOL)textFieldShouldReturn:(UITextField *)textField {

//    
//    + (void)sendMessage:(JMSGMessage *)message;
//    JMSGMessage *message =  [[JMSGMessage alloc]init];
//    message.targetId = @"tyyyyyy";
//     JMSGContentMessage *contentMessage = [JMSGMessage];
//    message.co
//    JMSGMessage sendMessage:<#(JMSGMessage *)#>
//    _inputTF.text;
    

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//    });
    return YES;
}

- (void)sendMessageResponse:(NSNotification *)response {

    NSDictionary *responseDic = [response userInfo];
    JMSGMessage *message = responseDic[JMSGSendMessageObject];
    NSError *error = responseDic[JMSGSendMessageError];


    NSLog(@"haole %@",response);
}



- (void)sendMessageBtn {

    JMSGContentMessage *message = [[JMSGContentMessage alloc]init];
    message.contentText = _inputTF.text;
    JMSGMessage *sendMessage =  (JMSGMessage *)message;
    sendMessage.targetId = @"123456";
    
    [JMSGMessage sendMessage:sendMessage];
    
}
- (void)receiveMessageNotification:(NSNotification *)noti {

    JMSGUser *user = [JMSGUser getMyInfo];
    NSDictionary *userInfo = [noti userInfo];
    JMSGMessage *message = (JMSGMessage *)(userInfo[JMSGNotification_MessageKey]);
    JMSGContentMessage *contentMessage =  (JMSGContentMessage *)message;
    NSLog(@"kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk%@",contentMessage.contentText);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 100, kScreenHeight, 200, 40)];
    label.text = contentMessage.contentText;
    label.backgroundColor = [ConfigUITools colorRandomly];
    [self.view addSubview:label];

    [UIView animateWithDuration:4 animations:^{
        
        label.frame = CGRectMake(kScreenWidth / 2 - 100, kScreenHeight - 200, 200, 40);

    } completion:^(BOOL finished) {
        
        [label removeFromSuperview];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
