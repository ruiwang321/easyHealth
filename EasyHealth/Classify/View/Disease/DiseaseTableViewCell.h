//
//  DiseaseTableViewCell.h
//  EasyHealth
//
//  Created by yanchao on 15/12/8.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiseaseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;


@end
