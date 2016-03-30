//
//  ClassifyDrugHeightView.m
//  EasyHealth
//
//  Created by yanchao on 15/12/4.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "ClassifyDrugHeightView.h"


@implementation ClassifyDrugHeightView

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height);
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _button.backgroundColor = [UIColor colorWithRed:1 green:0.99 blue:0.92 alpha:1];
        
        UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, _button.frame.size.height-1, SCREEN_WIDTH, 1)];
        downView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        [_button addSubview:downView];
        
        [self addSubview:_button];
        
    }
    return self;
}

//button的点击事件
- (void)buttonClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(buttonClicked:)]) {
        
        [self.delegate buttonClicked:button];
    }
}
@end
