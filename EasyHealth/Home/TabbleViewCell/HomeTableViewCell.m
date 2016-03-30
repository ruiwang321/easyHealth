//
//  HomeTableViewCell.m
//  easyHealthy
//
//  Created by Kirito on 15/11/27.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "homeInfoModel.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setvalueForModel:(HomeInfoModel *)model titleFont:(int)titleFont descFont:(int)descFont {
    self.title.text=model.title;
    self.title.font=[UIFont systemFontOfSize:titleFont*SCREEN_SCALE];
    [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",API_PIC,model.img]]placeholderImage:[UIImage imageNamed:@"zhanwei_h"]];
    self.img.contentMode=UIViewContentModeScaleAspectFill;
    self.img.clipsToBounds=YES;
    self.img.layer.cornerRadius=10*SCREEN_SCALE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
