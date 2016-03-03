//
//  RegisterViewController.m
//  ContactWeekend
//
//  Created by scjy on 16/3/2.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "RegisterViewController.h"
#import <BmobSDK/BmobUser.h>
#import "ProgressHUD.h"
@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *passwordSwith;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"back"];
    //密码密文显示
    self.passWordText.secureTextEntry = YES;
    self.againPasswordText.secureTextEntry = YES;
    //默认密文关闭
    self.passwordSwith.on = NO;
    
}
//点击右下角回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//点击页面空白处回收键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   // [self.view endEditing:YES];
    
    //第二中方法
    [self.UserNameText resignFirstResponder];
    [self.passWordText resignFirstResponder];
    [self.againPasswordText resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)passwordSwithAction:(id)sender {
    UISwitch *password = sender;
    if (password.on) {
        self.passWordText.secureTextEntry = NO;
        self.againPasswordText.secureTextEntry = NO;
    }else{
    self.passWordText.secureTextEntry = YES;
    self.againPasswordText.secureTextEntry = YES;
    }
}
- (IBAction)sendVerifyNumberAction:(id)sender {
   
    
    
}
- (IBAction)regeisterAction:(id)sender {
    
    if (![self checkout]) {
        return;
    }
    [ProgressHUD show:@"正在为您注册"];
    BmobUser *bUser = [[BmobUser alloc] init];
    
    [bUser setUsername:self.UserNameText.text];
    [bUser setPassword:self.passWordText.text];
    [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [ProgressHUD showSuccess:@"注册成功"];
            GFFLog(@"注册成功");
            
        }else{
            [ProgressHUD showError:@"注册失败"];
            GFFLog(@"注册失败");
        }
    }];
}
//注册之前判断
- (BOOL)checkout{
    //用户名不能为空或者不能为空格
    if (self.UserNameText.text.length <= 0   || [self.UserNameText.text stringByReplacingOccurrencesOfString:@" " withString:@""] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"亲情提示" message:@"用户名不能为空或者空格" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
        return NO;
        
    }
    //两次密码一致
    if (![self.passWordText.text isEqualToString:self.againPasswordText.text]) {
        //alert提示框 密码不一一致
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"亲情提示" message:@"密码输入不一致" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
      
        
        
        return NO;
        
    }
    
    //密码一样，判断是否为空
    if (self.passWordText.text.length <= 0 || [self.passWordText.text stringByReplacingOccurrencesOfString:@" " withString:@""] <= 0) {
        //alert 密码不能为空
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"亲情提示" message:@"密码不能空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return NO;
    }
    
    
    //判断手机号是否有效（正则表达式）
    //判断输入邮箱是否是邮箱
    return YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
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
