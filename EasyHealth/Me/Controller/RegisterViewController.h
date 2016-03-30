//
//  RegisterViewController.h
//  EasyHealth
//
//  Created by 王睿 on 15/12/9.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "BasicViewController.h"
#import "LoginViewController.h"

@interface RegisterViewController : BasicViewController

/**
 *  登录一级界面  传过来以备登录登录成功之后推出界面
 */
@property (nonatomic, strong) LoginViewController *loginViewController;

@end
