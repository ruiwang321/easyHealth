//
//  DiseaseListViewController.m
//  EasyHealth
//
//  Created by yanchao on 15/12/8.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "DiseaseListViewController.h"
#import "ClassifyDiseaseShowModel.h"
#import "DiseaseTableViewCell.h"
#import "ShowDetailViewController.h"
@interface DiseaseListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //创建tableView
    UITableView *_tableView;
    //存放数据的数组
    NSMutableArray *dataArr;
    //定于显示的页数
    int pageNum;
    int a;
}
@end

@implementation DiseaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArr = [[NSMutableArray alloc] init];
    a=1;
    pageNum = 1;
    [self requestData:_type andPage:pageNum];
    
}
#pragma mark - 请求数据
- (void)requestData:(BOOL)typeName andPage:(int)index{
    [self checkNetWork:^{
        if (a==1) {
            //显示加载框
            [MBProgressHUD showMessage:@"加载中" toView:self.view];
            a++;
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];

        if (typeName == YES) {
            //按部位
            [manager GET:API_DISEASE_PLACE parameters:@{@"id":_ids,
                                                        @"page":[NSString stringWithFormat:@"%d",index],
                                                        @"rows":@"8"
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //创建表格
                [self createUI];
                if (index ==1) {
                    [dataArr removeAllObjects];
                }
                id palceObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"%@",palceObj);
                if ([palceObj[@"status"] intValue]) {
                    NSArray *array = palceObj[@"list"];
                    for (NSDictionary *dict in array) {
                        ClassifyDiseaseShowModel *model = [[ClassifyDiseaseShowModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [dataArr addObject:model];
                    }
                   
                }
                //隐藏加载框
                [MBProgressHUD hideHUDForView:self.view];
                //结束刷新
                [_tableView.header endRefreshing];
                [_tableView.footer endRefreshing];
                
                [_tableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //隐藏加载框
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:@"加载失败"];
                //结束刷新
                [_tableView.header endRefreshing];
                [_tableView.footer endRefreshing];
            }];
        }else {
            //按科室
            [manager GET:API_DISEASE_DEPART parameters:@{@"id":_ids,@"page":[NSString stringWithFormat:@"%d",index]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //创建表格
                [self createUI];
                NSMutableArray *tmpArray = [NSMutableArray array];
                id departObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"%@",departObj);
                if ([departObj[@"status"] boolValue]==YES) {
                    NSArray *array = departObj[@"list"];
                    for (NSDictionary *dict in array) {
                        ClassifyDiseaseShowModel *model = [[ClassifyDiseaseShowModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [tmpArray addObject:model];
                    }
                }
                //隐藏加载框
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //结束刷新
                [_tableView.header endRefreshing];
                [_tableView.footer endRefreshing];
                if (index ==1) {
                    dataArr = tmpArray;
                }else {
                    [dataArr addObjectsFromArray:tmpArray];
                }
                [_tableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //隐藏加载框
                [MBProgressHUD hideHUDForView:_tableView animated:YES];
                [MBProgressHUD showError:@"加载失败" toView:self.view];
                //结束刷新
                [_tableView.header endRefreshing];
                [_tableView.footer endRefreshing];

            }];

        }
        
    }];
    
}

#pragma mark - 创建界面
- (void)createUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [self requestData:_type andPage:pageNum];
    }];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pageNum ++;
        [self requestData:_type andPage:pageNum];
    }];
    
}
#pragma mark - tableVie的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiseaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DiseaseTableViewCell" owner:self options:nil] lastObject];
    }
    ClassifyDiseaseShowModel *model = dataArr[indexPath.row];
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",model.img]] placeholderImage:[UIImage imageNamed:@"zhanwei_v"]];
    cell.icon.contentMode=UIViewContentModeScaleAspectFit;
    cell.icon.clipsToBounds=YES;
    cell.nameLabel.text = model.name;
    cell.messageLabel.text = model.message;
    cell.placeLabel.text = model.place;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120*SCREEN_SCALE;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShowDetailViewController *showVC = [[ShowDetailViewController alloc] init];
    ClassifyDiseaseShowModel *model = dataArr[indexPath.row];
    showVC.otype = @"disease";
    showVC.otitle = model.name;
    showVC.pageId = model.id;
    [self.navigationController pushViewController:showVC animated:YES];
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
