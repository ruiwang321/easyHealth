//
//  HomeHeaderScrollView.h
//  EasyHealth
//
//  Created by Kirito on 15/12/4.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHeaderScrollView : UIView

//block回调一个tag值
@property (nonatomic,strong) void (^buttonBlock)(NSInteger);
//页码指示器
@property (nonatomic,strong) UIPageControl* pageControl;

//自定义init方法
-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSMutableArray * )_homeInfoArray withBlock:(void(^)(NSInteger))block;

@end
