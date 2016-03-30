//
//  NearbyTableViewCell.m
//  easyHealthy
//
//  Created by yanchao on 15/11/28.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "NearbyTableViewCell.h"

@implementation NearbyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _hospitalWidth.constant = SCREEN_SCALE * _hospitalWidth.constant;
    _hospitalName.font = [UIFont systemFontOfSize:SCREEN_SCALE * 14.0f];
    _hospitalAddress.font = [UIFont systemFontOfSize:SCREEN_SCALE * 12.0f];
    _hospitalMtype.font = [UIFont systemFontOfSize:SCREEN_SCALE * 12.0f];
    _hospitalImg.layer.masksToBounds = YES;
    _hospitalImg.layer.borderColor = THEME_MAIN_COLOR.CGColor;
    _hospitalImg.layer.borderWidth = 2.0f;
    _hospitalImg.layer.cornerRadius = _hospitalWidth.constant/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)call:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneNumber]]];
}
@end
