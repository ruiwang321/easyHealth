//
//  SearchResultViewController.m
//  EasyHealth
//
//  Created by yanchao on 15/12/9.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchResultModel.h"
#import "SearchResultCell.h"
#import "ShowDetailViewController.h"

@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tablewView;
    //存放数据的数组
    NSMutableArray * dataArray;
    int pageNum;
    int a;
}
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc] init];
  
    a=1;
    [self checkNetWork:^{
        pageNum = 1;
        [self requestData:pageNum];
    }];
}
#pragma mark - 请求数据
- (void)requestData:(int)index {
    
    [self checkNetWork:^{
        if (a==1) {
            //显示加载框
            [MBProgressHUD showMessage:@"加载中" toView:self.view];
            a++;
        }
    }];
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dict = @{
                           @"keyword":self.keyword,
                           @"name":self.typeIdentify,
                           @"rows":[NSString stringWithFormat:@"%d",10],
                           @"page":[NSString stringWithFormat:@"%d",pageNum]
                               
                           };
    [manager GET:API_Search parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id searchObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",searchObj);
        NSMutableArray *tmpArray = [NSMutableArray array];
        if ([searchObj[@"status"] integerValue] ==1) {
             NSArray *array = searchObj[@"tngou"];
            for (NSDictionary *dic in array) {
                SearchResultModel *model = [[SearchResultModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [tmpArray addObject:model];
                //创建表格
                [self createTableView];
            }
            if (pageNum == 1) {
                dataArray = tmpArray;
            }else {
                [dataArray addObjectsFromArray:tmpArray];
            }
            
            [_tablewView reloadData];
        }
        
        //隐藏加载框
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //结束刷新
        [_tablewView.header endRefreshing];
        [_tablewView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       //隐藏加载框
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败" toView:self.view];
        //结束刷新
        [_tablewView.header endRefreshing];
        [_tablewView.footer endRefreshing];
    }];
}
#pragma mark - 创建表格
- (void)createTableView {
    _tablewView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
    _tablewView.delegate = self;
    _tablewView.dataSource = self;
    [self.view addSubview:_tablewView];
    
    _tablewView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [self requestData:pageNum];
    }];
    _tablewView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pageNum ++;
        [self requestData:pageNum];
    }];

    
    if (dataArray.count==0) {
        [MBProgressHUD showMessage:@"服务器数据解析错误" toView:_tablewView];
    }
    
}
#pragma mark - tableView的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120*SCREEN_SCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultCell" owner:self options:nil] lastObject];
    }
    SearchResultModel *model = dataArray[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"showzhanwei"]];
    cell.desLabel.text = model.description;
    cell.titleLabel.text = model.name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowDetailViewController *showVc = [[ShowDetailViewController alloc] init];
    SearchResultModel *model = dataArray[indexPath.row];
    if ([self.typeIdentify isEqualToString:@"food"]) {
        showVc.otype = @"food";
    
    }else if ([self.typeIdentify isEqualToString:@"cook"]){
        showVc.otype = @"cook";
    
    }else if ([self.typeIdentify isEqualToString:@"drug"]) {
        showVc.otype = @"drug";
    
    }else if ([self.typeIdentify isEqualToString:@"disease"]){
        showVc.otype = @"disease";
    }
    showVc.otitle = model.name;
    showVc.pageId = model.id;
    showVc.navigationItem.titleView = [self setTitleColor:model.name withFrame:CGRectMake(0, 0, 100, 40)];
    [self.navigationController pushViewController:showVc animated:YES];
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
