//
//  ToolsDefine.h
//  EasyHealth
//
//  Created by yanchao on 15/11/22.
//  Copyright © 2015年 EasyHealthTeam. All rights reserved.
// 工具宏

#ifndef ToolsDefine_h
#define ToolsDefine_h


//设置RBGA（红、绿、蓝、透明度）
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//设置RGB（红、绿、蓝、不透明）
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//==主题配色
//主色调，icon、启动界面都是这个色值
#define THEME_MAIN_COLOR RGBA(28,188,131,1)
//TabBar的颜色
#define THEME_TAB_BAR_TEXT_COLOR RGBA(250,200,50,1)
//随机颜色
#define Srand_Color RGB(arc4random()%256,arc4random()%256,arc4random()%256)

//模型定义
#define proStr(string) @property (nonatomic, copy) NSString *string;
#define proArray(array) @property (nonatomic, strong) NSArray *array;

#endif /* ToolsDefine_h */
