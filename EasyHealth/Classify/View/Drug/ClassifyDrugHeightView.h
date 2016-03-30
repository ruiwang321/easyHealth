//
//  ClassifyDrugHeightView.h
//  EasyHealth
//
//  Created by yanchao on 15/12/4.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol buttonClickDelegate <NSObject>

- (void)buttonClicked:(UIButton *)button;

@end


@interface ClassifyDrugHeightView : UICollectionReusableView

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) id<buttonClickDelegate>delegate;


- (instancetype)initWithFrame:(CGRect)frame;

@end
