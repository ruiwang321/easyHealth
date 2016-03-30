//
//  AccountManager.h
//  EasyHealth
//
//  Created by 王睿 on 15/12/1.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UserInfoModel.h"
#import "SaveAndShareModel.h"


@class LoginViewController;
typedef void (^LoginSuccess) (UserInfoModel *model);
typedef void (^LoginFail) (NSError *error);

@interface AccountManager : NSObject <UIWebViewDelegate, UMSocialUIDelegate, UIAlertViewDelegate>
/**
 *  调用oauth2/authorize 接口返回的授权码
 */
@property (nonatomic, copy) NSString *code;
/**
 *  用户认证的token
 */
@property (nonatomic, copy) NSString *access_token;
/**
 *  判断用户是否成功登陆 YES为成功登陆 NO为未登录 默认为NO
 */
@property (nonatomic, assign, getter=isLogin) BOOL login;
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *uid;
/**
 *  登录成功保存用户信息
 */
@property (nonatomic, strong) UserInfoModel *userInfoModel;

@property (nonatomic, copy) LoginFail loginFail;
@property (nonatomic, copy) LoginSuccess loginSuccess;
/**
 *  登录一级界面  传过来以备登录登录成功之后推出界面
 */
@property (nonatomic, strong) LoginViewController *loginViewController;

/**
 *  单例类工厂方法
 */
+ (instancetype)manager;
/**
 *  模态跳转登录页面 target为当前视图控制器
 *
 *  @param target 当前视图控制器
 */
- (void)presentLoginPageWithViewController:(id)viewController success:(LoginSuccess)loginSuccess fail:(LoginFail)loginFail;
/**
 *  注销登录
 */
- (void)logout;
/**
 *  获取用户信息
 *
 *  @return 用户信息模型
 */
- (UserInfoModel *)getUserInfo;
/**
 *  添加收藏分享工具条 先给SaveAndShareModel实例化并赋值
 *
 *  @param view  添加的父view
 *  @param model 数据模型
 */
- (void)addSaveAndShareBarToView:(UIView *)view withSaveAndShareModel:(SaveAndShareModel *)saveAndShareModel;

@end
