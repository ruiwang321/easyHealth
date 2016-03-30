//
//  KiritoCustomControl.m
//  Lsy
//
//  Created by Kirito on 15/11/25.
//  Copyright © 2015年 EasyHealthTeam. All rights reserved.
//

#import "KiritoCustomControl.h"
#import "HomeInfoModel.h"
#import "UIImageView+WebCache.h"

@implementation KiritoCustomControl


#pragma mark - View
+(UIView*)createViewWithFrame:(CGRect)frame
{
    UIView*view=[[UIView alloc]initWithFrame:frame];
    return view;
    
}


#pragma mark - UILabel
+ (UILabel *)createLabelWithFrame:(CGRect)frame textString:(NSString *)text withFont:(float)fontSize textColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    return label;
}

#pragma mark - UIButton
+ (UIButton*)createButtonWithFrame:(CGRect)frame target:(id)target SEL:(SEL)method backgoundImage:(UIImage *)image{
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = frame;
    
    if (image) {
        
        [but setBackgroundImage:image forState:UIControlStateNormal];
    }
    [but addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    
    return but;
}

#pragma mark - UIButton_iterations
+ (UIButton*)createButtonIterationsWithFrame:(CGRect)frame target:(id)target SEL:(SEL)method backgoundImage:(UIImage *)image title:(NSString *)title image:(UIImage *)sImage{
    
    UIButton *button = [KiritoCustomControl createButtonWithFrame:frame target:target SEL:method backgoundImage:image];
    
    if (sImage) {
        [button setImage:sImage forState:UIControlStateNormal];
    }
    
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    return button;
}

#pragma mark - UIImageView
+(UIImageView*)createImageViewFrame:(CGRect)frame imageName:(NSString*)imageName{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    imageView.image=[UIImage imageNamed:imageName];
    imageView.userInteractionEnabled=YES;
    return imageView;
}


#pragma mark - UITextField
+(UITextField*)createTextFieldFrame:(CGRect)frame Font:(float)font textColor:(UIColor*)color leftImageName:(NSString*)leftImageName rightImageName:(NSString*)rightImageName bgImageName:(NSString*)bgImageName placeHolder:(NSString*)placeHolder sucureTextEntry:(BOOL)isOpen backgroundColor:(UIColor*)backgroundColor
{
    UITextField*textField=[[UITextField alloc]initWithFrame:frame];
    textField.font=[UIFont systemFontOfSize:font];
    textField.textColor=color;
    //左边的图片
    UIImage*image=[UIImage imageNamed:leftImageName];
    UIImageView*letfImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    textField.leftView=letfImageView;
    textField.leftViewMode=UITextFieldViewModeAlways;
    //右边的图片
    UIImage*rightImage=[UIImage imageNamed:rightImageName];
    UIImageView*rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rightImage.size.width, rightImage.size.height)];
    textField.rightView=rightImageView;
    textField.rightViewMode=UITextFieldViewModeAlways;
    //清除按钮
    textField.clearButtonMode=YES;
    textField.background=[UIImage imageNamed:bgImageName];
    textField.placeholder=placeHolder;
    textField.backgroundColor=backgroundColor;
    //密码遮掩
    textField.secureTextEntry=isOpen;
    return textField;
}



+(UIScrollView *)createHomeScrollView {
    UIScrollView * _homeScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-60)];
    _homeScrollView.contentSize=CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-49-60);
    _homeScrollView.bounces=NO;
    _homeScrollView.pagingEnabled=YES;
    return _homeScrollView;
}

+(UIView*)createHomeInfoTbHeadViewWithDataArray:(NSMutableArray *)arr Block:(void(^)(UIButton* button))block {
    UIScrollView *scr =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    scr.contentSize = CGSizeMake(SCREEN_WIDTH*7, SCREEN_HEIGHT/3);
    scr.bounces=NO;
    scr.showsHorizontalScrollIndicator=NO;
    scr.showsVerticalScrollIndicator=NO;
    scr.pagingEnabled=YES;
    scr.contentOffset=CGPointMake(SCREEN_WIDTH, 0);
    if (arr.count>=5) {
    for (int i = 0; i<5; i++) {
        UIImageView * bt =[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
        HomeInfoModel *model=[[HomeInfoModel alloc]init];
        model=arr[i];
        [bt sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",API_PIC,model.img]]placeholderImage:[UIImage imageNamed:@"zhanwei_h"]];
        UILabel *lb =[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, SCREEN_HEIGHT/3-50, SCREEN_WIDTH, 50)];
        lb.text=model.title;
        lb.numberOfLines=2;
        lb.font=[UIFont systemFontOfSize:20*SCREEN_SCALE];
        lb.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
        [scr addSubview:bt];
        [scr addSubview:lb];
    }
    }
    return scr;
}



@end
