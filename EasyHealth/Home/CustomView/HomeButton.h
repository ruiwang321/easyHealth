//
//  HomeButton.h
//  easyHealthy
//
//  Created by Kirito on 15/11/29.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import <Foundation/Foundation.h>


//封装了两个导航栏button以及下方指示条


@interface HomeButton : NSObject
+ (UIButton *)createInfoButtonofFont:(int) font andSEL:(SEL)method target:(id)target ;
+ (UIButton *)createLoreButtonofFont:(int) font andSEL:(SEL)method target:(id)target ;
+ (UILabel *)creatNAVlabel;
@end
