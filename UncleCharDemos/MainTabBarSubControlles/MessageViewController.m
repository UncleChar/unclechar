//
//  MessageViewController.m
//  ReconstructionQQSlide
//
//  Created by LingLi on 15/12/24.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import "MessageViewController.h"
#import "LocationViewController.h"
#import "ChatRoomViewController.h"
#import "MJRefresh.h"
#import "UIView+MJExtension.h"
#import "MJRefresh.h"

#define MessaageVCRandomData [NSString stringWithFormat:@"UserAccount--%d", arc4random_uniform(1000000)]
@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate>
{

    CALayer              *_layer;     //图层
    NSTimer              *_timer;     //定时器
}
@property (nonatomic, strong) UITableView         *userChatTableView;
@property (nonatomic, strong) NSMutableArray      *userChatArrary;
@property (nonatomic, strong) NSMutableArray      *userSearchResultArrary;
//@property (nonatomic, strong) UISearchController  *userSearchController;
@property (nonatomic, strong) MJRefreshHeader     *header;
@end
@implementation MessageViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    self.userSearchController.searchBar.hidden = NO;
//    [_userChatTableView.mj_header beginRefreshing];


}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(messageVC)];
    leftItem.image = [UIImage imageNamed:@"qq@3x"];
    self.navigationItem.leftBarButtonItem = leftItem;

    self.navigationItem.title = @"Chat with me";
    
    UIImageView *leftRefresh = [[UIImageView alloc]initWithFrame:CGRectMake(55, 25, 34, 34)];
    
    leftRefresh.image = [UIImage imageNamed:@"basevc_refresh@2x"];
    [self.navigationController.view addSubview:leftRefresh];

    _layer = leftRefresh.layer;



    [self imitateRefresh];
    
    [self configMessageVCUI];
    
    [self handleMessageVCData];
    

}
- (void)imitateRefresh {

    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(rotationRefreshView) userInfo:nil repeats:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        [NSThread sleepForTimeInterval:8];
        dispatch_async(dispatch_get_main_queue(), ^{
            

            [_timer invalidate];
//            [_userChatTableView.mj_header endRefreshing];
            _layer.transform = CATransform3DIdentity;
            
        });
    });
}

- (void)handleMessageVCData {
    
    if (nil == _userChatArrary) {
        
        _userChatArrary = [NSMutableArray arrayWithCapacity:0];
    }
    
    NSString *name1 = @"UncleChar";
    NSString *name2 = @"Tingting.Xia";
    NSString *name3 = @"Qianbin";
    NSString *name4 = @"Karray.Meng";
    NSString *name5 = @"Charles";
    [_userChatArrary addObject:name1];
    [_userChatArrary addObject:name2];
    [_userChatArrary addObject:name3];
    [_userChatArrary addObject:name4];
    [_userChatArrary addObject:name5];
    
    _userSearchResultArrary = _userChatArrary;
}

- (void)configMessageVCUI {

//    self.view.backgroundColor = [ConfigUITools colorRandomly];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(LocationVC)];
    rightItem.image = [UIImage imageNamed:@"tabbar_location@2x"];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
//    UILabel* myLabel;
//    myLabel=[[UILabel alloc] initWithFrame:CGRectMake(100.0f, 14.0f, 100.0f, 10.0f)];
//    myLabel.font=[UIFont systemFontOfSize:10];
//    myLabel.backgroundColor = [UIColor blackColor];
//    [self.navigationController.navigationBar addSubview: myLabel];
    
//    UITextField *tt = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 80, 7, 160, 30)];
//    tt.text = @"test";
//    tt.textAlignment = 1;
//    tt.borderStyle = UITextBorderStyleRoundedRect;
//    tt.backgroundColor = [UIColor clearColor];
//
//
//    [self.navigationController.navigationBar addSubview: tt];

    

    
    
    _userChatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49) style:UITableViewStylePlain];
    _userChatTableView.delegate   = self;
    _userChatTableView.dataSource = self;
    _userChatTableView.backgroundColor = [UIColor colorWithRed:239.0/255 green:237.0/255 blue:244.0/255 alpha:1];
    [self.view addSubview:_userChatTableView];
    
    _userSearchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    _userSearchController.searchResultsUpdater = self;
    _userSearchController.dimsBackgroundDuringPresentation = NO;
//    _userSearchController.searchBar.text = @"kaisho";
//    [_userSearchController.searchBar setShowsCancelButton:YES];
    [_userSearchController.searchBar sizeToFit];
    _userSearchController.searchBar.delegate = self;
    

    _userSearchController.hidesNavigationBarDuringPresentation = NO;
    _userChatTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

       
        for (int i = 0; i < 4; i ++) {
            
            [_userChatArrary addObject:MessaageVCRandomData];
            
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            [NSThread sleepForTimeInterval:4];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                

                [_userChatTableView.mj_header endRefreshing];
                [_userChatTableView reloadData];
                //            _layer.transform = CATransform3DIdentity;
                
            });
        });
    }];
    
    
    _userChatTableView.tableHeaderView = self.userSearchController.searchBar;
    
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (nil == _userSearchResultArrary || _userSearchResultArrary.count == 0) {
        
        _userSearchResultArrary = _userChatArrary;
    }
    return _userSearchResultArrary.count;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"icon"];
    cell.textLabel.text = _userSearchResultArrary[indexPath.row];
    cell.imageView.layer.cornerRadius = 24;
    cell.imageView.layer.masksToBounds = 1;
    [cell setSelected:YES animated:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    ChatRoomViewController *chatRoomVC = [[ChatRoomViewController alloc]init];
    chatRoomVC.chatRoomTitle = _userSearchResultArrary[indexPath.row];
    self.userSearchController.searchBar.hidden = YES;
    [self.userSearchController.searchBar resignFirstResponder];
    
    [[AppEngineManager sharedInstance] baseViewControllerPushViewController:chatRoomVC animated:YES];
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    NSString *filterString = searchController.searchBar.text;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", filterString];
    
    _userSearchResultArrary = [NSMutableArray arrayWithArray:[self.userChatArrary filteredArrayUsingPredicate:predicate]];
    
    [self.userChatTableView reloadData];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    NSLog(@"ff%lf",scrollView.contentOffset.y);
}


#pragma mark 角标旋转
- (void)rotationRefreshView
{
    _layer.transform = CATransform3DRotate(_layer.transform, M_PI_4 / 6, 0, 0, 1);
}

- (void)messageVC {

    NSLog(@"leftBtnClicked");
    [[AppEngineManager sharedInstance].baseViewController leftControllerAppear];
    
}

- (void)LocationVC {
    
    LocationViewController *locationVC = [[LocationViewController alloc]init];
    [[AppEngineManager sharedInstance] baseViewControllerPushViewController:locationVC animated:YES];
}

@end
