//
//  LoginViewController.m
//  EasyHealth
//
//  Created by 王睿 on 15/12/9.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "LoginWebViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (strong, nonatomic) IBOutlet UIView *NavLabel;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *qqButton;
@property (strong, nonatomic) IBOutlet UIButton *sinaButton;

@end

@implementation LoginViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 把一级登录界面赋给单例 登录成功推出
        [AccountManager manager].loginViewController = self;
    }
    return self;
}

- (IBAction)qqLogin:(id)sender {
    LoginWebViewController *lvc = [[LoginWebViewController alloc] init];
    lvc.loginType = @"qq";
    [self presentViewController:lvc animated:YES completion:nil];
}
- (IBAction)sinaLogin:(id)sender {
    LoginWebViewController *lvc = [[LoginWebViewController alloc] init];
    lvc.loginType = @"sina";
    [self presentViewController:lvc animated:YES completion:nil];
}
- (IBAction)tngouLogin:(id)sender {
    [self checkNetWork:^{
        [MBProgressHUD showMessage:@"登录中" toView:self.view];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{
                                     @"client_id":CLIENT_ID,
                                     @"client_secret":CLIENT_SECRET,
                                     @"name":_userName.text,
                                     @"password":_userPassword.text
                                     };
        [manager GET:API_ACCOUNT_LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"status"] intValue]) {
                // 登录成功
                [AccountManager manager].login = YES;
                [AccountManager manager].access_token = responseObject[@"access_token"];
                // 调用单例中登录成功block
                [AccountManager manager].loginSuccess([[AccountManager manager] getUserInfo]);
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [MBProgressHUD showSuccess:@"登录成功"];
                // 登录成功 退出登录页面
                [self dismissViewControllerAnimated:YES completion:nil];
            }else {
                // 登录失败
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [MBProgressHUD showError:responseObject[@"msg"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:@"登录失败"];
        }];
    }];
}
- (IBAction)gotoRegister:(id)sender {
    RegisterViewController *registerVc = [[RegisterViewController alloc] init];
    registerVc.loginViewController = self;
    [self presentViewController:registerVc animated:YES completion:nil];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _NavLabel.backgroundColor=THEME_MAIN_COLOR;
    _userName.layer.borderColor=[UIColor colorWithRed:0.27 green:0.76 blue:0.96 alpha:1].CGColor;
    _userName.layer.borderWidth=3.0f;
    _userName.layer.cornerRadius=3.0f;
    _userPassword.layer.borderColor=[UIColor colorWithRed:0.27 green:0.76 blue:0.96 alpha:1].CGColor;
    _userPassword.layer.borderWidth=3.0f;
    _userPassword.layer.cornerRadius=3.0f;
    _loginButton.backgroundColor=THEME_MAIN_COLOR;
    _loginButton.layer.cornerRadius=8.0;
    _qqButton.layer.cornerRadius=10.0f;
    _qqButton.clipsToBounds=YES;
    _sinaButton.layer.cornerRadius=10.0f;
    _sinaButton.clipsToBounds=YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_userName resignFirstResponder];
    [_userPassword resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
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
