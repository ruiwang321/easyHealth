//
//  HomeLoreViewController.m
//  EasyHealth
//
//  Created by Kirito on 15/12/3.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//
#define ButtonFont 22.0f    //导航栏 Button字号
#define TitleFont 20.0f     //cell 标题字号
#define DescFont 13.0f      //cell 详情字号

#import "HomeLoreViewController.h"
#import "HomeButton.h"
#import "HomeInfoModel.h"
#import "KiritoCustomControl.h"
#import "HomeTableViewCell.h"
#import "HomeShowViewController.h"
#import "ShowDetailViewController.h"

@interface HomeLoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *homeLoreArray;//知识模型数据源
@property (nonatomic, strong) NSMutableArray *holdArray; //加载、刷新暂存数据源
@property (nonatomic, assign) int lorePag;//知识刷新页码储存
@property (nonatomic, strong) UITableView * loreTableView; //知识TB
@property (nonatomic, assign) BOOL loadSuccess;  //判断加载是否出错
@end

@implementation HomeLoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lorePag=1;//显示第一页
    [self createUI];
    [self loadingData];
}

#pragma mark - 搭建主界面
- (void)createUI {
    _homeLoreArray=[[NSMutableArray alloc]init];
    _holdArray=[NSMutableArray new];
    [self createSubView];
    //MJ刷新
    _loreTableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadingData];
    }];
    _loreTableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _lorePag=1;
        [self loadingData];
    }];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
  @{NSFontAttributeName:[UIFont systemFontOfSize:22*SCREEN_SCALE],
    
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title=@"专题";
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
}
#pragma mark - 搭建主视图
- (void)createSubView {
    //知识TB
    _loreTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    [self.view addSubview:_loreTableView];
    _loreTableView.delegate=self;
    _loreTableView.dataSource=self;
}
#pragma mark - TB协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _homeLoreArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        static NSString *cellID1=@"cellID1";
        HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID1];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil] lastObject];
        }
        HomeInfoModel * model=_homeLoreArray[indexPath.row];//从第五个新闻开始显示
        [cell setvalueForModel:model titleFont:TitleFont descFont:DescFont];
        return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 110.0f*SCREEN_SCALE; //自适应cell高度
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
            ShowDetailViewController *showVC = [[ShowDetailViewController alloc] init];
            showVC.pageId = [_homeLoreArray[indexPath.row] id];
            showVC.otitle = [_homeLoreArray[indexPath.row] title];
            showVC.otype = @"lore";
            showVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:showVC animated:YES];
}

#pragma mark - 网络请求
//请求数据
- (void)loadingData {
    NSLog(@"准备加载专题页面数据");
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    [_holdArray removeAllObjects];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager GET:API_LORE_LIST parameters:@{@"page":[NSString stringWithFormat:@"%d",_lorePag],@"rows":@"8",@"id":_loreid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonObj=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary* dict in jsonObj[@"tngou"]) {
            HomeInfoModel *model=[[HomeInfoModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_homeLoreArray addObject:model];
            [_holdArray addObject:model];
        }
        [_loreTableView reloadData];
        [self.loreTableView.footer endRefreshing];
        [self.loreTableView.header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"专题页面数据加载完成");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载出错:%@",error);
        [self.loreTableView.footer endRefreshing];
        [self.loreTableView.header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"加载出错"];
    }];
    _lorePag++;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden=YES;
    NSLog(@"专题页面跳转成功");
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
