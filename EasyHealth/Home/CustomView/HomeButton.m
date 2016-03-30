//
//  HomeButton.m
//  easyHealthy
//
//  Created by Kirito on 15/11/29.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "HomeButton.h"
#import "KiritoCustomControl.h"

@implementation HomeButton
+ (UIButton *)createInfoButtonofFont:(int) font andSEL:(SEL)method target:(id)target {
    UIButton* _infoButton=[KiritoCustomControl createButtonIterationsWithFrame:CGRectMake(80*SCREEN_SCALE, 10, 80*SCREEN_SCALE, 36) target:target SEL:method backgoundImage:nil title:@"资讯" image:nil];
    _infoButton.titleLabel.font=[UIFont systemFontOfSize:font*SCREEN_SCALE];
    [_infoButton setBackgroundColor:[UIColor clearColor]];
    [_infoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_infoButton setTitleColor:THEME_TAB_BAR_TEXT_COLOR forState:UIControlStateSelected];
    _infoButton.selected=YES;
    return _infoButton;
}
+ (UIButton *)createLoreButtonofFont:(int) font andSEL:(SEL)method target:(id)target{
   UIButton *_loreButton=[KiritoCustomControl createButtonIterationsWithFrame:CGRectMake((SCREEN_WIDTH)-(80+80*SCREEN_SCALE), 10, 80*SCREEN_SCALE, 36) target:target SEL:method backgoundImage:nil title:@"专题" image:nil];
    [_loreButton setBackgroundColor:[UIColor clearColor]];
    _loreButton.titleLabel.font=[UIFont systemFontOfSize:font*SCREEN_SCALE];
    [_loreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loreButton setTitleColor:THEME_TAB_BAR_TEXT_COLOR forState:UIControlStateSelected];
    return _loreButton;
}

+ (UILabel *)creatNAVlabel {
   UILabel  *_NavLabel=[KiritoCustomControl createLabelWithFrame:CGRectMake(70*SCREEN_SCALE, 50, 100*SCREEN_SCALE, 5) textString:nil withFont:14 textColor:[UIColor orangeColor]];
    _NavLabel.backgroundColor=THEME_TAB_BAR_TEXT_COLOR;
    return _NavLabel;
}
@end
