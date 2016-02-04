//
//  ShowLoadCellViewController.m
//  UncleCharDemos
//
//  Created by LingLi on 16/2/2.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "DynamicShowViewController.h"
#import "DynamicModel.h"
#import "DynamicTableViewCell.h"

@interface DynamicShowViewController ()<DynamicTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView     *dynamicTableView;
@property (nonatomic, strong) NSMutableArray  *dataArray;
//@property (nonatomic, strong) NSMutableArray  *uploadingArray;
@end

@implementation DynamicShowViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = 0;
//    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(addModel)];
    rightItem.title = @"增加模型";
    self.navigationItem.rightBarButtonItem = rightItem;
   
    [NetworkManager shareInstance].downloadRequestArr = [[NetworkManager shareInstance]getDownloadRequestList];
    
    [NetworkManager shareInstance].modelArr = [[NetworkManager shareInstance]getModelList];
    
    NSLog(@"_uploadCount %ld", [NetworkManager shareInstance].downloadRequestArr.count);
    
      NSLog(@"&& %@", [NetworkManager shareInstance].downloadRequestArr);
    
    if ([[NetworkManager shareInstance] getDownloadRequestList].count > 0  ) {
        UIProgressView *pro = [[UIProgressView alloc]initWithFrame:CGRectMake(56, 300, kScreenWidth - 60, 20)];
        
        NSLog(@"woupiuowuowueoweuowoweoweowoweuowowoweoweowueo--------------------------------");
        ASIHTTPRequest *request =  [NetworkManager shareInstance].downloadRequestArr[0];
        [request setShowAccurateProgress:YES];
        [request setDownloadProgressDelegate:pro];
        [[UIApplication sharedApplication].keyWindow addSubview:pro];
    }
    
    
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArray = [NetworkManager shareInstance].modelArr;
//    for (int i = 0; i < 3; i ++) {
//        
//        DynamicModel *model = [[DynamicModel alloc]init];
//        model.itemTitle = [NSString stringWithFormat:@" test 上传 %d",i];
//        model.hasRequest = NO;
//        [[NetworkManager shareInstance].modelArr addObject:model];
//    
//    }
    
    _dynamicTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _dynamicTableView.dataSource = self;
    _dynamicTableView.delegate   = self;
    [self.view addSubview:_dynamicTableView];
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString  *cellID = @"cell";
    
    DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (nil == cell) {
        
        cell = [[DynamicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    DynamicModel *model = _dataArray[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
}


- (void)requestStatus:(BOOL)isSuccess withModel:(DynamicModel *)model {

    if (isSuccess) {
        
        [_dynamicTableView reloadData];
        
    }else {
    
    
        [_dataArray removeObject:model];
        [_dynamicTableView reloadData];
        
    }

    
}

- (void)addModel {




    NSArray  *urlArray = @[@"http://sohu.vodnew.lxdns.com/214/246/SvJGK4cDTCmWiCcMGWP4NB.mp4",@"http://sohu.vodnew.lxdns.com/214/246/SvJGK4cDTCmWiCcMGWP4NB.mp4",@"http://sohu.vodnew.lxdns.com/214/246/SvJGK4cDTCmWiCcMGWP4NB.mp4",@"http://sohu.vodnew.lxdns.com/214/246/SvJGK4cDTCmWiCcMGWP4NB.mp4"];
//    ,@"http://music.baidu.com/pc/download/1454399323/BaiduMusic-77776666.exe",@"http://music.baidu.com/pc/download/1454399323/BaiduMusic-77776666.exe",@"http://music.baidu.com/pc/download/1454399323/BaiduMusic-77776666.exe"];
    for (NSString *urlStr in urlArray) {
        
        DynamicModel *model = [[DynamicModel alloc]init];
        
        model.itemTitle = [NSString stringWithFormat:@"我是增加的模型"];
        model.hasRequest = YES;
        model.url = urlStr;
        [[NetworkManager shareInstance].modelArr addObject:model];
        
    }
    [_dynamicTableView reloadData];
    
}



@end
