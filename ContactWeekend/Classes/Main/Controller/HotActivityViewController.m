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
#import <MBProgressHUD.h>
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
    [self showBackButton];
    

    
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
    
}
#pragma mark ------------- PUlltableViewDelegate

//向上滑动
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    _pageCount = 1;
    
}

//向下滑动

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    _pageCount += 1;
    
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载数据";
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld", KHotActivity, _pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        GFFLog(@"%@", downloadProgress);
        [hud removeFromSuperview];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSInteger code = [dic[@"code"] integerValue];
        NSString *status = dic[@"status"];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *rcData = dict[@"rcData"];
            for (NSDictionary *raDic in rcData) {
                hotModel *model = [[hotModel alloc] initWitnDictionary:raDic];
              
                [self.hotArray addObject:model];
            }
            [self.tableView reloadData];
        }
       // GFFLog(@"%@", self.hotArray);
        [hud removeFromSuperview];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GFFLog(@"%@", error);
        [hud removeFromSuperview];
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
