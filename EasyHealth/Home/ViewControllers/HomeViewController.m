//
//  HomeViewController.m
//  easyHealthy
//
//  Created by Kirito on 15/11/26.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//
#import "HomeButton.h"
#import "HomeViewController.h"
#import "KiritoCustomControl.h"
#import "HomeTableViewCell.h"
#import "HomeShowModel.h"
#import "ShowDetailViewController.h"
#import "HomeLoreTableViewCell.h"
#import "HomeLoreViewController.h"
#import "HomeHeaderScrollView.h"

#define ButtonFont 20.0f    //导航栏 Button字号
#define TitleFont 20.0f     //cell 标题字号
#define DescFont 13.0f      //cell 详情字号

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *homeInfoArray;//资讯模型数据源
@property (nonatomic, strong) NSMutableArray *homeLoreArray;//知识模型数据源
@property (nonatomic, strong) NSMutableArray *holdArray; //加载、刷新暂存数据源
@property (nonatomic, assign) int infoPag;//资讯刷新页码存储
@property (nonatomic, assign) int lorePag;//知识刷新页码储存
@property (nonatomic, strong) UITableView * infoTableView; //资讯TB
@property (nonatomic, strong) UITableView * loreTableView; //知识TB
@property (nonatomic, strong) UIScrollView * homeScrollView; //主界面滚动视图
@property (nonatomic, strong) UIButton *infoButton; //导航栏资讯按钮
@property (nonatomic, strong) UIButton *loreButton; //导航栏知识按钮
@property (nonatomic, strong) UILabel *NavLabel;    //导航栏滑动指示Label
@property (nonatomic, assign) BOOL loadSuccess;  //判断加载是否出错
@property (nonatomic, assign) BOOL loadInfo;    //判断需要加载的是info还是lore
@property (nonatomic, assign) BOOL MJRefresh;   //判断是否为MJ刷新
@property (nonatomic, strong)  UIPageControl * pageControl;//广告页page
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoPag=1;//显示第一页
    _loadInfo=YES;
    [self createUI];
    [self loadingData];
}

#pragma mark - 搭建主界面
- (void)createUI {
    _homeInfoArray=[[NSMutableArray alloc]init];
    _homeLoreArray=[[NSMutableArray alloc]init];
    _holdArray=[NSMutableArray new];
    [self createSubView];
    [self creatNav];

    //MJ刷新
    _infoTableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _loadInfo=YES;
            [self loadingData];
    }];
      _infoTableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
          _infoPag=1;
          _loadInfo=YES;
          _MJRefresh=YES;
          [self loadingData];
    }];
}
#pragma mark - 搭建导航栏
- (void)creatNav {
    self.navigationController.navigationBar.barTintColor=THEME_MAIN_COLOR;
    _infoButton=[HomeButton createInfoButtonofFont:ButtonFont andSEL:@selector(infoButtonClicked:) target:(id)self ];
    _loreButton=[HomeButton createLoreButtonofFont:ButtonFont andSEL:@selector(loreButtonClicked:) target:(id)self ];
    _NavLabel=[HomeButton creatNAVlabel];
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    label.userInteractionEnabled=YES;
    [label addSubview:_infoButton];
    [label addSubview:_loreButton];
    [label addSubview:_NavLabel];
    self.navigationItem.titleView=label;
    
}
//资讯按钮事件
- (void)infoButtonClicked:(UIButton *)button{
    //再次点击、启动刷新
    if (_homeScrollView.contentOffset.x==0) {
        NSLog(@"再次点击、启动刷新");
        [_infoTableView.header beginRefreshing];   //调用MJ刷新
    }
        //实现label滚动
    [self changeNAVfor:_infoButton];
}
//知识按钮事件
- (void)loreButtonClicked:(UIButton *)button{
    //实现label滚动
    [self changeNAVfor:_loreButton];
}
#pragma mark - 搭建主视图
- (void)createSubView {
    //滚动视图
    _homeScrollView=[KiritoCustomControl createHomeScrollView];
    _homeScrollView.delegate=self;
    [self.view addSubview:_homeScrollView];
    _homeScrollView.showsHorizontalScrollIndicator = NO;
    //资讯TB
    _infoTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-60)];
    [_homeScrollView addSubview:_infoTableView];
    _infoTableView.delegate=self;
    _infoTableView.dataSource=self;
    UIScrollView * _headerScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    _infoTableView.tableHeaderView=_headerScrollView;  //加载UI、先用一个scrollV 占位
     //知识TB
    _loreTableView=[[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-60)];
    [_homeScrollView addSubview:_loreTableView];
    _loreTableView.delegate=self;
    _loreTableView.dataSource=self;
}
//滚动完成修改导航栏显示状态
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView ==_homeScrollView) {
    if (_homeScrollView.contentOffset.x==SCREEN_WIDTH) {
        [self changeNAVfor:_loreButton];
        [self changeButtonSeleted];
    }
     if (_homeScrollView.contentOffset.x==0) {
        [self changeNAVfor:_infoButton];
        [self changeButtonSeleted];
    }
    }
}
//导航栏Label跟随主scrollView滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _homeScrollView) {
        CGFloat navMax=(CGFloat)( _loreButton.center.x-_infoButton.center.x);
        CGFloat scr=(CGFloat)scrollView.contentOffset.x;
        CGFloat scale=scr/SCREEN_WIDTH;
        _NavLabel.center=CGPointMake(120*SCREEN_SCALE+navMax*scale, _NavLabel.center.y);
        NSLog(@"%lf",70*SCREEN_SCALE+navMax*scale);
    }
    
}
#pragma mark - TB协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  (tableView==_infoTableView)?_homeInfoArray.count-5:_homeLoreArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_infoTableView) {
        static NSString *cellID1=@"cellID1";
        HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID1];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil] lastObject];
    }
    HomeInfoModel * model=_homeInfoArray[indexPath.row+5];//从第五个新闻开始显示
    [cell setvalueForModel:model titleFont:TitleFont descFont:DescFont];
    return cell;
    }else {
        static NSString *cellID2=@"cellID2";
        HomeLoreTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellID2];
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"HomeLoreTableViewCell" owner:self options:nil] lastObject];
        }
        HomeInfoModel * model=_homeLoreArray[indexPath.row];
        [cell setvalueWithModel:model];
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_infoTableView) {
    return 110.0f*SCREEN_SCALE;
    }else {
        return 200.0f*SCREEN_SCALE;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==_infoTableView) {
        NSLog(@"准备跳转至信息展示页面");
        ShowDetailViewController *showVC = [[ShowDetailViewController alloc] init];
        showVC.pageId = [_homeInfoArray[indexPath.row+5] id];
        showVC.otitle = [_homeInfoArray[indexPath.row+5] title];
        showVC.otype = @"news";
        showVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:showVC animated:YES];
        
    }else {
      
        NSLog(@"准备跳转至专题页面");
        HomeLoreViewController * hsvc=[[HomeLoreViewController alloc]init];
        hsvc.loreid=[_homeLoreArray[indexPath.row] id];
        [self.navigationController pushViewController:hsvc animated:YES];

    }
}
#pragma mark - 网络请求
//请求数据
- (void)loadingData {
    NSLog(@"准备加载主页面数据");
    static int a=1;
    if (a==1) {
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    }
    [_holdArray removeAllObjects];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager GET:_loadInfo?API_INFO_LIST:API_LORE_CLASSIFY parameters:_loadInfo?@{@"page":[NSString stringWithFormat:@"%d",_infoPag],@"rows":_infoPag==1?@"13":@"5"}:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonObj=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideHUDForView:self.view];
        if ([jsonObj[@"status"] intValue]) {
            for (NSDictionary* dict in jsonObj[@"tngou"]) {
                HomeInfoModel *model=[[HomeInfoModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                _loadInfo?[_homeInfoArray addObject:model]:[_homeLoreArray addObject:model];
                [_holdArray addObject:model];
            }
            _loadSuccess=YES;
            if (a==1) {//首次加载、重复加载lore页面数据
                _loadInfo=NO;
                a++;
                [self loadingData];
            }
            NSLog(@"主页面数据加载成功");
        }else {
            [MBProgressHUD showError:jsonObj[@"msg"]];
        }
        
       [self endForLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载出错:%@",error);
        _loadSuccess=NO;
         [self endForLoading];
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"加载出错"];
    }];
    _loadInfo?_infoPag++:0;//作废、懒得改了
}
//刷新结束
-(void)endForLoading {
    [self.infoTableView.footer endRefreshing];
    [self.infoTableView.header endRefreshing];
    //判断是否为button点击刷新
    if (_loadSuccess==NO) { //刷新失败
    }else {
    if (_MJRefresh) {     //刷新触发、重置数据源为新数据
        [_homeInfoArray removeAllObjects];
        [_homeInfoArray addObjectsFromArray:_holdArray];
    }
    _infoButton.selected?[_infoTableView reloadData]:nil;
    }
    static int a=1;//前两次加载、自动刷新两个TB
    if (_homeInfoArray.count >5) {
        [self createHomeInfoTbHeadView];//刷新广告页
    }
    if (a==1) {
        [_infoTableView reloadData];
    }
    if (a==2) {
        [_loreTableView reloadData];
    }
    a++;
     _MJRefresh=NO;
    }
#pragma mark - 封装功能实现方法
//修改button选中
- (void)changeButtonSeleted {
    (_NavLabel.center.x==_infoButton.center.x)?(_infoButton.selected=YES):( _infoButton.selected=NO);
    (_NavLabel.center.x==_infoButton.center.x)?(_loreButton.selected=NO):(_loreButton.selected=YES);
}
//滚动导航Label
- (void)changeNAVfor:(UIButton*)button {
    [UIView animateWithDuration:0.25 animations:^{
        _NavLabel.center=CGPointMake(button.center.x, 51.5);
        (button==_infoButton)? (_homeScrollView.contentOffset=CGPointMake(0, 0)): (_homeScrollView.contentOffset=CGPointMake(SCREEN_WIDTH, 0));
    }];
    [self changeButtonSeleted];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
}
//创建广告页
-(void)createHomeInfoTbHeadView {
    HomeHeaderScrollView * header=[[HomeHeaderScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3) withDataArray:_homeInfoArray withBlock:^(NSInteger tag) {
        //block 点击广告图片回调 页面跳转
        NSLog(@"准备跳转至信息展示页面");
        ShowDetailViewController * hsvc=[[ShowDetailViewController alloc]init];
        hsvc.otype = @"news";
        hsvc.otitle = [_homeInfoArray[tag-100-1] title];
        hsvc.pageId=[_homeInfoArray[tag-100-1] id];
        hsvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hsvc animated:YES];
    }];
    // 用广告页scrollView 替换 占位scrollV
    _infoTableView.tableHeaderView=header;
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
