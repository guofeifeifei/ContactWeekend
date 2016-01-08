//
//  jingActivityViewController.m
//  ContactWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "jingActivityViewController.h"
#import "PullingRefreshTableView.h"
#import "JingTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
@interface jingActivityViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;//请求的页码
}
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, assign) BOOL refreshing;


@end

@implementation jingActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"精选活动";
    self.view.backgroundColor = [UIColor yellowColor];
    [self showBackButton];
    self.tabBarController.tabBar.hidden = YES;
      [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"JingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
  
    [self.tableView launchRefreshing];
    
    
}
#pragma mark ------- UITableViewDataSource 2各方

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JingTableViewCell *jingcell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    jingcell.backgroundColor = [UIColor brownColor];
    return jingcell;

    
    
}

#pragma mark ---------UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark ----------PullingRefreshDelegate
//tableView下拉开始刷新的时候
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    _pageCount = 1;
    
    
}

//上拉刷新
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    _pageCount +=1;
}
//加载数据
- (void)loadData{
       AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [sessionManger GET:[NSString stringWithFormat:@"%@&page=%ld", KGoodActivity, _pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    GFFLog(@"12312");
    //完成加载
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    
    
    
    
    
    
    
    
}

//手指开始拖动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
//手指定制拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];

}

#pragma mark ----------- LazyLoading
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) pullingDelegate:self];
        self.tableView.rowHeight = 90;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTool getSystemNowDate];
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
