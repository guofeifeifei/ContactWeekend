//
//  ActivityViewController.m
//  ContactWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "ActivityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <MBProgressHUD.h>
#import "ActivityDetailView.h"
@interface ActivityViewController ()

@property (strong, nonatomic) IBOutlet ActivityDetailView *activityDetailView;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";

   [self showBackButton];
   [self getModel];
      //self.tabBarController.hidesBottomBarWhenPushed = YES;
    
}

#pragma mark Custom Method
- (void)getModel{
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    
    sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [sessionManger GET:[NSString stringWithFormat:@"%@&id=%@",kActivityDetail, self.activityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
      //   [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"downloadProgress = %@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
          
            self.activityDetailView.dataDic= successDic;
            
            
        }else{
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      //  [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error = %@", error);
    }];
    
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
