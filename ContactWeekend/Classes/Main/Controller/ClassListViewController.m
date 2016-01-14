//
//  ClassListViewController.m
//  ContactWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "ClassListViewController.h"
#import "JingXuanTableViewCell.h"
#import "PullingRefreshTableView.h"
#import "jingModel.h"
#import "ProgressHUD.h"
#import "ActivityViewController.h"

#import <AFNetworking/AFHTTPSessionManager.h>
#import "VOSegmentedControl.h"
@interface ClassListViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}


@property(nonatomic, strong) VOSegmentedControl *segmentControl;

@property(nonatomic, strong) PullingRefreshTableView *tableView;

@property(nonatomic, assign) BOOL refreshing;
//用来负责展示的数组
@property(nonatomic, strong) NSMutableArray *showDataArray;
@property(nonatomic, strong) NSMutableArray *showArray;
@property(nonatomic, strong) NSMutableArray *tourisArray;
@property(nonatomic, strong) NSMutableArray *studyArray;
@property(nonatomic, strong) NSMutableArray *famileArray;
@end

@implementation ClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageCount = 1;
    self.title = @"分类列表";
    [self showBackButton];
    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:self.segmentControl];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JingXuanTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];

    
    
    
    //按钮
    UIButton *searchbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbtn.frame = CGRectMake(0, 0, 30, 44);
    [searchbtn setImage:[UIImage imageNamed:@"btn_screening.png"] forState:UIControlStateNormal];
    
    [searchbtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarSearch = [[UIBarButtonItem alloc] initWithCustomView:searchbtn];
    
    UIButton *searchbtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbtn1.frame = CGRectMake(0, 0, 30, 44);
    
    [searchbtn1 setImage:[UIImage imageNamed:@"btn_search.png"] forState:UIControlStateNormal];
   
    [searchbtn1 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarSearch1 = [[UIBarButtonItem alloc] initWithCustomView:searchbtn1];
    
    NSArray *array = @[rightBarSearch, rightBarSearch1];
    self.navigationItem.rightBarButtonItems = array;
    
    

    [self chooseResquset];
   // [self.tableView launchRefreshing];
    
    
  }
- (void)clickAction:(UIBarButtonItem *)btn{
    
    
}

- (VOSegmentedControl *)segmentControl{
    if (_segmentControl == nil) {
        self.segmentControl = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"演出剧目"},@{VOSegmentText:@"景点场馆"},@{VOSegmentText:@"学习益智"},@{VOSegmentText:@"亲子旅游"} ]];
        
        self.segmentControl.contentStyle = VOContentStyleTextAlone;
          self.segmentControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
          self.segmentControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
          self.segmentControl.selectedBackgroundColor =   self.segmentControl.backgroundColor;
          self.segmentControl.allowNoSelection = NO;
          self.segmentControl.frame = CGRectMake(0, 0, kWidth, 44);
          self.segmentControl.indicatorThickness = 4;
        self.segmentControl.selectedSegmentIndex = self.classifyListType - 1;
         
       
     
        [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
            NSLog(@"1: block --> %@", @(index));
                   }];
      
    
        [self.segmentControl addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];

    }
    
    return _segmentControl;
}
#pragma mark ---------UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    jingModel *mainModel = self.showDataArray[indexPath.row];
    UIStoryboard *mainStroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityViewController *activityVC = [mainStroyBoard instantiateViewControllerWithIdentifier:@"ActivityDetilVC"];
    activityVC.hidesBottomBarWhenPushed = YES;
    //活动id
    
    activityVC.activityId = mainModel.activityId;
    [self.navigationController pushViewController:activityVC animated:YES];
    

    
}

#pragma mark ------- segement点击方法
- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    NSLog(@"%@: value --> %@",@(segmentCtrl.tag), @(segmentCtrl.selectedSegmentIndex));
    self.classifyListType = segmentCtrl.selectedSegmentIndex + 1;
    [self chooseResquset];
       NSLog(@"%%%%%%%%%%%%%ld",self.classifyListType);
  
   }

#pragma mark ---------- UItableViewDataSoure
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JingXuanTableViewCell *listCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    listCell.jingModel = self.showDataArray[indexPath.row];
    GFFLog(@"Model === %@",self.showDataArray );
    return listCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showDataArray.count;
}

#pragma mark ------------ UItableViewDeleagte


- (PullingRefreshTableView *)tableView{
    
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, kWidth, kHeight - 64) pullingDelegate:self];
        self.tableView.rowHeight = 120;
        self.tableView.delegate = self;
        self.tableView.dataSource =self;
    }
    
    return _tableView;
}

- (void)chooseResquset{
    switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
            [self getShowRequest];
            break;
        case ClassifyListTypeTouristPlace:
            [self getTouristRequest];
            break;
        case ClassifyListTypeStudyPUZ:
            [self getStudentRequest];
            break;
        case ClassifyListTypeTravel:
            [self getFamilyRequset];
            break;
        default:
            break;
    }
    
    
}
- (void)getShowRequest{
        AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载...."];
    //typeid = 6  //演出剧目
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassList, _pageCount, @(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
       
        NSDictionary *dic = responseObject;
        NSString *stasus = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
                if ([stasus isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acDataArray = dict[@"acData"];
                    if (self.refreshing) {
                        if (self.showArray.count > 0) {
                            [self.showArray removeAllObjects];
                        }
                    }

            for (NSDictionary *dict in acDataArray) {
                jingModel *model = [[jingModel alloc] initWithDictionary:dict];
               
                [self.showArray addObject:model];
                
            }
                    GFFLog(@"self.showArray = %@", self.showArray);
           
        }else{
            
        }//完成加载
       [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
               [self showPreviousSelectButton];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD show:[NSString stringWithFormat:@"%@",error]];
        
    }];
    
    
}
- (void)getTouristRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载...."];
    //typeid = 23  // 景点场馆
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassList,_pageCount, @(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       [ProgressHUD showSuccess:@"加载完成"];
        
        NSDictionary *dic = responseObject;
        NSString *stasus = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([stasus isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acDataArray = dict[@"acData"];
            if (self.refreshing) {
                if (self.tourisArray.count > 0) {
                    [self.tourisArray removeAllObjects];
                }
            }

            for (NSDictionary *dict in acDataArray) {
                jingModel *model = [[jingModel alloc] initWithDictionary:dict];
                [self.tourisArray addObject:model];
                
            }
            GFFLog(@"self.tourisArray = %@", self.tourisArray);
            }
        //完成加载
       [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
        [self showPreviousSelectButton];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [ProgressHUD show:[NSString stringWithFormat:@"%@",error]];
           }];
    
    
}
- (void)getStudentRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载...."];
    //typeid = 22  // 学习益智
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassList,_pageCount, @(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        
        NSDictionary *dic = responseObject;
        NSString *stasus = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([stasus isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acDataArray = dict[@"acData"];
            if (self.refreshing) {
                if (self.studyArray.count > 0) {
                    [self.studyArray removeAllObjects];
                }
            }

            for (NSDictionary *dict in acDataArray) {
                jingModel *model = [[jingModel alloc] initWithDictionary:dict];
            [self.studyArray addObject:model];
                
            }
            GFFLog(@"self.studyArray  = %@", self.studyArray);
           
        }else{
            
        }
        //完成加载
      [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
                  [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD show:[NSString stringWithFormat:@"%@",error]];
    }];
    
    
}
- (void)getFamilyRequset{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载...."];
    //typeid = 21  // 亲子旅游
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassList, _pageCount, @(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
       
        NSDictionary *dic = responseObject;
        NSString *stasus = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([stasus isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acDataArray = dict[@"acData"];
            if (self.refreshing) {
                if (self.famileArray.count > 0) {
                    [self.famileArray removeAllObjects];
                }
            }

            for (NSDictionary *dict in acDataArray) {
                jingModel *model = [[jingModel alloc] initWithDictionary:dict];
                [self.famileArray addObject:model];
                
            }
            GFFLog(@"self.famileArray = %@", self.famileArray);
        }else{
            
        }
        //完成加载
       [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
       [self.tableView reloadData];
        [self showPreviousSelectButton];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD show:[NSString stringWithFormat:@"%@",error]];
    }];
    


}
- (void)showPreviousSelectButton{
//    if (self.refreshing == NO) {//下拉刷新删除数组
//        if (self.showDataArray.count > 0) {
//            [self.showDataArray removeAllObjects];
//        }
//    }
    
    switch (self.classifyListType) {
            
        case ClassifyListTypeShowRepertoire:
        {
            self.showDataArray = self.showArray;
            GFFLog(@"111111%@", self.showDataArray);
           
        }
            break;
        case ClassifyListTypeTouristPlace:
        {
            self.showDataArray = self.tourisArray;
            GFFLog(@"222222%@", self.showDataArray);
            
        }
            break;
        case ClassifyListTypeStudyPUZ:
        {
            self.showDataArray = self.studyArray;
            GFFLog(@"333333%@", self.showDataArray);
                   }
            break;
        case ClassifyListTypeTravel:
        {
            self.showDataArray = self.famileArray;
            GFFLog(@"444444%@", self.showDataArray);
          
        }
            break;
            
        default:
            break;
    }
    
    //完成加载
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    [self.tableView reloadData];
    
    
   }


//向上拉刷新


- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.refreshing = NO;

    [self performSelector:@selector(chooseResquset) withObject:nil afterDelay:1.0];
    _pageCount += 1;

}
//向下刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;

       [self performSelector:@selector(chooseResquset) withObject:nil afterDelay:1.0];
    
    _pageCount = 1;
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTool getSystemNowDate];
}

//手指开始拖动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.tableView tableViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.tableView tableViewDidEndDragging:scrollView];
}


- (NSMutableArray *)showDataArray{
    if (_showDataArray == nil) {
        self.showDataArray = [NSMutableArray new];
    }
    return _showDataArray;
    
    
}
- (NSMutableArray *)showArray{
    if (_showArray == nil) {
        self.showArray = [NSMutableArray new];
    }
    return _showArray;

}
- (NSMutableArray *)tourisArray{
    if (_tourisArray == nil) {
        self.tourisArray = [NSMutableArray new];
    }
    return _tourisArray;
}
- (NSMutableArray *)studyArray{
    if (_studyArray == nil) {
        self.studyArray = [NSMutableArray new];
    }
    return _studyArray;
}
- (NSMutableArray *)famileArray{
    if (_famileArray == nil) {
        self.famileArray = [NSMutableArray new];
    }
    return _famileArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidAppear:animated];
    //将页面消失时去掉加载
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
