//
//  LocationViewController.m
//  UncleCharDemos
//
//  Created by LingLi on 16/1/4.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "LocationViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface LocationViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKMapView *_mapView;
    
    BMKLocationService *_locService;
    
    NSString  *_myLocationName;
}
@end
@implementation LocationViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    self.navigationController.navigationBarHidden = 0;
    _mapView.delegate = self;
    _locService.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startLocation];
    
}




- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"MyLocation";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
//    {
//        self.navigationController.navigationBar.translucent = NO;
//    }
    
    //初始化地图
    [self setupMapView];
    
    
}

////拖动地图获取经纬
//- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//    NSLog(@"经度:%f 维度:%f",mapView.centerCoordinate.longitude,mapView.centerCoordinate.latitude);
//
//}


- (void)setupMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _locService = [[BMKLocationService alloc] init];
    // 设置地图级别
    [_mapView setZoomLevel:15];
    
    [_mapView setMapType:BMKMapTypeStandard];
    
    [self.view addSubview:_mapView];
    
}

//开启定位
- (void)startLocation
{
    NSLog(@"已进入定位系统");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
}


#pragma mark locationSerce Delegate
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}


/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}


/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    
    NSLog(@"经度:%f  纬度:%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    // 用户最新位置
    CLLocation *location = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    
    // 反地理编码(逆地理编码) : 把坐标信息转化为地址信息
    // 地理编码 : 把地址信息转换为坐标信息
    
    // 地理编码类
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    // 参数1:用户位置
    // 参数2:反地理编码完成之后的block
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"反地理编码失败");
            return ;
        }
        
        CLPlacemark *placeMark = [placemarks firstObject];
        NSLog(@"国家:%@ 城市:%@ 区:%@ 具体位置:%@", placeMark.country, placeMark.locality, placeMark.subLocality, placeMark.name);
        _myLocationName = placeMark.name;
        [_locService stopUserLocationService];
        
        return;
    }];
    
    
}

- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"我的位置是" message:_myLocationName preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:okAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
    
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"我的位置是" message:_myLocationName preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:okAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    
}

- (void)dealloc
{
    if(_mapView){
        _mapView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
//- (void)viewWillAppear:(BOOL)animated {
//    
//    [super viewWillAppear:YES];
//    self.navigationController.navigationBarHidden = 0;
//    self.navigationController.hidesBarsWhenKeyboardAppears = YES;
//    
//    
//}
//
//- (void)viewDidLoad {
//    
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    
//    _geocoder=[[CLGeocoder alloc]init];
//    [self getCoordinateByAddress:@"北京"];
//    [self getAddressByLatitude:39.54 longitude:116.28];
//    
//    //定位管理器
//    _locationManager=[[CLLocationManager alloc]init];
//    
//    if (![CLLocationManager locationServicesEnabled]) {
//        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
//        return;
//    }
//    
//    //如果没有授权则请求用户授权
//    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
//        [_locationManager requestWhenInUseAuthorization];
//    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
//        //设置代理
//        _locationManager.delegate=self;
//        //设置定位精度
//        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
//        //定位频率,每隔多少米定位一次
//        CLLocationDistance distance=10.0;//十米定位一次
//        _locationManager.distanceFilter=distance;
//        //启动跟踪定位
//        [_locationManager startUpdatingLocation];
//    }
//    
//}
//
//#pragma mark - CoreLocation 代理
//#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
////可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//    CLLocation *location=[locations firstObject];//取出第一个位置
//    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
//    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
//    //如果不需要实时定位，使用完即使关闭定位服务
//    [_locationManager stopUpdatingLocation];
//}
//#pragma mark 根据地名确定地理坐标
//-(void)getCoordinateByAddress:(NSString *)address{
//    //地理编码
//    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
//        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
//        CLPlacemark *placemark=[placemarks firstObject];
//        
//        CLLocation *location=placemark.location;//位置
//        CLRegion *region=placemark.region;//区域
//        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
//        //        NSString *name=placemark.name;//地名
//        //        NSString *thoroughfare=placemark.thoroughfare;//街道
//        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
//        //        NSString *locality=placemark.locality; // 城市
//        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
//        //        NSString *administrativeArea=placemark.administrativeArea; // 州
//        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
//        //        NSString *postalCode=placemark.postalCode; //邮编
//        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
//        //        NSString *country=placemark.country; //国家
//        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
//        //        NSString *ocean=placemark.ocean; // 海洋
//        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
//        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
//    }];
//}
//
//#pragma mark 根据坐标取得地名
//-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
//    //反地理编码
//    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
//    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        CLPlacemark *placemark=[placemarks firstObject];
//        NSLog(@"详细信息:%@",placemark.addressDictionary);
//    }];
//}



