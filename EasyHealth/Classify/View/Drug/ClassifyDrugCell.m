//
//  ClassifyDrugCell.m
//  EasyHealth
//
//  Created by yanchao on 15/12/4.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "ClassifyDrugCell.h"

@implementation ClassifyDrugCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, frame.size.width-20, frame.size.height-10)];
        [self.contentView addSubview:_label];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
@end
