//
//  OperateDBViewController.m
//  UncleCharDemos
//
//  Created by LingLi on 15/12/28.
//  Copyright © 2015年 hailong.xie. All rights reserved.
//

#import "OperateDBViewController.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "DBManager.h"
#import "UserTestModel.h"
#import "OperateDBTabelViewCell.h"



@interface OperateDBViewController ()<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIImageView     *imageFromNetwork;
@property (nonatomic, strong) DBManager       *db;
@property (nonatomic, strong) NSData          *dataFromNetwork;
@property (nonatomic, strong) ASINetworkQueue *requestQueue;
@property (nonatomic, strong) UIProgressView  *reqestProgress;
@property (nonatomic, assign) long long       sizeReceived;
@property (nonatomic, strong) NSMutableArray  *networkDataArray;
@property (nonatomic, strong) UITableView     *showDataTableView;
@property (nonatomic, strong) NSMutableArray  *showDataArray;
@property (nonatomic, strong) NSMutableArray  *showDataForImgArray;
@property (nonatomic, assign) NSInteger        countOfBtn;
@property (nonatomic, strong) UIButton        *leftBtn;
@property (nonatomic, strong) UIButton        *rightBtn;
@end

@implementation OperateDBViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad {
    
    self.title = self.navigationTitle;
    self.view.backgroundColor = [UIColor brownColor];
    self.navigationController.navigationBarHidden = 0;

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(backBtn)];
    leftItem.image = [UIImage imageNamed:@"left@2x"];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    _countOfBtn = 0;
    
    if (!_showDataArray) {
        
        _showDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    if (!_showDataForImgArray) {
        
        _showDataForImgArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    
    [self configOperateVCUI];
    
 
    
}

- (void)configOperateVCUI {

    _reqestProgress = [[UIProgressView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 100, 68, 200, 4)];
    _reqestProgress.backgroundColor = [UIColor redColor];
    [self.view addSubview:_reqestProgress];
    
    _imageFromNetwork = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 + 20, 90, kScreenWidth / 2 -40, 120)];
    _imageFromNetwork.backgroundColor = [UIColor lightGrayColor];
    _imageFromNetwork.layer.cornerRadius = 5;
    _imageFromNetwork.layer.masksToBounds = 1;
    [self.view addSubview:_imageFromNetwork];
    
    

    
    
    //测试分享功能的demo按钮
    UIButton *downloadPhotoBtn = [ConfigUITools configButtonWithTitle:@"下载图片队列" color:kBtnColor fontSize:13 frame:CGRectMake(40, 80, 120, 30) superView:self.view];
    [downloadPhotoBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    downloadPhotoBtn.tag = 1000 + 1;
    
    UIButton *openFmdbBtn = [ConfigUITools configButtonWithTitle:@"数据库存储图片" color:kBtnColor fontSize:14 frame:CGRectMake(40, 120, 120, 30) superView:self.view];
    openFmdbBtn.tag = 1000 + 2;
    [openFmdbBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    

    
   
    
    UIButton *showImgBtn = [ConfigUITools configButtonWithTitle:@"SHOW" color:kBtnColor fontSize:14 frame:CGRectMake(CGRectGetMinX(_imageFromNetwork.frame) + _imageFromNetwork.frame.size.width / 2 - 30,CGRectGetMaxY(_imageFromNetwork.frame)+ 10,60,30) superView:self.view];
    showImgBtn.tag = 1000 + 8;
    CGFloat centerY = showImgBtn.center.y;
    [showImgBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    showImgBtn.center = CGPointMake(_imageFromNetwork.center.x, centerY);
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.tag = 1000 + 7;
    _leftBtn.enabled = NO;
    _leftBtn.frame = CGRectMake(CGRectGetMinX(_imageFromNetwork.frame), CGRectGetMaxY(_imageFromNetwork.frame) + 10, 20, 30);
    [_leftBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBtn];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.tag = 1000 + 9;
    _rightBtn.enabled = NO;
    _rightBtn.frame = CGRectMake(CGRectGetMaxX(_imageFromNetwork.frame) - 20, CGRectGetMaxY(_imageFromNetwork.frame) + 10, 20, 30);
    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightBtn];
    
//    UIButton *refreshBtn = [ConfigUITools configButtonWithTitle:@"刷新读缓存" color:[UIColor grayColor] fontSize:14 frame:CGRectMake(SCREEN_WIDTH / 2 + 10, 360, 90, 40) superView:self.view];
//    refreshBtn.tag = 100 + 8;
//    [refreshBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *searchSingleBtn = [ConfigUITools configButtonWithTitle:@"查找单个user" color:kBtnColor fontSize:14 frame:CGRectMake(40, 160, 120, 30) superView:self.view];
    searchSingleBtn.tag = 1000 + 3;
    [searchSingleBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *searchAllBtn = [ConfigUITools configButtonWithTitle:@"查找所有user" color:kBtnColor fontSize:14 frame:CGRectMake(40, 200, 120, 30) superView:self.view];
    searchAllBtn.tag = 1000 + 4;
    [searchAllBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *updateSingleBtn = [ConfigUITools configButtonWithTitle:@"更新一个user信息" color:kBtnColor fontSize:14 frame:CGRectMake(40, 240, 120, 30) superView:self.view];
    updateSingleBtn.tag = 1000 + 5;
    [updateSingleBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UIButton *deleteAllBtn = [ConfigUITools configButtonWithTitle:@"清空所有数据" color:[UIColor grayColor] fontSize:14 frame:CGRectMake(40, 280, 120, 30) superView:self.view];
    deleteAllBtn.tag = 1000 + 6;
    [deleteAllBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _showDataTableView = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_imageFromNetwork.frame) - 10, CGRectGetMaxY(_leftBtn.frame) + 10, _imageFromNetwork.frame.size.width + 20, kScreenHeight - CGRectGetMaxY(_leftBtn.frame) - 10)];
    _showDataTableView.delegate = self;
    _showDataTableView.dataSource = self;
    [self.view addSubview:_showDataTableView];
    
}

- (void)btnClicked:(UIButton *)sender {
    
  
    
        
        switch (sender.tag - 1000) {
            case 1:
            {
                
                //http://www.hq.xinhuanet.com/photo/2008-04/30/xinsrc_53304052908590002877117.jpg
                //http://pic4.bbzhi.com/fengjingbizhi/haiyangshijiedongtaizhuomianbizhi/haiyangshijiedongtaizhuomianbizhi_399657_8.jpg
                //http://a.hiphotos.baidu.com/zhidao/pic/item/8694a4c27d1ed21ba67031c0ac6eddc451da3f5d.jpg
                //http://t1.niutuku.com/960/59/59-259160.jpg
                //http://b.zol-img.com.cn/desk/bizhi/image/1/960x600/13479490300.jpg
                
                NSMutableArray *imgUrlArr = [[NSMutableArray alloc]initWithCapacity:0];
                [imgUrlArr addObject:@"http://www.hq.xinhuanet.com/photo/2008-04/30/xinsrc_53304052908590002877117.jpg"];
                [imgUrlArr addObject:@"http://pic4.bbzhi.com/fengjingbizhi/haiyangshijiedongtaizhuomianbizhi/haiyangshijiedongtaizhuomianbizhi_399657_8.jpg"];
                [imgUrlArr addObject:@"http://a.hiphotos.baidu.com/zhidao/pic/item/8694a4c27d1ed21ba67031c0ac6eddc451da3f5d.jpg"];
                [imgUrlArr addObject:@"http://t1.niutuku.com/960/59/59-259160.jpg"];
                [imgUrlArr addObject:@"http://b.zol-img.com.cn/desk/bizhi/image/1/960x600/13479490300.jpg"];
                [imgUrlArr addObject:@"http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg"];
                [imgUrlArr addObject:@"http://img.taopic.com/uploads/allimg/130501/240451-13050106450911.jpg"];
                [imgUrlArr addObject:@"http://a2.att.hudong.com/38/59/300001054794129041591416974.jpg"];
                [imgUrlArr addObject:@"http://img05.tooopen.com/images/20140919/sy_71272488121.jpg"];
                [imgUrlArr addObject:@"http://pic.58pic.com/58pic/11/16/28/22J58PICIKD.jpg"];
                [imgUrlArr addObject:@"http://img.taopic.com/uploads/allimg/121203/235072-12120314092963.jpg"];


                
                _requestQueue = [[ASINetworkQueue alloc]init];
                [_requestQueue setRequestDidFinishSelector:@selector(requestFinished:)];
                [_requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
                [_requestQueue setQueueDidFinishSelector:@selector(queueFinished:)];
                [_requestQueue setDownloadProgressDelegate:_reqestProgress];
                [_requestQueue setShowAccurateProgress:YES];//进度条精确显示
                [_requestQueue setDelegate:self];
                
                for (int i=0; i<imgUrlArr.count; i++) {
                    
                    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:imgUrlArr[i]]];
                    request.tag = i + 666;
                    [request setDownloadProgressDelegate:self];
                    [_requestQueue addOperation:request];
                    
                }
                
                [_requestQueue go];
                
            }
                break;
            case 2:
            {
                
                //初始化数据库，并存储一个数据
                
                
                
                if (_networkDataArray.count > 0) {
                    
                    for (int i = 0 ;i < _networkDataArray.count;i++) {
                        
                        UserTestModel *model = [[UserTestModel alloc]init];
                        
                        model.userID = [NSString stringWithFormat:@"file_0%d",i]; //唯一ID
                        model.userName = @"UncleChar";
                        model.country = @"China";
                        model.sex = @"male";
                        model.biggerData = _networkDataArray[i];
                        model.telephone = @"13852042434";
                        model.userMusic = _networkDataArray[i];
                        
                        [[DBManager sharedDBManager] insertDBWithData:model forTableName:@"UserInfo"];
                    }
                }
                
                
                
                
                
            }
                break;
            case 3:
            {
                
                
                
            }
                break;
            case 4:
            {
                [_showDataArray removeAllObjects];
                NSArray *allDataArray = [NSArray array];
                allDataArray = [[DBManager sharedDBManager] allDataWithTableName:@"UserInfo"];
                
                for (UserTestModel *model in allDataArray) {
                    UIImageView *iv = [[UIImageView alloc]init];
                    iv.image = [UIImage imageWithData:model.biggerData];
                    NSLog(@"$$$%lf,%lf",iv.image.size.width,iv.image.size.height);
                    
                }
                _showDataArray = (NSMutableArray *)allDataArray;
                
                [_showDataTableView reloadData];
            }
                break;
            case 5:
            {
                UserTestModel *model = [[UserTestModel alloc]init];
                model.userID = @"file_01";
                
                [[DBManager sharedDBManager] updateDBDataWithModel:model forTableName:@"UserInfo"];
                
                
            }
                break;
            case 6:
            {
                
                [[DBManager sharedDBManager] clearAllDataWithTableName:@"UserInfo"];
                
            }
                break;
                
            case 7:
            {
                if (_showDataArray.count > 0) {
                    
                    if (_countOfBtn == 0) {
                        
                        _countOfBtn = _showDataForImgArray.count;
                    }
                    _countOfBtn --;
                    
                    
                    _imageFromNetwork.image = [UIImage imageWithData:[_showDataForImgArray[_countOfBtn] biggerData]];
                }
               
                
                
                
            }
                break;
            case 8:
            {
                [_showDataForImgArray removeAllObjects];
                NSArray *allDataArray = [NSArray array];
                allDataArray = [[DBManager sharedDBManager] allDataWithTableName:@"UserInfo"];
                
                //                for (UserTestModel *model in allDataArray) {
                //
                //
                //                }
                _showDataForImgArray = (NSMutableArray *)allDataArray;
                
                _rightBtn.enabled = 1;
                _leftBtn.enabled  = 1;
                
            }
                break;
            case 9:
            {
                if (_showDataArray.count > 0) {
                  
                    _countOfBtn ++;
                    if (_countOfBtn >= _showDataForImgArray.count) {
                        
                        _countOfBtn = 0;
                    }
                    
                    _imageFromNetwork.image = [UIImage imageWithData:[_showDataForImgArray[_countOfBtn] biggerData]];
                    
                }

                
                
            }
                break;
            default:
                break;
        }

    

}


#pragma mark - tableViewDelegate--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _showDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cellID";
    
    OperateDBTabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        
        cell = [[OperateDBTabelViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    UserTestModel *model = [[UserTestModel alloc]init];
    
    model = _showDataArray[indexPath.row];
    cell.model = model;
  
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 56;
}


#pragma ASI请求数据


- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    
//    NSLog(@"ssss   %lld",bytes);
    
}


- (void)requestFinished:(ASIHTTPRequest *)request { //获取网络并实现吧图片存入沙盒，接着想设计好数据库存取数据，包括视频图片之类的所有文件
    
    NSData  *receiveData = [request responseData];

//  NSLog(@"-----%@",[request responseString]);
    
    if (nil == _networkDataArray) {
        
        _networkDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    }

//    [self createDirWithData:receiveData withFileName:[NSString stringWithFormat:@"%ld",request.tag]]; //把数据直接写入沙盒
    [[AppEngineManager sharedInstance] writeDataToDirectoryWithData:receiveData fileNameForData:[NSString stringWithFormat:@"UCimg%ld.png",request.tag] underSuperDirecotry:[[AppEngineManager sharedInstance].dirDocument stringByAppendingPathComponent:@"NetworkData"]];
    
    [_networkDataArray addObject:receiveData];
    
    NSLog(@"Value: %f", [_reqestProgress progress]);
    
    
    
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    
    NSLog(@"falied");
}

- (void)queueFinished:(ASINetworkQueue *)requestQuene {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"下载完成" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    //                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
}

- (void)backBtn {

    if (_requestQueue) {
        
        [_requestQueue cancelAllOperations];
        
        _requestQueue.delegate = nil;
        

    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)dealloc
{
//    [_requestQueue clearDelegatesAndCancel];
//    [request release];
//    ...
//    [super dealloc];
}

@end
