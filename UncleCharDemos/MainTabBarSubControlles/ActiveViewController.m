//
//  ActiveViewController.m
//  ReconstructionQQSlide
//
//  Created by LingLi on 15/12/24.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import "ActiveViewController.h"
#import "SoundManager.h"

@interface ActiveViewController ()
{

    UIBarButtonItem *rightItem;
}
@end

@implementation ActiveViewController
- (void)viewWillAppear:(BOOL)animated {
    
//    NSLog(@"ACTIVE");
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ConfigUITools colorRandomly];
    self.navigationItem.title = @"Music-->";
    rightItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(presentMenuButtonTapped:)];
    rightItem.image = [UIImage imageNamed:@"yinyue_icon_music@2x"];
    rightItem.tag = 100;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [SoundManager sharedManager].allowsBackgroundMusic = YES;
    [[SoundManager sharedManager] prepareToPlay];
    
}

- (void)presentMenuButtonTapped:(UIButton *)sender {
    
    if (sender.tag == 100) {
        [[SoundManager sharedManager] playSound:@"Nightwish - The Crow, the Owl and the Dove - Radio Edit.mp3" looping:YES];
        rightItem.tag = 101;
    }else {
        
        [[SoundManager sharedManager] stopAllSounds];
        rightItem.tag = 100;
    }
    
    
}
@end
