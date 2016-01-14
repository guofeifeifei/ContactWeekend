//
//  SelectCityViewController.m
//  ContactWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "SelectCityViewController.h"

@interface SelectCityViewController ()

@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"切换城市";
    self.view.backgroundColor = [UIColor redColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kWidth, kHeight);
    [button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"新年快乐,您是一位有好运的人" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:25.0f];
    [self.view addSubview:button];
    
}
- (void)clickAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
