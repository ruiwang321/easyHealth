//
//  BasicViewController.m
//  easyHealthy
//
//  Created by 王睿 on 15/11/26.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@property (nonatomic, weak) NetConnectSuccess netConnectionSuccess;

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor=THEME_MAIN_COLOR;
    [self setBackItem];
}
//设置title的颜色为白色
- (UILabel *)setTitleColor:(NSString *)title withFrame:(CGRect)frame{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    return titleLabel;
}
//设置backItem
- (void)setBackItem {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    backItem.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
}
#pragma mark - 这里进行网络判断

- (void)checkNetWork:(NetConnectSuccess)netConnectSuccess {
    
    //得到了一个检测网络的一个单例
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //启动监听
    [manager startMonitoring];
    
    //网络状态发生改变的回调
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        _netConnectionSuccess = netConnectSuccess;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
              //未知
              
                _netConnectionSuccess();
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
              //没网
                [MBProgressHUD showError:@"网络连接失败"];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
              //3G/4G
                _netConnectionSuccess();
    
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
              //wifi
                _netConnectionSuccess();
               
            }
                break;
                
            default:
                break;
        }
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden=NO;
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
