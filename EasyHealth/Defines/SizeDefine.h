//
//  SizeDefine.h
//  EasyHealth
//
//  Created by yanchao on 15/11/22.
//  Copyright © 2015年 EasyHealthTeam. All rights reserved.
//  尺寸宏

#ifndef SizeDefine_h
#define SizeDefine_h

//状态栏高度
#define STATUS_BAR_HEIGHT 20
//NavBar高度
#define NAVIGATION_BAR_HEIGHT 44
//TabBar高度
#define TAB_BAR_HEIGHT 49
//状态栏＋导航栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT))

//屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//适配
#define iphone6p 414.0f
#define iphone4s 320.0f
#define iphone5s 320.0f

//缩放比例(以iphone6p为参考)
#define SCREEN_SCALE (SCREEN_WIDTH / iphone6p)

//高德地图api
#define apikey @"f81038799e2a554935b349a628ba2780"

//设备版本
#define isIos7  [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f
#define isIos8  [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f

#endif /* SizeDefine_h */
