//
//  GifPlayViewController.m
//  UncleCharDemos
//
//  Created by LingLi on 16/1/6.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "GifPlayViewController.h"

#import "YFGIFImageView.h"

#define kMargin 2
#define kGifHeightAndWidth 28
@implementation GifPlayViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = 0;
    
}

- (void)viewDidLoad {

    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = 0;
    
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(gifVCItemBtnClicked:)];
    leftItem.image = [UIImage imageNamed:@"left@2x"];
    leftItem.tag = 3000 + 1;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(gifVCItemBtnClicked:)];
    rightItem.title = @"TestAgain";
    rightItem.tag = 3000 + 2;
    self.navigationItem.rightBarButtonItem = rightItem;

    _gifScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _gifScrollView.backgroundColor = [ConfigUITools colorRandomly];
    [self.view addSubview:_gifScrollView];

    [self presentAlert];
    
    

    
}

-(void)configGifScrollViewWithWidth:(NSInteger)width {

    //列
    NSInteger row  = self.view.frame.size.width / width;
    NSInteger line = 0;
    NSInteger gifMargin = (self.view.frame.size.width - row * width)/(row + 1);
    if (100 % row == 0) {
        
        line = 100 / row;
        
    }else {
        
        line = 100 / row + 1;
        
    }
    
    long countGif;
    
    countGif = 0;
    if (nil == _gifViewArray) {
        
        _gifViewArray = [NSMutableArray arrayWithCapacity:0];
    }else {
    
        [_gifViewArray removeAllObjects];
    }
    
    for (int i = 0; i < line; i ++) {
        
        for (int j = 0; j < row ; j ++) {
            
            countGif ++;
            
            if (countGif >= 101) {
                
            }else {
                
                NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%03ld@2x.gif",countGif] ofType:nil]];
                YFGIFImageView *view = [[YFGIFImageView alloc]initWithFrame:CGRectMake( gifMargin + j *  (gifMargin + width) , gifMargin + i *(gifMargin + width) , width, width)];
                view.backgroundColor = [UIColor whiteColor];
                view.gifData = gifData;
                [_gifScrollView addSubview:view];
                [_gifViewArray addObject:view];
                [view startGIF];
                
            }
            
            
        }
        
    }
    
    _gifScrollView.contentSize = CGSizeMake(self.view.frame.size.width, (gifMargin + width) * line +gifMargin );
    
}


- (void)presentAlert {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GIF的尺寸" message:@"默认是 28 * 28 " preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"Gif是正方形,输入宽或高";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *widthTF = alertController.textFields.firstObject;
        if ([widthTF.text isEqualToString:@""]) {
            
            [self configGifScrollViewWithWidth:28];
        }
        [self configGifScrollViewWithWidth:[widthTF.text integerValue]];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"默认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self configGifScrollViewWithWidth:28];
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];

}

- (void)gifVCItemBtnClicked:(UIBarButtonItem *)item {

    
    switch (item.tag - 3000) {
        case 1:
        {
            for (YFGIFImageView *gifView in _gifViewArray) {
                
                [gifView removeFromSuperview];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
            break;
        case 2:
        {
            for (YFGIFImageView *gifView in _gifViewArray) {
                
                [gifView removeFromSuperview];
            }
            [self presentAlert];
        }
            break;
            
        default:
            break;
    }
    
   }
@end
