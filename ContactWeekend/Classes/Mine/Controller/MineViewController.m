//
//  MineViewController.m
//  ContactWeekend
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "MineViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <MessageUI/MessageUI.h>
#import "ProgressHUD.h"

#import "ShareView.h"
@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *headImageButton;
@property(nonatomic, strong) NSArray *imageArray;
@property(nonatomic, strong) NSMutableArray *titleArray;
@property(nonatomic, strong) UILabel *nikeNameLable;
@property(nonatomic, strong) UIView *blackView;
@property(nonatomic, strong) UIView *shareView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self setUpTableViewHeaderView];
    self.navigationController.navigationBar.barTintColor = MainColor;
    

    self.imageArray = @[@"xingchu", @"icon_msgs", @"icon_likes", @"list_selecteds", @"icon_orders"];
   
  
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除缓存", @"用户反馈", @"分享给好友", @"给我评分", @"当前版本1.0", nil];
                                    
}
- (UIButton *)headImageButton{
    if (_headImageButton == nil) {
        self.headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headImageButton.frame = CGRectMake(20, 40, 130, 130);
        [self.headImageButton setTitle:@"注册/登陆" forState:UIControlStateNormal];
        [self.headImageButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        self.headImageButton.layer.cornerRadius = 65;
        [self.headImageButton setBackgroundColor:[UIColor whiteColor]];
        [self.headImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.headImageButton.clipsToBounds = YES;
    }
    return _headImageButton;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //每次当页面将要出现的时候重新计算图片缓存
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    
    NSString *cacheStr = [NSString stringWithFormat:@"清除缓存(%.02f)M",(float)cacheSize/1024/1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *indePath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indePath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)share{
    UIWindow *window = [[UIApplication sharedApplication ].delegate window];
    
    ShareView *shareView = [[ShareView alloc] init];
    [window addSubview:shareView];
    return;


}

//- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
//    NSString *title = nil;
//    UIAlertView *alert = nil;
//    title = NSLocalizedString(@"收到网络回调", nil);
//    alert = [[UIAlertView alloc] initWithTitle:title message:[NSString stringWithFormat:@"%@", result] delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
//    
//    [alert show];
//    
//}
//- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
//    NSString *title = nil;
//    UIAlertView *alert = nil;
//    title = @"请求异常";
//    alert = [[UIAlertView alloc] initWithTitle:title message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alert show];
//    
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            
            [ProgressHUD show:@"正在为您清理中"];
            [self performSelector:@selector(clearImage) withObject: nil afterDelay:5.0];

        }
            break;
        case 1:{
            [self sendEmail];
        }
            break;
        case 2:{
            [self share];
           
        }
            break;
            
            
            
        case 3:{
            
            NSString *str = [NSString stringWithFormat:
                             
                             @"itms-apps://itunes.apple.com/app"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }
            break;
        case 4:{
            //设置当前版本
            [ProgressHUD show:@"正在为您检测"];
            [self performSelector:@selector(checkAppVersion) withObject:nil afterDelay:2.0];
            
            
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    
    
    
    
    
}
- (void)clearImage{
    [ProgressHUD showSuccess:@"清理干净"];
    GFFLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearDisk];
    [self.titleArray replaceObjectAtIndex:0 withObject:@"清除缓存"];
    NSIndexPath *indePath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indePath] withRowAnimation:UITableViewRowAnimationFade];
    
    
}
- (void)sendEmail{
    Class mailClass = NSClassFromString(@"MFMailComposeViewController");
    if (mailClass != nil) {
        if ([MFMailComposeViewController canSendMail]) {
            //初始化发送邮件
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            //设置代理
            picker.mailComposeDelegate = self;
            //设置主题
            [picker setSubject:@"用户反馈"];
            //设置收件人
            NSArray *receiveArray = [NSArray arrayWithObjects:@"2545706530@qq.com", nil];
            [picker setToRecipients:receiveArray];
            //发送内容
            NSString *text = @"请留下您宝贵的意见";
            [picker setMessageBody:text isHTML:YES];
            //推出视图
           [self presentViewController:picker animated:YES completion:nil];
            

        }else{
            GFFLog(@"未配置邮箱账号");
            
        }
    }else{
        GFFLog(@"当前设备不能发送");
    }
    
    
    
    
    
}


//邮件发送完成调用此方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled://取消
            GFFLog(@"MFMailComposeResultCancelled取消");
            break;
            case MFMailComposeResultSaved://保存
            GFFLog(@"MFMailComposeResultSaved保存邮件");
            break;
            case MFMailComposeResultSent://发送
        {
            GFFLog(@"MFMailComposeResultSent发送");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮件发送成功" message:@"邮件发送成功，谢谢您的宝贵意见，我将认真改进" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.delegate = self;
            [alert show];
        }
            break;
            case MFMailComposeResultFailed://失败
            GFFLog(@"MFMailComposeResultFailed发送失败");
            break;
        default:
            break;
    }
    
    
}
//返回页面
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)checkAppVersion{
    [ProgressHUD showSuccess:@"当前已是最新版本"];
}
- (void)login{
    
    
}
- (UILabel *)nikeNameLable{
    if (_nikeNameLable == nil) {
        self.nikeNameLable = [[UILabel alloc] initWithFrame:CGRectMake(180, 90, kWidth - 200, 40)];
        self.nikeNameLable.numberOfLines = 0;
        self.nikeNameLable.text = @"欢迎来到 触点周末";
        self.nikeNameLable.textColor = [UIColor whiteColor];
    }
    return _nikeNameLable;
    
    
}
- (void)setUpTableViewHeaderView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 210)];
    headView.backgroundColor = MainColor;
    [headView addSubview:self.headImageButton];
    [headView addSubview:self.nikeNameLable];
    self.tableView.tableHeaderView = headView;
    
    
    
}
#pragma mark ------------ UItableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.titleArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64-44) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
       
        
    }
    return _tableView;
    
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
