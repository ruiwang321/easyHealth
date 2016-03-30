//
//  ClassifyViewController.m
//  easyHealthy
//
//  Created by 王睿 on 15/11/26.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "ClassifyViewController.h"

#import "CookViewController.h"
#import "BookViewController.h"
#import "DiseaseViewController.h"
#import "DrugViewController.h"
#import "FoodViewController.h"
#import "GalleryViewController.h"

#import "SearchViewController.h"
#define sectionHeight 10.0f
#define rowHeight 70.0f
@interface ClassifyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
 //分组的tableView
    UITableView *_tableView;
    
//定义三个字典存放标题
    NSDictionary *_oneDict;
    NSDictionary *_twoDict;
    NSDictionary *_threeDict;
    
}
@end

@implementation ClassifyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     self.navigationItem.titleView = [self setTitleColor:@"分类" withFrame:CGRectMake(0, 0, 100, 40)];
    [self.navigationController.navigationBar setBarTintColor:THEME_MAIN_COLOR];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonClicked:)];
    self.navigationItem.rightBarButtonItem = searchButton;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self createUI];
    
}

#pragma mark - 创建UI
- (void)createUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-TAB_BAR_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    
    _oneDict = [NSDictionary dictionaryWithObjectsAndKeys:@[@"food",@"健康食品",@"健康美味，从这里开始"],@"0",@[@"cook",@"健康菜谱",@"美味佳肴，健康最重要"],@"1",nil];
    _twoDict = [NSDictionary dictionaryWithObjectsAndKeys:@[@"drug",@"药品信息",@"全面、优质、快速的信息查询服务"],@"0",@[@"diease",@"疾病信息",@"为您提供疾病的病因、症状、检查、用药、治疗、并发症等方面的详细分析资料"],@"1",nil];
    _threeDict = [NSDictionary dictionaryWithObjectsAndKeys:@[@"sao",@"扫一扫",@"扫描条形码，获得信息"],@"0",nil];
    
}
#pragma mark - tableView的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _oneDict.count;
    }else if (section == 1){
        return _twoDict.count;
    }else {
        return _threeDict.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
    }
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:_oneDict[[NSString stringWithFormat:@"%ld",(long)indexPath.row]][0]];
        cell.textLabel.text = _oneDict[[NSString stringWithFormat:@"%ld",(long)indexPath.row]][1];
        cell.detailTextLabel.text = _oneDict[[NSString stringWithFormat:@"%ld",(long)indexPath.row]][2];
        return cell;
    }else if (indexPath.section == 1){
        cell.imageView.image = [UIImage imageNamed:_twoDict[[NSString stringWithFormat:@"%ld",(long)indexPath.row]][0]];
        cell.textLabel.text = _twoDict[[NSString stringWithFormat:@"%ld",(long)indexPath.row]][1];
        cell.detailTextLabel.text = _twoDict[[NSString stringWithFormat:@"%ld",(long)indexPath.row]][2];
        return cell;

    }else {
        cell.imageView.image = [UIImage imageNamed:_threeDict[[NSString stringWithFormat:@"%ld",(long)indexPath.row]][0]];
        cell.textLabel.text = _threeDict[[NSString stringWithFormat:@"%ld",(long)indexPath.row]][1];
        cell.detailTextLabel.text = _threeDict[[NSString stringWithFormat:@"%ld",(long)indexPath.row]][2];
        
        return cell;

    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return sectionHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //健康食品
            FoodViewController *cvc = [[FoodViewController alloc] init];
            cvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cvc animated:YES];
        }else {
            //健康菜谱
            CookViewController *cvc = [[CookViewController alloc] init];
            cvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cvc animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //药品信息
            DrugViewController *cvc = [[DrugViewController alloc] init];
            cvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cvc animated:YES];
        }else {
            //疾病信息
            DiseaseViewController *cvc = [[DiseaseViewController alloc] init];
            cvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cvc animated:YES];
        }
    }else {
        //扫一扫
        GalleryViewController *cvc = [[GalleryViewController alloc] init];
        cvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cvc animated:YES];
    
    }
}
#pragma mark - 点击导航栏上搜索按钮触发的方法
- (void)searchButtonClicked:(UIBarButtonItem *)searchBtn {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
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
