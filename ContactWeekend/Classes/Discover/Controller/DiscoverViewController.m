//
//  DiscoverViewController.m
//  ContactWeekend
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewCell.h"
#import "PullingRefreshTableView.h"
#import "ProgressHUD.h"
#import "DiscoverModel.h"
#import "ActivityViewController.h"
#import "DiscoverModel.h"
#import <AFNetworking/AFHTTPSessionManager.h>
@interface DiscoverViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) NSMutableArray *likeArray;

@property(nonatomic, assign) BOOL refreshing;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoverTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView launchRefreshing];
     self.navigationController.navigationBar.barTintColor = MainColor;
    [self getRequestData];
   
}
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) pullingDelegate:self];
      
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //旋转90度
//        self.tableView.transform = CGAffineTransformMakeRotation(M_PI/2);
        self.tableView.tableFooterView = [[UIView alloc] init];
        
        //只有上边的下拉刷新
        [self.tableView setHeaderOnly:YES];
        self.tableView.rowHeight = 80;
       //self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return _tableView;
    
}
//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(getRequestData) withObject:nil afterDelay:1.0];
    
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
    
}
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTool getSystemNowDate];
}
#pragma mark ------------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.likeArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//       cell.transform = CGAffineTransformMakeRotation(M_PI/2 * 3);
    cell.model = self.likeArray[indexPath.row];
    
    return cell;
    
    
}
#pragma mark ----------- UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    DiscoverModel *model = self.likeArray[indexPath.row];
    UIStoryboard *mainStroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityViewController *activityVC = [mainStroyBoard instantiateViewControllerWithIdentifier:@"ActivityDetilVC"];
    activityVC.hidesBottomBarWhenPushed = YES;
    activityVC.activityId = model.activityId;
    [self.navigationController pushViewController:activityVC animated:YES];

    
}



- (void)getRequestData{
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];
    [sessionManger GET:[NSString stringWithFormat:@"%@", kDiscover] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        GFFLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *like = dict[@"like"];
            for (NSDictionary *likeDic in like) {
                DiscoverModel *model = [[DiscoverModel alloc] initWithDictionary:likeDic];
                [self.likeArray addObject:model];
            }
            
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
            
            [self.tableView reloadData];
            GFFLog(@"%@", self.likeArray);
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD show:[NSString stringWithFormat:@"%@", error]];
        GFFLog(@"%@", error);
    }];
    
  

}
- (NSMutableArray *)likeArray{
    if (_likeArray == nil) {
        self.likeArray = [NSMutableArray new];
    }
    return _likeArray;
    
    
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
