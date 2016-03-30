//
//  LoginWebViewController.h
//  EasyHealth
//
//  Created by 王睿 on 15/12/2.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "BasicViewController.h"

@interface LoginWebViewController : BasicViewController
/**
 *  登录类型 腾讯qq：@"qq" 新浪微博：@"sina"
 */
@property (nonatomic, copy) NSString *loginType;
@property (strong, nonatomic) UIWebView *webView;

@end
