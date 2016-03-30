//
//  LoginWebViewController.m
//  EasyHealth
//
//  Created by 王睿 on 15/12/2.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "LoginWebViewController.h"

@interface LoginWebViewController ()

@end

@implementation LoginWebViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createNavigationBar];
        [self createWebView];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    NSURL *url = nil;
    if ([_loginType isEqualToString:@"qq"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.tngou.net/api/oauth2/open/qq?client_id=%@&redirect_uri=%@&state=tngou",CLIENT_ID,REDIRECT_URL]];
    }else if ([_loginType isEqualToString:@"sina"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.tngou.net/api/oauth2/open/sina?client_id=%@&redirect_uri=%@&state=tngou",CLIENT_ID,REDIRECT_URL]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

// 创建webView
- (void)createWebView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT)];
    // 设置代理  代理方法写在单例中
    _webView.delegate = [AccountManager manager];
    [self.view addSubview:_webView];
}

- (void)createNavigationBar {
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUS_AND_NAVIGATION_HEIGHT)];
    navigationBar.backgroundColor = THEME_MAIN_COLOR;
    [self.view addSubview:navigationBar];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 20, 60, 44);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:leftButton];
}
#pragma mark - 左按钮点击事件
- (void)leftButtonClick {
    [self dismissViewControllerAnimated:YES completion:^{
        
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
