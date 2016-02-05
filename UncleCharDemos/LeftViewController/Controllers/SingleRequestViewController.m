//
//  SingleRequestViewController.m
//  UncleCharDemos
//
//  Created by LingLi on 16/2/4.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "SingleRequestViewController.h"
#import "RequestModel.h"
#import "FMDB.h"
@interface SingleRequestViewController ()
@property (nonatomic, strong) UIProgressView *ProgressView;
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) ASIHTTPRequest *request;
@end

@implementation SingleRequestViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = 0;
    //    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [_db open];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(addRequestModel)];
    rightItem.title = @"请求下载";
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(backRequestModel)];
    rightItem.title = @"back";
    self.navigationItem.leftBarButtonItem = leftItem;
    
   _ProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(56, 100, kScreenWidth - 60, 20)];
    [self.view addSubview:_ProgressView];
    
    RequestModel *model =[[DBManager sharedDBManager] searchDBDataWithModelID:@"123456" withTableName:@"RequestInfo"];
    if (nil == model) {
        
        
    }else {
        

        
        
        
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:model.requestUrl] usingCache:ASICacheForSessionDurationCacheStoragePolicy];

        [request setQueuePriority:NSOperationQueuePriorityNormal];
        _request = request;
        [request setDelegate:self];
        
  
        //设置是是否支持断点下载
        [request setAllowResumeForFileDownloads:YES];
        
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
        
//        model.request = request;
        
//        [[DBManager sharedDBManager] insertDBWithData:model forTableName:@"RequestInfo"];
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addRequestModel {

    RequestModel *model = [[RequestModel alloc]init];
    
    model.requestID = @"123456"; //唯一ID
    model.requestUrl = @"http://youtui.oss-cn-hangzhou.aliyuncs.com/download/ios/youtuiShare-ios-v1.1.1.zip";
    
    
    
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:model.requestUrl]];
    [request setValidatesSecureCertificate:NO];   //-----https
    [request setQueuePriority:NSOperationQueuePriorityNormal];
    _request = request;
    [request setDelegate:self];
    
//    NSURL *url = [NSURL URLWithString:filePath];
//    //设置下载路径
//    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];

    //初始化保存ZIP文件路径
    NSString *savePath = [[AppEngineManager sharedInstance].dirDocument stringByAppendingPathComponent:[NSString stringWithFormat:@"123/_book_.zip"]];
    //初始化临时文件路径
    NSString *tempPath = [[AppEngineManager sharedInstance].dirDocument stringByAppendingPathComponent:[NSString stringWithFormat:@"123/temp/_book.zip.temp"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:savePath];
    if (!fileExists) {//如果不存在说创建,因为下载时,不会自动创建文件夹
     [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    }
    
    
    BOOL fileExists1 = [fileManager fileExistsAtPath:tempPath];
    if (!fileExists1) {//如果不存在说创建,因为下载时,不会自动创建文件夹
        [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    //设置文件保存路径
    [request setDownloadDestinationPath:savePath];
    //设置临时文件路径
    [request setTemporaryFileDownloadPath:tempPath];
    [request setCachePolicy:ASICacheForSessionDurationCacheStoragePolicy];

    //设置是是否支持断点下载
    [request setAllowResumeForFileDownloads:YES];
    
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

    model.request = request;

    [[DBManager sharedDBManager] insertDBWithData:model forTableName:@"RequestInfo"];
    
}


#pragma mark - ASIHttprequestDelegate

- (void)dynamicModelrequestFinished:(ASIHTTPRequest *)request {
    

    [_ProgressView removeFromSuperview];
    _ProgressView = nil;
    
}



- (void)dynamicModelrequestFailed:(ASIHTTPRequest *)request {
    

    [_ProgressView removeFromSuperview];
    _ProgressView = nil;
}
- (void)backRequestModel {

 
    
    if(_request)
        
    {
        
        [_request clearDelegatesAndCancel];
        
        _request.delegate = nil;
        
    }
    
}

@end
