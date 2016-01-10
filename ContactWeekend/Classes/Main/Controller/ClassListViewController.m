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
#import <MBProgressHUD.h>

#import <AFNetworking/AFHTTPSessionManager.h>

@interface ClassListViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}


@property(nonatomic, strong) UISegmentedControl *segmentControl;

@property(nonatomic, strong) PullingRefreshTableView *tableView;

@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) NSMutableArray *allArray;
@end

@implementation ClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分类列表";
    [self showBackButton];
    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:self.segmentControl];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JingXuanTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];

     [self.tableView launchRefreshing];
    
}
- (UISegmentedControl *)segmentControl{
    if (_segmentControl == nil) {
        self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"演出剧目", @"景点场馆", @"学习益智", @"亲子旅游"]];
        self.segmentControl.selectedSegmentIndex = self.selectIndex;
        self.segmentControl.frame = CGRectMake(0, 0, kWidth, 44);
        self.segmentControl.momentary = NO;
        [self.segmentControl addTarget:self action:@selector(segmentTapaction:) forControlEvents:UIControlEventValueChanged];

    }
    return _segmentControl;
    
}
#pragma mark ---------UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark ------- segement点击方法
- (void)segmentTapaction:(UISegmentedControl *)segment{
    
   
    switch (segment.selectedSegmentIndex) {
        case 0:{
            self.buttonId = @"6";
            
        }
            break;
        case 1:{
            self.buttonId = @"23";
           
        }  break;
        case 2:{
            self.buttonId = @"22";
                  }   break;
        case 3:{
            self.buttonId = @"21";
           
        }break;
        default:
            break;
    }
   self.allArray = nil;
    [self.tableView reloadData];
  
    [self loadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JingXuanTableViewCell *listCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    listCell.jingModel = self.allArray[indexPath.row];
    return listCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allArray.count;
}

- (PullingRefreshTableView *)tableView{
    
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, kWidth, kHeight - 64) pullingDelegate:self];
        self.tableView.rowHeight = 120;
        self.tableView.delegate = self;
        self.tableView.dataSource =self;
        
        
        
        
    }
    
    return _tableView;
}
//向上拉刷新
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;

    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    _pageCount = 1;

}
//向下刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;

       [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    
    _pageCount += 1;
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTool getSystemNowDate];
}
- (void)loadData{
    
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载数据";
    
    [sessionManger GET:[NSString stringWithFormat:@"%@&typeid=%@", kButtonActivity, self.buttonId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        [hud removeFromSuperview];
       GFFLog(@"downloadProgress = %@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acData = dict[@"acData"];
            for (NSDictionary *acDatadic in acData) {
                jingModel *model = [[jingModel alloc] initWithDictionary:acDatadic];
                [self.allArray addObject:model];
            }
            
            [self.tableView reloadData];
              [hud removeFromSuperview];
        }
        
    GFFLog(@"self.allArray = %@", self.allArray);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         GFFLog(@"%@", error);
        
          [hud removeFromSuperview];
    }];
    
    
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    
}

//手指开始拖动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.tableView tableViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.tableView tableViewDidEndDragging:scrollView];
}

- (NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
    
    
    
    
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
