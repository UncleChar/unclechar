//
//  DivideContactsViewController.m
//  UncleCharDemos
//
//  Created by LingLi on 16/1/5.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "DivideContactsViewController.h"
#import <AddressBook/AddressBook.h>
#import "AddressBookModel.h"
#import <Contacts/Contacts.h>//这里是ios9的新特性，暂时还没有看到完整的OC使用方法，有一个swift的。
#import <ContactsUI/ContactsUI.h>
#import "UserModel.h"
#import "GroupModel.h"
#import "ChineseToPinyin.h"
#import "ContactTableViewCell.h"



@interface DivideContactsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchControllerDelegate,ContactTableViewCellDelegate>


@property (nonatomic, strong) UITableView           *myContactTableView;      //这个可以是网络请求app的联系人的tableVIew，这里简单的初始化一下
@property (nonatomic, strong) UITableView           *myAddressBookTableView;  //这个是本地通讯录的联系人的tableView

@property (nonatomic, strong) UISearchController    *mySearchController;      //
@property (nonatomic, strong) UISearchController    *mySearchAddresController;

@property (nonatomic, strong) NSMutableArray        *visibleContactArray;     //用来存贮app联系人,作为中转数组
@property (nonatomic, strong) NSMutableArray        *visibleGroupsArray;     //用来存贮app联系人,作为中转数组

@property (nonatomic, strong) NSMutableArray        *dataContactSourceArray;  //这是底层app联系人数据源
@property (nonatomic, strong) NSArray               *indexContactArr;         //用来索引名字的首字母，用于分组
@property (nonatomic, strong) NSArray               *indexAddresArr;          //同理，索引本地联系人


@property (nonatomic, strong) NSMutableArray        *addressNameArr;          //这里只去了模型里的name字段，可以取模型其他字段
@property (nonatomic, strong) NSMutableArray        *visableAddressArr;       //用来存贮本地联系人,作为中转数组


@property (nonatomic, strong) NSMutableArray        *justModelNameArr;


@property (nonatomic, strong) NSMutableDictionary   *contactDict;             //app联系人字典，存放的格式看方法里面
@property (nonatomic, strong) NSMutableDictionary   *addressDict;

@property (nonatomic, assign) BOOL                  isAddressContacts;        //控制判断是哪个页面
@property (nonatomic, assign) BOOL                  noJump;

@property (nonatomic, strong) UIButton              *cancelBtn;
@property (nonatomic, strong) UIButton              *selectedBtn;
@property (nonatomic, assign) NSInteger              selectedCount;


@property (nonatomic, strong) NSMutableDictionary   *storeDataSourceSearchDic;
@property (nonatomic, strong) NSMutableDictionary   *storeLocalSourceSearchDic;
@property (nonatomic, strong) UISegmentedControl    *segmentedControl;

@end

@implementation DivideContactsViewController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];

    _mySearchController.searchBar.hidden = NO;
    _mySearchAddresController.searchBar.hidden = NO;


    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(divideBackBtn)];
    leftItem.image = [UIImage imageNamed:@"left@2x"];
    self.navigationItem.leftBarButtonItem = leftItem;
 
    [self initNecessaryArray];       //初始化必要的数组

    
    [self configSelectedNumberBarTip];
    
    [self initial];
    
    //    [self initSearchController];     //初始化搜索栏
    

    [self getAddressBookPerson];     //获取本地联系人
    
    [self readAddressName];          //获取本地联系人信息（这里取名字）
    
    [self configSegumentController]; //配置选择器
    
    
    
    
    
    
}

- (void)initNecessaryArray {
    
    _addressNameArr            = [[NSMutableArray alloc]init];
    _visableAddressArr         = [[NSMutableArray alloc]init];
    _addressDict               = [[NSMutableDictionary alloc]init];
    _visibleContactArray       = [[NSMutableArray alloc]init];
    _visibleGroupsArray        = [[NSMutableArray alloc]init];
    _storeLocalSourceSearchDic = [[NSMutableDictionary alloc]init];
    _catchModelsArray          = [[NSMutableArray alloc]init];
    _dataAddressSourceArray    = [[NSMutableArray alloc]init];
    
}



- (void)readAddressName {
    
    for ( AddressBookModel *model in _dataAddressSourceArray) {
        
        if (model.name) {
        
            
            
        }else {
        
            model.name = @"charles";
        }
        [_addressNameArr addObject:model.name];
        [_storeLocalSourceSearchDic setObject:model forKey:model.name];
        
    }
    
    
}
- (void)initial{
    
    self.dataContactSourceArray = [NSMutableArray array];
    self.storeDataSourceSearchDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    self.contactDict = [NSMutableDictionary dictionary];
    
    //处理users
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    
    for (UserModel *model in _usersModelArray) {
        
        [tempArr addObject:model.real_name];
        [self.dataContactSourceArray addObject:model];
        [_storeDataSourceSearchDic setObject:model forKey:model.real_name];
        if (model.isSelected) {
            
            _selectedCount ++ ;
            
            /// 这里面还好把这个model 塞进数组
            [_catchModelsArray addObject:model];
        }
        
    }
    if (_groupsModelArray.count > 0) {
        _visibleGroupsArray = _groupsModelArray;
        for (GroupModel *model in _groupsModelArray) {
            [tempArr addObject:model.group_name];
            [_storeDataSourceSearchDic setObject:model forKey:model.group_name];
            if (model.isSelected) {
                
                _selectedCount ++ ;
                
                /// 这里面还好把这个model 塞进数组
                [_catchModelsArray addObject:model];
            }
        }
    }
    
    if (_dataAddressSourceArray.count > 0) {
        
        for (AddressBookModel *model in _dataAddressSourceArray) {
            
            if (model.isSelected) {
                
                _selectedCount ++;
                [_catchModelsArray addObject:model];
            }
        }
        
    }
    
    
    if (_selectedCount >=1) {
        
        [self renewBtnStatus];
    }
    
    NSLog(@"%ld",_groupsModelArray.count);
    //存放所有搜索的名字
    _justModelNameArr = [NSMutableArray arrayWithArray:tempArr];
    
    _contactDict =  [self configDataArrWithMutableArray:_dataContactSourceArray];
    
}


- (void)configSegumentController {
    
    NSArray *items                                         = @[@"全携通联系人",@"通讯录"];
    self.segmentedControl                                  = [[UISegmentedControl alloc] initWithItems:items];
    self.segmentedControl.selectedSegmentIndex             = 0;
    self.navigationItem.titleView                          = self.segmentedControl;
    [self.segmentedControl addTarget:self
                              action:@selector(segmentAction:)
                    forControlEvents:UIControlEventValueChanged];
    
    [self.segmentedControl setTintColor:[ConfigUITools colorRandomly]];
    
    
    if (_myContactTableView == nil) {
        
        _myContactTableView = [self configWithNormalTableView];
        [self.view addSubview:_myContactTableView];
        [_myContactTableView reloadData];
        
    }
    if (_mySearchController == nil) {
        
        self.mySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _mySearchController.searchResultsUpdater = self;
        _mySearchController.searchBar.placeholder = @"搜索";
//        _mySearchController.searchBar.backgroundImage = [UIImage imageNamed:@"condSearch@2x"];
        _mySearchController.dimsBackgroundDuringPresentation = 0;
        _mySearchController.delegate = self;
        [_mySearchController.searchBar sizeToFit];
        _myContactTableView.tableHeaderView = self.mySearchController.searchBar;
        
        
    }
    
    //    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    //    [self.view addSubview:segmentedControl];
    
}


- (UITableView *)configWithNormalTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 50)
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    return tableView;
}

- (void)configSelectedNumberBarTip {
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backView];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(1, 1, self.view.frame.size.width / 2 - 1.5, 48);
    _cancelBtn.backgroundColor = [UIColor whiteColor];
    _cancelBtn.tag = 2000 + 1;
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(btnClickedThis:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backView addSubview:_cancelBtn];
    
    
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedBtn.frame = CGRectMake(self.view.frame.size.width / 2 + 0.5, 1, self.view.frame.size.width / 2 - 1.5, 48);
    _selectedBtn.backgroundColor = [UIColor whiteColor];
    _selectedBtn.tag = 2000 + 2;
    [_selectedBtn setTitle:@"选择" forState:UIControlStateNormal];
    [_selectedBtn addTarget:self action:@selector(btnClickedThis:) forControlEvents:UIControlEventTouchUpInside];
    [_selectedBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backView addSubview:_selectedBtn];
    
    
}


-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    switch (Index) {
        case 0:
            
            _isAddressContacts = NO;
            _noJump = NO;
            [self.view bringSubviewToFront:_myContactTableView];
            [_myContactTableView reloadData];
            
            [self configSelectedNumberBarTip];
            [self renewBtnStatus];
            
            
            
            
            break;
        case 1:
            if (_myAddressBookTableView == nil) {
                
                _myAddressBookTableView = [self configWithNormalTableView];
                [self.view addSubview:_myAddressBookTableView];
                [_myAddressBookTableView reloadData];
                
            }
            if (_mySearchAddresController == nil) {
                
                self.mySearchAddresController= [[UISearchController alloc] initWithSearchResultsController:nil];
                _mySearchAddresController.searchResultsUpdater = self;
                _mySearchAddresController.searchBar.placeholder = @"搜索";
                _mySearchAddresController.dimsBackgroundDuringPresentation = 0;
                _mySearchAddresController.delegate = self;
                [_mySearchAddresController.searchBar sizeToFit];
                _myAddressBookTableView.tableHeaderView = self.mySearchAddresController.searchBar;
                
            }
            
            _isAddressContacts = YES; //判断是否是本地
            _noJump = YES;            //当是本地的时候不可以跳转到detailVC
            _addressDict = [self configDataArrWithMutableArray:_dataAddressSourceArray];
            [self.view bringSubviewToFront:_myAddressBookTableView];
            [_myAddressBookTableView reloadData];
            [self configSelectedNumberBarTip];
            [self renewBtnStatus];
            break;
            
        default:
            break;
    }
    
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == _myContactTableView) {
        
        return _contactDict.count + 1;
        
    }else {
        
        return _addressDict.count;
    }
    
}
//每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _myContactTableView) {
        
        if (section == 0) {
            
            return _visibleGroupsArray.count;
        }
        
        return [_contactDict[_indexContactArr[section - 1]] count];
        
        
    }else {
        
        return [_addressDict[_indexAddresArr[section]] count];
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID1 = @"id1";
    
    
    if (tableView == _myContactTableView) {
        
        ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        
        if (nil == cell) {
            
            cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
            
        }
        if (indexPath.section == 0) {
            
            GroupModel *model = [[GroupModel alloc] init];
            model = _visibleGroupsArray[indexPath.row];
            cell.model = model;
            
        }else {
            
            NSArray *namesArr = _contactDict[_indexContactArr[indexPath.section - 1]];
            UserModel *model = namesArr[indexPath.row];
            cell.model = model;
            //            tableView.allowsSelection = NO;
            
        }
 
        
        cell.delegate = self;
        
        return cell;
        
    }else {
        
        ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        
        if (!cell) {
            
            cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
            
        }
        NSArray *namesArr = _addressDict[_indexAddresArr[indexPath.section]];
        
        AddressBookModel *model = namesArr[indexPath.row];
        
        cell.model = model;
        cell.delegate = self;
        return cell;
        
    }
    
    
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    NSString *filterString = searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", filterString];
    
    if (_isAddressContacts == NO) {
        
        if (filterString.length == 0) {
            
            _contactDict = [self configDataArrWithMutableArray:_dataContactSourceArray];
            _visibleGroupsArray = _groupsModelArray;
            [_myContactTableView reloadData];
            
        }else {
            
            NSMutableArray *tempStoreArr = [NSMutableArray arrayWithArray:[_justModelNameArr filteredArrayUsingPredicate:predicate]];
            NSMutableArray *tempGroupsArr = [[NSMutableArray alloc]init];
            for (NSString *tempName in tempStoreArr) {
                
                
                if ([[_storeDataSourceSearchDic objectForKey:tempName] isKindOfClass:[UserModel class]]) {
                    
                    UserModel *model =  [_storeDataSourceSearchDic objectForKey:tempName];
                    [_visibleContactArray addObject:model];
                    
                }else {
                    
                    GroupModel *model = [_storeDataSourceSearchDic objectForKey:tempName];
                    [tempGroupsArr addObject:model];
                }
                
                
                
                
            }
            _contactDict = [self configDataArrWithMutableArray:_visibleContactArray];
            _visibleGroupsArray = tempGroupsArr;
            [_visibleContactArray removeAllObjects];
            [_myContactTableView reloadData];
            
        }
    }else {
        
        if (filterString.length == 0) {
            
            _addressDict = [self configDataArrWithMutableArray:_dataAddressSourceArray];
            [_myAddressBookTableView reloadData];
            
        }else {
            
            NSMutableArray *tempLocalArr = [NSMutableArray arrayWithArray:[_addressNameArr filteredArrayUsingPredicate:predicate]];
            for (NSString *tempLocalName in tempLocalArr) {
                
                AddressBookModel *model = [_storeLocalSourceSearchDic objectForKey:tempLocalName];
                [_visableAddressArr addObject:model];
            }
            _addressDict = [self configDataArrWithMutableArray:_visableAddressArr];
            [_visableAddressArr removeAllObjects];
            [_myAddressBookTableView reloadData];
            
        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0 && (!_noJump)) {
        
        NSLog(@"是组");
        NSLog(@"wokao %ld",indexPath.row);
//        DetailUsersController *detailVC = [[DetailUsersController alloc]init];
//        detailVC.groupsModel = _visibleGroupsArray[indexPath.row];
//        _mySearchController.searchBar.hidden = YES;
//        _mySearchAddresController.searchBar.hidden = YES;
//        [_mySearchController.searchBar resignFirstResponder];
//        [_mySearchAddresController.searchBar resignFirstResponder];
//        [self.navigationController pushViewController:detailVC animated:YES];
//        //        [self.navigationController presentViewController:detailVC animated:YES completion:nil];
        
    }else {
        
        NSLog(@"是人");
        //        tableView.allowsSelection = NO;
        NSLog(@"wokao %ld",indexPath.row);
        
    }
}


#pragma mark - tableview代理
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (tableView == _myContactTableView) {
        
        return _indexContactArr;
    }
    
    return _indexAddresArr;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (tableView == _myContactTableView) {
        
        if (section == 0) {
            if (_groupsModelArray.count > 0) {
                
                return @"群组";
            }
            return nil;
        }
        return _indexContactArr[section - 1];
        
    }
    
    return _indexAddresArr[section];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
    
}


- (void)presentSearchController:(UISearchController *)searchController {
    
    NSLog(@"testXHL");
    //    self.searchController.searchResultsController
}
- (void)willDismissSearchController:(UISearchController *)searchController {
    
    
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    
    if (!_isAddressContacts) {
        
        _contactDict =  [self configDataArrWithMutableArray:_dataContactSourceArray];
        [_myContactTableView reloadData];
        
    }else {
        
        _addressDict = [self configDataArrWithMutableArray:_dataAddressSourceArray];
        [_myAddressBookTableView reloadData];
    }
    
}


- (NSMutableDictionary *)configDataArrWithMutableArray:(NSArray *)arr {
    
    if (_isAddressContacts == NO) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (UserModel *contactModel in arr) {
            
            //取出字典里面首字母键对应的联系人名子数组
            NSMutableArray *namesArr = dict[[NSString stringWithFormat:@"%c",[ChineseToPinyin sortSectionTitle:contactModel.real_name]]];
            
            if (namesArr) {//数组不空，加入新名字到数组
                
                [namesArr addObject:contactModel];
                
            }else {//空，先创建数组再添加联系人,
                
                namesArr = [NSMutableArray arrayWithCapacity:0];
                [namesArr addObject:contactModel];
                [dict setObject:namesArr forKey:[NSString stringWithFormat:@"%c",[ChineseToPinyin sortSectionTitle:contactModel.real_name]]];
                
            }
        }
        
        _indexContactArr = [dict allKeys];
        _indexContactArr = [_indexContactArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            return [obj1 compare:obj2];
            
        }];
        
        return dict;
        
    }else {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        for (AddressBookModel *adressModel in arr) {
            
            //取出字典里面首字母键对应的联系人名子数组
            NSMutableArray *namesArr = dict[[NSString stringWithFormat:@"%c",[ChineseToPinyin sortSectionTitle:adressModel.name]]];
            
            if (namesArr) {//数组不空，加入新名字到数组
                
                [namesArr addObject:adressModel];
            }else {//空，先创建数组再添加联系人,
                
                namesArr = [NSMutableArray arrayWithCapacity:0];
                [namesArr addObject:adressModel];
                [dict setObject:namesArr forKey:[NSString stringWithFormat:@"%c",[ChineseToPinyin sortSectionTitle:adressModel.name]]];
                
            }
        }
        
        _indexAddresArr = [dict allKeys];
        
        _indexAddresArr = [_indexAddresArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            return [obj1 compare:obj2];
            
        }];
        
        return dict;
        
    }
    
    
}


- (void)btnSelected:(UIButton *)btn withModel:(id)model{
    
    if ([model isKindOfClass:[GroupModel class]]) {
        GroupModel *gmodel = model;
        if (gmodel.invited) {
            
        }else {
            
            _selectedCount ++;
            [_catchModelsArray addObject:gmodel];
        }
    }else if ([model isKindOfClass:[UserModel class]]) {
        UserModel *umodel = model;
        if (umodel.invited) {
            
        }else {
            
            _selectedCount ++;
            [_catchModelsArray addObject:model];
        }
    }else {
        
        AddressBookModel *admodel = model;
        _selectedCount ++;
        [_catchModelsArray addObject:admodel];
        //本地还没做
        
    }
    
    
    [self renewBtnStatus];
    
    
}
- (void)btnUnSelected:(UIButton *)btn withModel:(id)model{
    
    if ([model isKindOfClass:[GroupModel class]]) {
        
        GroupModel *gmodel = model;
        if (gmodel.invited) {
            
        }else {
            [_catchModelsArray removeObject:gmodel];
            _selectedCount --;
        }
    }
    if ([model isKindOfClass:[UserModel class]]) {
        
        UserModel *umodel = model;
        if (umodel.invited) {
            
        }else {
            [_catchModelsArray removeObject:model];
            _selectedCount --;
        }
    }
    if ([model isKindOfClass:[AddressBookModel class]]) {
        
        AddressBookModel *admodel = model;
        _selectedCount --;
        [_catchModelsArray removeObject:admodel];
        
    }
    
    
    [self renewBtnStatus];
    
    
}
- (void)renewBtnStatus {
    
    if (_selectedCount > 0) {
        
        [_selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_selectedBtn setTitle:[NSString stringWithFormat:@"选择(%ld)",_selectedCount] forState:UIControlStateNormal];
    }else {
        
        [_selectedBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [_selectedBtn setTitle:@"选择" forState:UIControlStateNormal];
        
    }
    
}

- (void)btnClickedThat {
    
    //    [self dismissViewControllerAnimated:YES completion:nil];
    _catchBlock(_catchModelsArray);
    self.navigationController.navigationBarHidden = 0;
    _mySearchController.searchBar.hidden = YES;
    _mySearchAddresController.searchBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnClickedThis:(UIButton *)sender {
    
    NSInteger indexBtn = sender.tag - 2000;
    switch (indexBtn) {
        case 0:
        {
            
            //    [self dismissViewControllerAnimated:YES completion:nil];
            _mySearchController.searchBar.hidden = YES;
            _mySearchAddresController.searchBar.hidden = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        case 1:
        {
            if (_catchModelsArray.count > 0) {
                
                for (id obj in _catchModelsArray) {
                    
                    if ([obj isKindOfClass:[GroupModel class]]) {
                        GroupModel *model = obj;
                        model.isSelected = NO;
                    }
                    if ([obj isKindOfClass:[UserModel class]]) {
                        UserModel *model = obj;
                        model.isSelected = NO;
                    }
                    if ([obj isKindOfClass:[AddressBookModel class]]) {
                        AddressBookModel *model = obj;
                        model.isSelected = NO;
                    }
                    
                    
                }
            }
            
            //    [self dismissViewControllerAnimated:YES completion:nil];
            _mySearchController.searchBar.hidden = YES;
            _mySearchAddresController.searchBar.hidden = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
            
            
            break;
        case 2:
        {
            
            _catchBlock(_catchModelsArray);
            self.navigationController.navigationBarHidden = 0;
            _mySearchController.searchBar.hidden = YES;
            _mySearchAddresController.searchBar.hidden = YES;
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
            
            break;
        default:
            break;
    }
    
}


- (void)getAddressBookPerson { //此代码网上档的，暂时不需要研究
    
    
    //    CNContactStore * stroe = [[CNContactStore alloc]init];ios9里面的
    
    ABAddressBookRef addressBooks = nil; //此方法ios9已经  typedef CFTypeRef ABAddressBookRef AB_DEPRECATED("use CNContactStore");
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else{
        
        addressBooks = ABAddressBookCreate();
        
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
        
    {
        //新建一个addressBook model类
        AddressBookModel *addressBook = [[AddressBookModel alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        if ((__bridge id)abFullName != nil) {
            
            nameString = (__bridge NSString *)abFullName;
            
        } else {
            
            if ((__bridge id)abLastName != nil)
                
            {
                
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
                
            }
            
        }
        
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                
                CFRelease(valuesRef);
                continue;
                
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                
                switch (j) {
                        
                    case 0: {// Phone number
                        
                        addressBook.tel = (__bridge NSString*)value;
                        break;
                        
                    }
                        
                    case 1: {// Email
                        
                        addressBook.email = (__bridge NSString*)value;
                        break;
                        
                    }
                        
                }
                
                CFRelease(value);
                
            }
            
            CFRelease(valuesRef);
            
        }
        
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        
        [_dataAddressSourceArray addObject:addressBook];
    }
}

- (void)divideBackBtn {

    [self.navigationController popViewControllerAnimated:YES];
}

@end
