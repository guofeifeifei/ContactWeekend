//
//  LoginViewController.m
//  ContactWeekend
//
//  Created by scjy on 16/1/15.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = MainColor;
    
    [self showBackButtonWithImage:@"back"];
    
    
}

- (void)backButtonAction:(UIButton *)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginAction:(id)sender {
    [BmobUser loginWithUsernameInBackground:self.userNameText.text password:self.passwordText.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            GFFLog(@"%@", user);
            GFFLog(@"登陆成功");
        }
        
    }];
    
    GFFLog(@"没有登录成功");
}
//点击右下角回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//点击页面空白处回收键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}


//增加
- (IBAction)addOneData:(id)sender {
    //往GameScore表添加一条playerName为小明，分数为78的数据
    BmobObject *user = [BmobObject objectWithClassName:@"MemberUser"];
    [user setObject:@"极限女孩" forKey:@"user_Name"];
    [user setObject:@18 forKey:@"user_Age"];
    [user setObject:@"女" forKey:@"user_Gender"];
    [user setObject:@"18852044421" forKey:@"user_cellPhone"];
    [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
                GFFLog(@"恭喜注册成功");
    }];
    
    
    
    
}
//查找
- (IBAction)queryData:(id)sender {
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"MemberUser"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"1a242b5433" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到playerName和cheatMode
                NSString *userName = [object objectForKey:@"user_Name"];
                NSString *userAge = [object objectForKey:@"user_Age"];
                NSLog(@"%@----%@",userName,userAge);
            }
        }
    }];
    
    
    
    
}
//更新数据
- (IBAction)delegateData:(id)sender {
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"MemberUser"];
    [bquery getObjectInBackgroundWithId:@"1a242b5433" block:^(BmobObject *object, NSError *error){
        if (error) {
            //进行错误处理
        }
        else{
            if (object) {
                //异步删除object
                [object deleteInBackground];
            }
        }
    }];
}
- (IBAction)xiugaiData:(id)sender {
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"MemberUser"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"0dd07d124d" block:^(BmobObject *object,NSError *error){
        //没有返回错误
        if (!error) {
            //对象存在
            if (object) {
                BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                //设置cheatMode为YES
                [obj1 setObject:@"霓虹灯" forKey:@"user_Name"];
                //异步更新数据
                [obj1 updateInBackground];
            }
        }else{
            //进行错误处理
        }
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
