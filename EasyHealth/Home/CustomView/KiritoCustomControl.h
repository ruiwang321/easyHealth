//
//  KiritoCustomControl.h
//  Lsy
//
//  Created by Kirito on 15/11/25.
//  Copyright © 2015年 EasyHealthTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KiritoCustomControl : NSObject

@property (nonatomic,copy) void (^ViewBlock)();
@property (nonatomic,strong) NSArray * dataArray;

#pragma mark - UIView
+ (UIView *)createViewWithFrame:(CGRect)frame;

#pragma mark - UILabel
+ (UILabel *)createLabelWithFrame:(CGRect)frame textString:(NSString *)text withFont:(float)fontSize textColor:(UIColor *)color;
#pragma mark - UIButton
+ (UIButton *)createButtonWithFrame:(CGRect)frame target:(id)target SEL:(SEL)method backgoundImage:(UIImage *)image;

#pragma mark - UIButton_iterations
+ (UIButton *)createButtonIterationsWithFrame:(CGRect)frame target:(id)target SEL:(SEL)method backgoundImage:(UIImage *)image title:(NSString *)title image:(UIImage *)sImage;

#pragma mark - UIimageView
+ (UIImageView*)createImageViewFrame:(CGRect)frame imageName:(NSString*)imageName;

#pragma mark - textField
+ (UITextField*)createTextFieldFrame:(CGRect)frame Font:(float)font textColor:(UIColor*)color leftImageName:(NSString*)leftImageName rightImageName:(NSString*)rightImageName bgImageName:(NSString*)bgImageName placeHolder:(NSString*)placeHolder sucureTextEntry:(BOOL)isOpen backgroundColor:(UIColor*)backgroundColor;



//主页面滚动视图
+ (UIScrollView *)createHomeScrollView;

@end