//
//  AppDelegate.m
//  ContactWeekend
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"
//1.引入所需框架
#import <CoreLocation/CoreLocation.h>
#import <BmobSDK/Bmob.h>
//5.遵循定位代理协议
@interface AppDelegate ()<CLLocationManagerDelegate>
{
 //2.定义定位所需要类的实例对象
    CLLocationManager *_locationManager;//定位
    //创建地理编码对象
    CLGeocoder *_geocoder;

}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    [WXApi registerApp:kWeixinAppID];
    [Bmob registerWithAppKey:kBmobAppKey];
    
    
    
    //3.初始化定位对象
    _locationManager = [[CLLocationManager alloc] init];
    //初始化地理编码对象
    _geocoder = [[CLGeocoder alloc] init];
    
    //
    if (![CLLocationManager locationServicesEnabled]) {
        GFFLog(@"用户位置不可用");
    }
    //4.如果没有授权，请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate = self;
        //设置定位精度,精度越高越耗电
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        //定位频率，每隔多少米定位一次
        CLLocationDistance distance = 100.0;
        _locationManager.distanceFilter = distance;
        //启动定位服务
        [_locationManager startUpdatingLocation];
        
    }
    
    
    
    //UItabBar
   self.tabBarVC = [[UITabBarController alloc] init];
    //创建被tabarVC管理的视图控制器
   
    //主页
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *mainNav = mainStoryBoard.instantiateInitialViewController;
    mainNav.tabBarItem.image = [UIImage imageNamed:@"ft_home_normal_ic"];
    //tabBar设置选中图片， 让图片按照原始图片显示
    UIImage *selectImage = [UIImage imageNamed:@"ft_home_selected_ic"];
    
    mainNav.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //调整tabBar图片显示位置
    mainNav.tabBarItem.imageInsets = UIEdgeInsetsMake (6, 0, -6, 0);
    
    
    
    //发现
    UIStoryboard *discoverStoryBoard = [UIStoryboard storyboardWithName:@"Discover" bundle:nil];
    UINavigationController *discoverNav = discoverStoryBoard.instantiateInitialViewController;
    discoverNav.tabBarItem.image = [UIImage imageNamed:@"ft_found_normal_ic"];
   
    discoverNav.tabBarItem.imageInsets = UIEdgeInsetsMake (6, 0, -6, 0);
    //tabBar设置选中图片， 让图片按照原始图片显示
    UIImage *discoverSelectImage = [UIImage imageNamed:@"ft_found_selected_ic"];
    
    discoverNav.tabBarItem.selectedImage = [discoverSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    //我的
    UIStoryboard *mineStoryBoard  = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UINavigationController *mineNav = mineStoryBoard.instantiateInitialViewController;
    mineNav.tabBarItem.image = [UIImage imageNamed:@"ft_person_normal_ic"];
    mineNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //tabBar设置选中图片， 让图片按照原始图片显示
    UIImage *minwSelectImage = [UIImage imageNamed:@"ft_person_selected_ic"];
    
    mineNav.tabBarItem.selectedImage = [minwSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    
    
    
    self.tabBarVC.tabBar.barTintColor = [UIColor whiteColor];
    //添加被管理的试图控制器
    self.tabBarVC.viewControllers = @[mainNav, discoverNav, mineNav];
    self.window.rootViewController = self.tabBarVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark ------- shareWeibo
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
    return  [WXApi handleOpenURL:url delegate:self];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
    
    return [WeiboSDK handleOpenURL:url delegate:self];
    
    
}

#pragma mark ------------------ CLLocationMangerDelegate
/*
 定位协议代理方法
 manger 当前使用的定位对象
 location 返回当前的定位数据，是一个数组对象，数组里边元素是CLLocation类型
 
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    GFFLog(@"%@", locations);
    //从数组中取出一个定位信息
    
    CLLocation *location = [locations lastObject];
    //从CLLocation中获取坐标
 //CLLocationCoordinate2D坐标系，里边包含经度和纬度
    CLLocationCoordinate2D coordinate = location.coordinate;
    GFFLog(@"纬度：%f 经度：%f 海拔：%f 航向：%f 行走速度：%f", coordinate.latitude, coordinate.longitude, location.altitude, location.course, location.speed);
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    [userDefault setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"lat"];
    [userDefault setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"lng"];

    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        [[NSUserDefaults standardUserDefaults] setValue:placeMark.addressDictionary[@"City"] forKey:@"city"];
      //保存
        [userDefault synchronize];
        
        
    }];
    
    GFFLog(@"%@ %@", _locationManager, manager);
    //如果不需要使用定位服务的时候及时关闭定位服务
    [manager stopUpdatingLocation];
    
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
