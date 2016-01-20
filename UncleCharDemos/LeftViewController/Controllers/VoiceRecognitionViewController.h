//
//  VoiceRecognitionViewController.h
//  UncleCharDemos
//
//  Created by LingLi on 16/1/7.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"

@class IFlyDataUploader;
@class IFlySpeechSynthesizer;
@class IFlySpeechRecognizer;
@interface VoiceRecognitionViewController : UIViewController


@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;

@end
