//
//  SelectCityViewController.m
//  ContactWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "SelectCityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "HeaderCollectionReusableView.h"
#import "ProgressHUD.h"
#import "SelectCityCollectionViewCell.h"
#import <CoreLocation/CoreLocation.h>
static NSString *itemIdentifier = @"itemIdentifier";
static NSString *headIdentifier = @"HeaderView";
@interface SelectCityViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
}

@property(nonatomic, strong) NSMutableArray *cityListArray;
@property(nonatomic, strong) UICollectionView *collection;
@property(nonatomic, strong) NSMutableArray *cityListId;



@end

@implementation SelectCityViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"切换城市";
    [self showBackButtonWithImage:@"cancle"];
    self.navigationController.navigationBar.barTintColor = MainColor;
    [self loadData];
    
    
    [self.view addSubview:self.collection];
}




- (void)loadData{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager POST:[NSString stringWithFormat:@"%@", selectCity] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        GFFLog(@"%@", uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载数据成功"];
        //GFFLog(@"%@", responseObject);
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *listArray = successDic[@"list"];
            for (NSDictionary *dic in listArray) {
                [self.cityListArray addObject:dic[@"cat_name"]];
                [self.cityListId addObject:dic[@"cat_id"]];
            }
            GFFLog(@"%@", self.cityListArray);
            [self.collection reloadData];
            //GFFLog(@"success===%@", self.dict);
        }
        
        else{
            
            GFFLog(@"网络异常");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"请求异常"];
        GFFLog(@"%@", error);
    }];
    
}
#pragma mark ------- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cityListArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   SelectCityCollectionViewCell *cell = (SelectCityCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"itemIdentifier" forIndexPath:indexPath];
    
    cell.lable.text  = self.cityListArray[indexPath.row];
    
    return cell;
}

- (void)selectItemAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition{
    scrollPosition = UICollectionViewScrollPositionTop;
}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    
//}

/*
 iOS常见传值方法
 1.属性传值
 2.代理传值
 3.block
 4.单例
 5.NSDotification通知传值
 6.KVO
 7.指针传值
 8.NSUserDefault、数据库
 
 
 
 */
#pragma mark -------- 点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getChangeCityName:cityId:)]) {
        [self.delegate getChangeCityName:self.cityListArray[indexPath.row] cityId:self.cityListId[indexPath.row]];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
   
}

#pragma mark ------- lazy loading
- (UICollectionView *)collection{
    if (_collection == nil) {
      //创建一个layout布局类
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向(默认垂直方向)
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置每个Item的大小
        layout.itemSize = CGSizeMake(120, 50);
        //设置区头大小
        [layout setHeaderReferenceSize:CGSizeMake(kWidth, 150)];
       // layout.headerReferenceSize = CGSizeMake(kWidth, 150);
        //通过一个layouy布局策略来创建UICollectionView
        self.collection = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        self.collection.delegate = self;
        self.collection.dataSource = self;
      
        //行间距
        layout.minimumLineSpacing = 3;
        //section的边距
        layout.minimumInteritemSpacing = 1;
        //section的边距
        layout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
        self.collection.backgroundColor = [UIColor whiteColor];
        //注册item类型单元格
        [self.collection registerClass:[SelectCityCollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
        
        //注册头部视图
//        [self.collection registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentifier];
        [self.collection registerNib:[UINib nibWithNibName:@"HeaderCollectionReusableView" bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentifier];
        self.collection.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235/ 255.0 blue:241/ 255.0 alpha:1.0];
        
    }
    
    return _collection;
    
}
- (NSMutableArray *)cityListArray{
    if (_cityListArray == nil) {
        self.cityListArray = [NSMutableArray new];
    }
    return _cityListArray;
    
    
}
- (NSMutableArray *)cityListId{
    if (_cityListId == nil) {
        self.cityListId = [NSMutableArray new];
    }
    return _cityListId;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HeaderCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentifier forIndexPath:indexPath];
    //得到当前城市
    NSString *city = [[NSUserDefaults standardUserDefaults] valueForKey:@"city"];
    
    //把“市“截取掉
    [city substringFromIndex:city.length - 1];
    //定位城市标签
    headView.nowLocationCityLable.text = city;
    
    
    
    //重新定位按钮方法
    [headView.reLocationBtn addTarget:self action:@selector(relocationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return headView;
}

- (void)relocationAction:(UIButton *)btn{
    [ProgressHUD showSuccess:@"开始定位"];
    
    _locationManager = [[CLLocationManager alloc] init];
    //设置代理
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy  = kCLLocationAccuracyNearestTenMeters;
    CLLocationDistance distance = 10.0;
    
    _locationManager.distanceFilter = distance;
    //开始定位
    [_locationManager startUpdatingLocation];
    _geocoder = [[CLGeocoder alloc] init];
    
    
    
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSUserDefaults *userDefaul = [NSUserDefaults standardUserDefaults];
    [userDefaul setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"lat"];
    [userDefaul setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"lng"];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        [[NSUserDefaults standardUserDefaults] setValue:placeMark.addressDictionary[@"City"] forKey:@"city"];
        //保存
        [userDefaul synchronize];
        
        
    }];
    
    GFFLog(@"%@ %@", _locationManager, manager);
    //如果不需要使用定位服务的时候及时关闭定位服务
    [manager stopUpdatingLocation];

    
    
    
    
}

#pragma mark ------- Custom Method

- (void)backButtonAction:(UIButton *)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    [ProgressHUD dismiss];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
