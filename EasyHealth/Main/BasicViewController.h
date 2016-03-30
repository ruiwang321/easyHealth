//
//  BasicViewController.h
//  easyHealthy
//
//  Created by 王睿 on 15/11/26.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NetConnectSuccess)(void);
@interface BasicViewController : UIViewController
//设置导航条标题颜色为白色
- (UILabel *)setTitleColor:(NSString *)title withFrame:(CGRect)frame;
//判断网络状态
- (void)checkNetWork:(NetConnectSuccess)netConnectSuccess;
@end
