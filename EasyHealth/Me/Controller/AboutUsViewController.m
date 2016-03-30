//
//  AboutUsViewController.m
//  HealthDrips
//
//  Created by HY on 15-11-13.
//  Copyright (c) 2015年 UpTeam. All rights reserved.
//

#import "AboutUsViewController.h"
#import "KiritoCustomControl.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImageView * teamImage=[KiritoCustomControl createImageViewFrame:CGRectMake(SCREEN_WIDTH/2-80-10, 10,80, 80) imageName:@"icon"];
    [self.view addSubview:teamImage];
    UIImageView * TGImage=[KiritoCustomControl createImageViewFrame:CGRectMake(SCREEN_WIDTH/2+10, 10,80, 80) imageName:@"TGY"];
    TGImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:TGImage];
    UILabel * teamlabel=[KiritoCustomControl createLabelWithFrame:CGRectMake(SCREEN_WIDTH/2-80-10, 90,80, 20) textString:@"易健康" withFont:14.0f textColor:[UIColor blackColor]];
    [self.view addSubview:teamlabel];
    UILabel * TGlabel=[KiritoCustomControl createLabelWithFrame:CGRectMake(SCREEN_WIDTH/2+10, 90,80, 20) textString:@"天狗云" withFont:14.0f textColor:[UIColor blackColor]];
    teamlabel.textAlignment = NSTextAlignmentCenter;
    TGlabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:TGlabel];
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 115, SCREEN_WIDTH-40, 1)];
    lineLabel.backgroundColor=[UIColor blackColor];
    [self.view addSubview:lineLabel];
    UILabel * titleLabel=[KiritoCustomControl createLabelWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 50) textString:@"易健康·EasyHealth" withFont:20.0f textColor:[UIColor blackColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    UILabel * descriptionLabel=[KiritoCustomControl createLabelWithFrame:CGRectMake(10, 170, SCREEN_WIDTH-20, 200) textString:@"     易健康，一款专注健康的APP。健康资讯、健康小知识、食谱、药品信息、疾病信息、附近医院、药店信息一网打尽。\n     本软件由EasyHealthTeam设计开发，由天狗云提供数据资源。\n     易健康            www.easyHealth.com\n     天狗云            www.tngou.net\n     注意：由于信息是通过服务器自动采集生成，各类信息仅供参考，数据的准确性与本团队无关。" withFont:14.0f textColor:[UIColor blackColor]];
    descriptionLabel.numberOfLines=0;
    [self.view addSubview:titleLabel];
    [self.view addSubview:descriptionLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
