//
//  MainViewController.m
//  ContactWeekend
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "MainModel.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "PrefixHeader.pch"
#import "SelectCityViewController.h"
#import "searchViewController.h"
#import "ActivityViewController.h"
#import "ThemeViewController.h"
#import "ClassListViewController.h"
#import "jingActivityViewController.h"
#import "HotActivityViewController.h"

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, changeCityDelegate>
{
    NSString *cityNameId;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;//全部类表数据
@property (nonatomic, strong) NSMutableArray *activityArray;//推荐活动数据
@property (nonatomic, strong) UIScrollView *carouselView;
@property (nonatomic, strong) NSMutableArray *themeArray;//推荐专题

@property(nonatomic, strong) NSMutableArray *adArray;
@property(nonatomic, retain) UIPageControl *pageControl;
//定时器用于图片滚动播放
@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, strong) UIButton *jingxuanbtn;

@property(nonatomic, strong) UIButton *remenBtn;
@property(nonatomic, strong) UIButton *leftBtn;





@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    cityNameId = @"1";
     self.navigationController.navigationBar.barTintColor = MainColor;
    
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:96.0/255.0f green:185.0/255.0f blue:191.0/255.0f alpha:1.0];
    
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom ];
    self.leftBtn.frame = CGRectMake(0, 0, 60, 44);
    [self.leftBtn setTitle:@"北京" forState:UIControlStateNormal];
    [self.leftBtn setImage:[UIImage imageNamed:@"btn_chengshi"] forState:UIControlStateNormal];
    //调整butto图片的位置
    [self.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.leftBtn.frame.size.width - 25, 0, 0)];
    //调整Button标题所在的位置，距离btn顶部、左边、下边、右边的距离，
    [self.leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 10)];
    [self.leftBtn addTarget:self action:@selector(selectcCityAction:) forControlEvents:UIControlEventTouchUpInside];
   UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    
    //left
//    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(selectcCityAction:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
//    //right
//    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchActivity:)];
//    rightBarBtn.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = rightBarBtn;
//    
    //注册一下cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
 
      [self requestModel];
    //[self configtableData];
     [self configTableViewHeaderView];
    
 }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------- UItableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.activityArray.count;//活动
    }
    return self.themeArray.count;//专题
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableArray *array = self.listArray[indexPath.section];
    
    //防止数组越界
    if (indexPath.row < array.count) {
         mainCell.mainModel = array[indexPath.row];
    }
   
    
    return mainCell;
    
    
}
#pragma mark ------- UItableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 209;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 26;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
   UIImageView *sectionView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 160, 5, 320, 16)];
   
    if (section == 0) {
        
        sectionView.image = [UIImage imageNamed:@"home_recommed_ac"];
        

    }else{
        sectionView.image = [UIImage imageNamed:@"home_recommd_rc"];
    }
    
    [view addSubview:sectionView];
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
            MainModel *mainModel = self.listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        UIStoryboard *mainStroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ActivityViewController *activityVC = [mainStroyBoard instantiateViewControllerWithIdentifier:@"ActivityDetilVC"];
        activityVC.hidesBottomBarWhenPushed = YES;
       

        //活动id

        activityVC.activityId = mainModel.activityId;
        
        [self.navigationController pushViewController:activityVC animated:YES];
        
        
     
        
    }else{
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        //活动id
       
        themeVC.themeid = mainModel.activityId;
        
        [self.navigationController pushViewController:themeVC animated:YES];
    }
    
}
#pragma mark --------- UIbarButton
//选择城市
- (void)selectcCityAction:(UIBarButtonItem *)barbtn{
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc] init];
    selectCityVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:selectCityVC];
       
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)getChangeCityName:(NSString *)cityName cityId:(NSString *)cityId{
    cityNameId = cityId;
    [self.leftBtn setTitle:cityName forState:UIControlStateNormal];
    //如果城市名大于两个字需要调整位置
    NSInteger edge = - 20;
    if (cityName.length >2) {
        edge = - 10;
        
        
    }
    [self.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.leftBtn.frame.size.width - 20, 0, 0)];
    [self requestModel];
}
//- (void)searchActivity:(UIBarButtonItem *)barbtn{
//    searchViewController *searchVC = [[searchViewController alloc] init];
//    [self.navigationController pushViewController:searchVC animated:YES];
//}
#pragma mark --------- configTableViewHeaderView
- (void)configTableViewHeaderView{
    UIView *tableVievHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 343)];
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * i, 0, [UIScreen mainScreen].bounds.size.width, 186)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adArray[i][@"url"]] placeholderImage:nil];
        imageView.tag = 100 + i;
        imageView.userInteractionEnabled = YES;
        [self.carouselView addSubview:imageView];
        
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame= imageView.frame;
        touchBtn.tag = 100 + i;
        [touchBtn addTarget:self action:@selector(touchAdvertisement:) forControlEvents:UIControlEventTouchUpInside];
        [self.carouselView addSubview:touchBtn];
    }

       [tableVievHeaderView  addSubview:self.carouselView];
     self.pageControl.numberOfPages= self.adArray.count;
       [tableVievHeaderView addSubview:self.pageControl];
    
    //添加按钮
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * kWidth/ 4, 0, kWidth / 4, kWidth / 4);
        NSString *imagestr = [NSString stringWithFormat:@"home_icon_%02d", i + 1];
        [btn setImage:[UIImage imageNamed:imagestr] forState:UIControlStateNormal];
        
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableVievHeaderView addSubview:btn];
    }
    
#pragma mark --------- 精选活动，热门活动
    //精选活动，热门活动
    
    [tableVievHeaderView addSubview:self.jingxuanbtn];
    
    [tableVievHeaderView addSubview:self.remenBtn];

    
    self.tableView.tableHeaderView = tableVievHeaderView;
   
    
}

- (UIScrollView *)carouselView{
    //添加轮播图
    
    if (_carouselView == nil) {
    self.carouselView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 85, [UIScreen mainScreen].bounds.size.width - 20, 186)];
        
    self.carouselView.delegate = self;
    //整屏滑动
    self.carouselView.pagingEnabled = YES;
    //不要水平滚动条
    self.carouselView.showsHorizontalScrollIndicator = NO;
    self.carouselView.contentSize = CGSizeMake((self.adArray.count) * kWidth, 186);
        }
    return _carouselView;
    
}

- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        //创建一个pageControl
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(200 , 240, kWidth - 200, 30)];
        [self.pageControl  addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventTouchUpInside];
        self.pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
    }
    return _pageControl;
}
- (UIButton *)jingxuanbtn{
    if (_jingxuanbtn == nil) {
        self.jingxuanbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.jingxuanbtn.frame = CGRectMake(0, 186 + kWidth/ 4,  kWidth / 2, 343 - 186 - kWidth/ 4 ) ;
        
        [self.jingxuanbtn setImage:[UIImage imageNamed:@"home_huodong"] forState:UIControlStateNormal];
        
        self.jingxuanbtn.tag = 110;
        [self.jingxuanbtn addTarget:self action:@selector(jingxuanActivityButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jingxuanbtn;
}

- (UIButton *)remenBtn{
    if (_remenBtn == nil) {
        self.remenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.remenBtn.frame = CGRectMake( kWidth/ 2, 186 + kWidth/ 4, kWidth / 2, 343 - 186 - kWidth/ 4 ) ;
        
        [self.remenBtn setImage:[UIImage imageNamed:@"home_zhuanti"] forState:UIControlStateNormal];
        
        self.remenBtn.tag = 111;
        [self.remenBtn addTarget:self action:@selector(hotActivityButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _remenBtn;
}
//点击广告
- (void)touchAdvertisement:(UIButton *)adButton{
    //从字典取出type类型
    NSString *type = self.adArray[adButton.tag - 100][@"type"];
    
    if ([type integerValue] == 1) {
        UIStoryboard *mainStroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
    ActivityViewController *activityVC = [mainStroyBoard instantiateViewControllerWithIdentifier:@"ActivityDetilVC"];
        
    activityVC.activityId = self.adArray[adButton.tag - 100][@"id"];
    
        
    [self.navigationController pushViewController:activityVC animated:YES];
        
        
        
    }else{
        
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        themeVC.themeid = self.adArray[adButton.tag- 100][@"id"];
        [self.navigationController pushViewController:themeVC animated:YES];
    }
}
#pragma mark --------- 轮播图方法


- (void)pageControlAction:(UIPageControl *)pageControl{
    //第一步：获取pageControl在第几页
    NSInteger pageNum = pageControl.currentPage;
    //第二步获取当前页宽度
        CGFloat pageWidth  = self.carouselView.frame.size.width;
  //到达页
    self.carouselView.contentOffset = CGPointMake(pageNum * pageWidth, 0);
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //第一步：获取scrollView页面的宽度
    CGFloat pageWidth = self.carouselView.frame.size.width;
    //第二步：获取scrollView停止时候的偏移量

    CGPoint offset = self.carouselView.contentOffset;
      //第三步：通过偏移量和页面宽度计算出来当前页面
    NSInteger pageNum = offset.x / pageWidth;
    self.pageControl.currentPage = pageNum;
    
    
}

- (void)hotActivityButtonAction{
    HotActivityViewController *hotVC = [[HotActivityViewController alloc] init];
    [self.navigationController pushViewController:hotVC animated:YES];
}
- (void)jingxuanActivityButtonAction{
    jingActivityViewController *jingxuanVC = [[jingActivityViewController alloc] init];
    [self.navigationController pushViewController:jingxuanVC animated:YES];
    

}
#pragma mark --------- 四个按钮
//四个按钮
- (void)mainActivityButtonAction:(UIButton *)btn{
    ClassListViewController *classListVC = [[ClassListViewController alloc] init];
    classListVC.classifyListType = btn.tag - 100 + 1;
    [self.navigationController pushViewController:classListVC animated:YES];
    
    
    
}
- (void)requestModel{    
//    NSString *str = [NSString stringWithFormat:kMainDataList];
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    NSNumber *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lat"];
    NSNumber *lng = [[NSUserDefaults standardUserDefaults] valueForKey:@"lng"];
    [sessionManger GET:[NSString stringWithFormat:@"%@&cityid=%@&lat=%@&lng=%@", kMainDataList, cityNameId,lat, lng] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        GFFLog(@"downloadProgress = %lld",downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultdic = responseObject;
        NSString *status = resultdic[@"status"];
        NSInteger code = [resultdic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultdic[@"success"];
            NSArray *acDataArray = dic[@"acData"];//推荐活动
            if (self.activityArray.count > 0) {
                [self.activityArray removeAllObjects];
            }
            if (self.listArray.count > 0) {
                [self.listArray removeAllObjects];
            }
            for (NSDictionary *dict in acDataArray) {
                MainModel *model = [[MainModel alloc] initWithDiction:dict];
                [self.activityArray addObject:model];
            }
            [self.listArray addObject:self.activityArray];
           
            NSArray *rcDataArray = dic[@"rcData"];//推荐专题
            if (self.themeArray.count > 0) {
                [self.themeArray removeAllObjects];
            }
            for (NSDictionary *dict in rcDataArray) {
                MainModel *model = [[MainModel alloc] initWithDiction:dict];
                [self.themeArray addObject:model];
            }
            [self.listArray addObject:self.themeArray];
            NSString *cityName = dic[@"cityname"];
            //已请求回来的城市作为导航栏按钮标题
            self.navigationItem.leftBarButtonItem.title = cityName;
            [self.tableView reloadData];
            if (self.adArray.count > 0) {
                [self.adArray removeAllObjects];
            }
            NSArray *adDataArray = dic[@"adData"];//广告
            for (NSDictionary *dic in adDataArray) {
                
                NSDictionary *dict = @{@"url" : dic[@"url"], @"type" :dic[@"type"], @"id": dic[@"id"]};
                [self.adArray addObject:dict];
            }

            [self configTableViewHeaderView];
            
        }else{
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GFFLog(@"%@", error);

    }];

    [self startTimer];
    
  }

- (void)startTimer{
    if (self.timer != nil) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(rollAnimation) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//每两秒执行一次方法，图片自动轮播
- (void)rollAnimation{
    
    //数组个数可能为0，当对0取余没有意义
    if (self.adArray.count > 0) {
        
    
    //把当前页加一
     NSInteger rollPage =  (self.pageControl.currentPage + 1) % self.adArray.count;
    self.pageControl.currentPage = rollPage;
        
    //偏移量应滚蛋x柱坐标
    CGFloat offsetX = self.pageControl.currentPage * kWidth;
    [self.carouselView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

//手动scrollView滑动时候，关闭定时器， 停止scrollView滑动时候，开启定时器

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止定时器
    
    [self.timer invalidate];
    self.timer = nil;//定制定时器后并置为nil，才能保证下次成功执行
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //开启定时器
    [self startTimer];
}

#pragma mark ---------LazyLoading

- (NSMutableArray *)listArray{
    
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
        
    }
    return _listArray;
}

- (NSMutableArray *)activityArray{
    if (_activityArray == nil) {
        self.activityArray = [NSMutableArray new];
    }
    return _activityArray;
    
}
- (NSMutableArray *)adArray{
    if (_adArray == nil) {
        self.adArray = [NSMutableArray new];
    }
    return _adArray;
}
- (NSMutableArray *)themeArray{
    if (_themeArray == nil) {
        self.themeArray = [NSMutableArray new];
    }
    return _themeArray;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
