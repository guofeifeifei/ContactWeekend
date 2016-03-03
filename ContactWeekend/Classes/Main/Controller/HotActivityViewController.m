//
//  HotActivityViewController.m
//  ContactWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "HotActivityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "HotTableViewCell.h"

#import "hotModel.h"
#import "ThemeViewController.h"
#import "PullingRefreshTableView.h"

@interface HotActivityViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    
    NSInteger _pageCount;
}
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) NSMutableArray *hotArray;
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@end

@implementation HotActivityViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"热门专题";
    [self showBackButtonWithImage:@"back"];
    

    
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HotTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView launchRefreshing];
    
}
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) pullingDelegate:self];
        self.tableView.rowHeight = 200;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = [UIColor whiteColor];
    }
    return _tableView;
}
#pragma mark ------------- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hotArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HotTableViewCell *hotcell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath ];
   
    hotcell.hotModel = self.hotArray[indexPath.row];
    return hotcell;
    
}

#pragma mark ------------UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeViewController *themeVC = [[ThemeViewController alloc] init];
    hotModel *model = self.hotArray[indexPath.row];
    themeVC.themeid = model.hotId;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:themeVC animated:YES];
    
    
}
#pragma mark ------------- PUlltableViewDelegate

//向上滑动
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    
    self.refreshing = NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    _pageCount += 1;
    
}

//向下滑动

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    _pageCount = 1;
    
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTool getSystemNowDate];
}


//手指开始拖动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}


#pragma mark ------------- loadData

- (void)loadData{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
       [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld", KHotActivity, (long)_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        GFFLog(@"%@", downloadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSInteger code = [dic[@"code"] integerValue];
        NSString *status = dic[@"status"];
        
        //如果向上拉删除数组
        if (self.refreshing) {
            if (self.hotArray.count > 0) {
                [self.hotArray removeAllObjects];
            }
        }
        
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *rcData = dict[@"rcData"];
            for (NSDictionary *raDic in rcData) {
                hotModel *model = [[hotModel alloc] initWitnDictionary:raDic];
              
                [self.hotArray addObject:model];
            }
            [self.tableView reloadData];
        }else{
            
        }
       // GFFLog(@"%@", self.hotArray);
                
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GFFLog(@"%@", error);
        
    }];
    
    
    
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    
    
}
- (NSMutableArray *)hotArray{
    if (_hotArray == nil) {
        self.hotArray = [NSMutableArray new];
    }
    return _hotArray;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
