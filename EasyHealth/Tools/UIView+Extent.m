//
//  UIView+Extent.m
//  EasyHealth
//
//  Created by 王睿 on 15/12/2.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "UIView+Extent.h"

@implementation UIView (Extent)

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
