//
//  VoiceRecognitionViewController.m
//  UncleCharDemos
//
//  Created by LingLi on 16/1/7.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "VoiceRecognitionViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "iflyMSC/IFlySpeechError.h"

@interface VoiceRecognitionViewController ()<IFlySpeechSynthesizerDelegate,IFlySpeechRecognizerDelegate>
{

    
}
@property (nonatomic, strong) UITextField *voiceContentTF;
@end

@implementation VoiceRecognitionViewController


-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = 0;
    
}

- (void)viewDidLoad {

    [super viewDidLoad];
    

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(VoiceBackBtn)];
    leftItem.image = [UIImage imageNamed:@"left@2x"];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"568dbd44"];
    [IFlySpeechUtility createUtility:initString];
    
    self.view.backgroundColor = [ConfigUITools colorRandomly];
    
    _voiceContentTF = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, 90, 200, 60)];
    _voiceContentTF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_voiceContentTF];
    
    UIButton *startBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 190, 100, 60)];
    startBtn.backgroundColor = [ConfigUITools colorRandomly];
    [startBtn setTitle:@"VoiceStart" forState:UIControlStateNormal];
    [self.view addSubview:startBtn];
    [startBtn addTarget:self action:@selector(startBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self configIfly];
    
}

- (void)configIfly {

    //1.创建语音听写对象
    _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance]; //设置听写模式
    [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    //2.设置听写参数
    [_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path是录音文件名,设置value为nil或者为空取消保存,默认保存目录在 Library/cache下。
    [_iFlySpeechRecognizer setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
  
}


- (void)startBtnClicked:(UIButton *)sender {

      [_iFlySpeechRecognizer startListening];
    //启动合成会话
//    [_iFlySpeechSynthesizer startSpeaking:self.voiceContentTF.text];
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.voiceContentTF resignFirstResponder];
}



//4. IFlySpeechRecognizerDelegate识别代理
/*识别结果返回代理
 @param :results识别结果
 @ param :isLast 表示是否最后一次结果
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{}
/*识别会话结束返回代理
 @ param error 错误码,error.errorCode=0表示正常结束,非0表示发生错误。 */
- (void)onError: (IFlySpeechError *) error{
}
/**
 停止录音回调
 ****/
- (void) onEndOfSpeech {}
/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech {}
/**
 音量回调函数 volume 0-30 ****/
- (void) onVolumeChanged: (int)volume {
}
- (void)VoiceBackBtn {

    [self.navigationController popViewControllerAnimated:YES];
}

@end
