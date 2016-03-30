//
//  HomeLoreTableViewCell.h
//  EasyHealth
//
//  Created by Kirito on 15/12/3.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeInfoModel.h"

@interface HomeLoreTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *title;

-(void)setvalueWithModel:(HomeInfoModel *)model;

@end
