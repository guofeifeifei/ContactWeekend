//
//  UIViewController+Common.m
//  ContactWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)

//导航栏添加返回按钮
- (void)showBackButtonWithImage:(NSString *)imageName{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame  = CGRectMake(0, 0, 44, 44);
    
    if ([imageName isEqualToString:@"cancle"]) {
        [backBtn setImage:[UIImage imageNamed:@"camera_cancel_up"] forState:UIControlStateNormal];
    } else{
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [backBtn addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;

}
- (void)backButtonAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
