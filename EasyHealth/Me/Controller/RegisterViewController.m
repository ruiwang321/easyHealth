//
//  RegisterViewController.m
//  EasyHealth
//
//  Created by 王睿 on 15/12/9.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation RegisterViewController
- (IBAction)registerAccount:(id)sender {
    [self checkNetWork:^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{
                                     @"client_id":CLIENT_ID,
                                     @"client_secret":CLIENT_SECRET,
                                     @"email":_userEmail.text,
                                     @"account":_userName.text,
                                     @"password":_userPassword.text
                                     };
        [manager GET:API_ACCOUNT_REGISTER parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSLog(@"%@",responseObject[@"msg"]);
            if ([responseObject[@"status"] intValue]) {
                //注册成功 直接登录
                [MBProgressHUD showSuccess:@"注册成功"];
                [AccountManager manager].login = YES;
                [AccountManager manager].access_token = responseObject[@"access_token"];
                [AccountManager manager].loginSuccess([[AccountManager manager] getUserInfo]);
                [self dismissViewControllerAnimated:NO completion:^{
                    // 推出一级登录界面
                    [_loginViewController dismissViewControllerAnimated:NO completion:nil];
                }];
            }else {
                [MBProgressHUD showError:responseObject[@"msg"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)beautifyUI {
    _userName.layer.borderColor=[UIColor colorWithRed:0.27 green:0.76 blue:0.96 alpha:1].CGColor;
    _userName.layer.borderWidth=3.0f;
    _userName.layer.cornerRadius=3.0f;
    _userPassword.layer.borderColor=[UIColor colorWithRed:0.27 green:0.76 blue:0.96 alpha:1].CGColor;
    _userPassword.layer.borderWidth=3.0f;
    _userPassword.layer.cornerRadius=3.0f;
    _userEmail.layer.borderColor=[UIColor colorWithRed:0.27 green:0.76 blue:0.96 alpha:1].CGColor;
    _userEmail.layer.borderWidth=3.0f;
    _userEmail.layer.cornerRadius=3.0f;
    _loginButton.backgroundColor=THEME_MAIN_COLOR;
    _loginButton.layer.cornerRadius=8.0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self beautifyUI];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_userEmail resignFirstResponder];
    [_userName resignFirstResponder];
    [_userPassword resignFirstResponder];
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
