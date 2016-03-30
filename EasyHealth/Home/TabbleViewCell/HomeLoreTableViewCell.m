//
//  HomeLoreTableViewCell.m
//  EasyHealth
//
//  Created by Kirito on 15/12/3.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "HomeLoreTableViewCell.h"

@implementation HomeLoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setvalueWithModel:(HomeInfoModel *)model {
    _icon.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",model.title]];
    self.icon.contentMode=UIViewContentModeScaleAspectFill;
    self.icon.clipsToBounds=YES;
    self.icon.layer.cornerRadius=15*SCREEN_SCALE;
    _title.text=model.title;
    self.title.font=[UIFont systemFontOfSize:22*SCREEN_SCALE];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
