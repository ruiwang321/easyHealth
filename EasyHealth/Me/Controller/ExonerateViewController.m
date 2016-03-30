//
//  ExonerateViewController.m
//  HealthDrips
//
//  Created by Arom on 15-11-11.
//  Copyright (c) 2015年 UpTeam. All rights reserved.
//

#import "ExonerateViewController.h"

@interface ExonerateViewController ()
@property (weak, nonatomic) IBOutlet UITextView *_textView;

@end

@implementation ExonerateViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self._textView.contentOffset = CGPointMake(0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
