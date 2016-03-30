//
//  AccountManager.m
//  EasyHealth
//
//  Created by 王睿 on 15/12/1.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "AccountManager.h"
#import "LoginWebViewController.h"
#import "UIView+Extent.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"
#import "LoginViewController.h"

@implementation AccountManager {
    SaveAndShareModel *_saveAndShareModel;
    UIButton *_saveButton;
}

+ (instancetype)manager {
    return [[self alloc] init];
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static AccountManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
        manager.login = NO;
    });
    return manager;
}
#pragma mark - webView代理方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlStr = request.URL.absoluteString;
    // 获取access_token
    NSRange range = [urlStr rangeOfString:@"code="];
    if (range.length > 0) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSRange qqRang = [urlStr rangeOfString:@"qq"];
        NSRange sinaRang = [urlStr rangeOfString:@"sina"];
        if (qqRang.length > 0 || sinaRang.length > 0) {

            return YES;
            
        }else {
            // 切割结果 获取URL
            NSString *result = [urlStr substringFromIndex:range.location + range.length];
//            NSLog(@"%@",result);
            NSString *code = [[result componentsSeparatedByString:@"&"] firstObject];
//            NSLog(@"%@",code);
            [AccountManager manager].code = code;
            NSDictionary *parament = @{
                                     @"client_id"       :CLIENT_ID,
                                     @"client_secret"   :CLIENT_SECRET,
                                     @"code"            :_code
                                     };
            
            [manager GET:API_ACCOUNT_ACCESSTOKEN parameters:parament success:^(AFHTTPRequestOperation *operation, id responseObject) {
//============================== 登录成功  改变登陆状态 ==================================
                self.login = YES;
                _uid = responseObject[@"uid"];
                _access_token = responseObject[@"access_token"];
                NSLog(@"%@",responseObject);
//============================== 调用loginSuccess函数 ==================================
                //
                if (_loginSuccess) {
                    _loginSuccess([self getUserInfo]);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
//============================== 调用 loginFail 函数 ==================================
                if (_loginFail) {
                    _loginFail(error);
                }
            }];
            [webView.viewController dismissViewControllerAnimated:NO completion:^{
                // 退出一级登录界面
                [_loginViewController dismissViewControllerAnimated:NO completion:nil];
            }];
            
        }
        
        return NO;
    }
    
    return YES;
}
#pragma mark - 按钮点击事件
#pragma mark 分享按钮点击事件
- (void)shareButtonClick:(UIButton *)button {
    if (_saveAndShareModel) {
        
        //分享
        [UMSocialSnsService presentSnsIconSheetView:button.viewController
                                             appKey:@"565d4ddde0f55a54560012b5"
                                          shareText:[NSString stringWithFormat:@"%@ %@",_saveAndShareModel.title,[NSString stringWithFormat:@"http://www.tngou.net/%@/show/%@", _saveAndShareModel.type,_saveAndShareModel.id]]
                                         shareImage:[UIImage imageNamed:@"icon"]
                                    shareToSnsNames:@[UMShareToSina, UMShareToTencent, UMShareToWechatSession, UMShareToWechatFavorite, UMShareToWechatTimeline]
                                           delegate:self];
        
        [UMSocialData defaultData].extConfig.tencentData.urlResource.url = [NSString stringWithFormat:@"http://www.tngou.net/%@/show/%@", _saveAndShareModel.type,_saveAndShareModel.id];
        [UMSocialData defaultData].extConfig.sinaData.urlResource.url = [NSString stringWithFormat:@"http://www.tngou.net/%@/show/%@", _saveAndShareModel.type,_saveAndShareModel.id];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://www.tngou.net/%@/show/%@", _saveAndShareModel.type,_saveAndShareModel.id];
        [UMSocialData defaultData].extConfig.wechatFavoriteData.url = [NSString stringWithFormat:@"http://www.tngou.net/%@/show/%@", _saveAndShareModel.type,_saveAndShareModel.id];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"http://www.tngou.net/%@/show/%@", _saveAndShareModel.type,_saveAndShareModel.id];
        
    }
}
#pragma mark - UIAlertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 199 && buttonIndex == 1) {
        [[AccountManager manager] presentLoginPageWithViewController:_saveButton.viewController success:^(UserInfoModel *model) {
            
        } fail:^(NSError *error) {
            
        }];
    }
}

#pragma mark 收藏按钮点击事件
- (void)saveButtonClick:(UIButton *)button {
    if (_saveAndShareModel) {
        
        if ([AccountManager manager].isLogin) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            if (!button.selected) {
                
                NSDictionary *addParmets = @{
                                             @"access_token"    :_access_token,
                                             @"id"              :_saveAndShareModel.id,
                                             @"title"           :_saveAndShareModel.title,
                                             @"type"            :_saveAndShareModel.type
                                             };
                [manager GET:API_ACCOUNT_SAVE_ADD parameters:addParmets success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"%@",responseObject);
                    if ([responseObject[@"favorite"] intValue]) {
                        [MBProgressHUD showSuccess:@"收藏成功"];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                NSLog(@"收藏");
                
            }else {
                NSDictionary *delParmets = @{
                                             @"access_token"    :_access_token,
                                             @"id"              :_saveAndShareModel.id,
                                             @"type"            :_saveAndShareModel.type
                                             };
                [manager GET:API_ACCOUNT_SAVE_DEL parameters:delParmets success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"%@",responseObject);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                NSLog(@"取消收藏");
            }
            button.selected = !button.selected;
    
        }else {
            UIAlertView *saveAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录,请登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
            saveAlert.tag = 199;
            [saveAlert show];
        }
    }
}
#pragma mark - 公共方法
#pragma mark 弹出登录界面
- (void)presentLoginPageWithViewController:(id)viewController success:(LoginSuccess)loginSuccess fail:(LoginFail)loginFail {
    _loginSuccess = loginSuccess;
    _loginFail = loginFail;
    
    LoginViewController *lvc = [[LoginViewController alloc] init];
    [viewController presentViewController:lvc animated:YES completion:nil];
    
}
#pragma mark 注销登录
- (void)logout {
    _login = NO;
    _code = nil;
    _access_token = nil;
    _uid = nil;
}
#pragma mark 获取个人信息
- (UserInfoModel *)getUserInfo {
    if (self.isLogin) {
        UserInfoModel *model = [[UserInfoModel alloc] init];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//========AFNetworking同步请求======AFHTTPRequestOperationManager+Synchronous=======================
        NSError *error = nil;
        id responseObject = [manager syncGET:API_ACCOUNT_USERINFO parameters:@{@"access_token":_access_token}  operation:NULL error:&error];
        if (error == nil) {
            NSLog(@"%@",responseObject);
            [model setValuesForKeysWithDictionary:responseObject];
        }else {
            NSLog(@"error%@",error);
        }
        _userInfoModel = model;
        return model;
    }else {
        NSLog(@"请先登录");
        return nil;
    }
}
#pragma mark 创建收藏分享工具条
- (void)addSaveAndShareBarToView:(UIView *)view withSaveAndShareModel:(SaveAndShareModel *)saveAndShareModel {
    
    _saveAndShareModel = saveAndShareModel;
    UIView *ssBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40 - STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, 40)];
    ssBar.backgroundColor = THEME_MAIN_COLOR;
    [view addSubview:ssBar];
    // 收藏按钮
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveButton.frame = CGRectMake(SCREEN_WIDTH / 4.0f - 10, 0, 60, 40);
    [_saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_saveButton setTitle:@"收藏" forState:UIControlStateNormal];
    [_saveButton setTitle:@"已收藏" forState:UIControlStateSelected];
    [ssBar addSubview:_saveButton];
    // 分享按钮
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(SCREEN_WIDTH * 3 / 4.0f - 30, 0, 60, 40);
    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [ssBar addSubview:shareButton];
    // 如果登录 判断此内容是否收藏
    if ([AccountManager manager].isLogin) {
        _saveButton.selected = [self examineSaveResult];
    }else {
        
    }
}
#pragma mark - 验证收藏关系
- (BOOL)examineSaveResult {
    NSDictionary *parmets = @{
                              @"access_token"    :_access_token,
                              @"id"              :_saveAndShareModel.id,
                              @"type"            :_saveAndShareModel.type
                              };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSError *error = nil;
    id responseObject = [manager syncGET:API_ACCOUNT_SAVE parameters:parmets operation:NULL error:&error];
    
    if (error == nil) {
        NSLog(@"-----------%@",responseObject);
        return [responseObject[@"favorite"] boolValue];
    }else {
        NSLog(@"error%@",error);
    }
    return NO;
}
@end
