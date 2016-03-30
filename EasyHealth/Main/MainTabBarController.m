//
//  MainTabBarController.m
//  easyHealthy
//
//  Created by 王睿 on 15/11/26.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "MainTabBarController.h"
#import "BasicViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTabbar];
}

- (void)createTabbar
{
    // 创建一个存储视图控制器的数组
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    // 存放类名的数组
    NSArray *classNameArray = @[@"HomeViewController",@"ClassifyViewController",@"NearbyViewController",@"MeViewController"];
    // 存放普通图片
    NSArray *imageArray = @[@"tabbar_homepage_normal",@"tabbar_classify_normal",@"tabbar_vicinity_normal",@"tabbar_mine_normal"];
    // 存放选中图片
    NSArray *selectedImageArray = @[@"TabBarIcon-Home-Sel",@"TabBarIcon-Classify-Sel",@"TabBarIcon-NearBy-Sel",@"TabBarIcon-Me-Sel"];
    // 存放标题的数组
    NSArray *titleArray = @[@"首页",@"更多",@"附近",@"个人"];
    
    int i =0;
    for (NSString *className in classNameArray) {
        
        // 通过类名转换成类
        Class class = NSClassFromString(className);
        
        // 通过类创建视图控制器
        BasicViewController *rvc = [[class alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:rvc];
        
        // 设置标题
        nvc.tabBarItem.title = titleArray[i];
        
        // 设置图片
        nvc.tabBarItem.image = [UIImage imageNamed:imageArray[i]];
        
        // 设置选中图片
        nvc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageArray[i]];
        
        // 将视图控制器添加到数组中
        [viewControllers addObject:nvc];
        
        //设置tabbar字体选中状态的颜色
        [nvc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:THEME_MAIN_COLOR} forState:UIControlStateSelected];
        self.tabBar.tintColor = THEME_MAIN_COLOR;
        i++;
    }
    
    // 添加到分栏控制器上
    self.viewControllers = viewControllers;
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
