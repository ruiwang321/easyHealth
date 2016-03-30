//
//  HomeTableViewCell.h
//  easyHealthy
//
//  Created by Kirito on 15/11/27.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeInfoModel.h"

@interface HomeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *title;

-(void)setvalueForModel:(HomeInfoModel *)model titleFont:(int)titleFont descFont:(int)descFont;

@end
