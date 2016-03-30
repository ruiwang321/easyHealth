//
//  NearbyTableViewCell.h
//  easyHealthy
//
//  Created by yanchao on 15/11/28.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbyTableViewCell : UITableViewCell

@property (nonatomic,copy) NSString * phoneNumber;
@property (weak, nonatomic) IBOutlet UIImageView *hospitalImg;
@property (weak, nonatomic) IBOutlet UILabel *hospitalName;
@property (weak, nonatomic) IBOutlet UILabel *hospitalAddress;
@property (weak, nonatomic) IBOutlet UILabel *hospitalMtype;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hospitalWidth;
- (IBAction)call:(UIButton *)sender;

@end
