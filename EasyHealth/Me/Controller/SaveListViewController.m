//
//  SaveListViewController.m
//  EasyHealth
//
//  Created by 王睿 on 15/12/4.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "SaveListViewController.h"
#import "SaveListModel.h"
#import "ShowDetailViewController.h"

@interface SaveListViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    NSMutableArray *_listModelArray;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SaveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getDataWithAPI];
}

#pragma mark 创建表格视图
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}
#pragma mark - 网络请求数据
- (void)getDataWithAPI {
    [self checkNetWork:^{
        _listModelArray = [NSMutableArray array];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *paramets = @{
                                   @"access_token"  :[AccountManager manager].access_token,
                                   @"type"          :@""
                                   };
        [MBProgressHUD showMessage:@"加载中"];
        [manager GET:API_ACCOUNT_SAVE_LIST parameters:paramets success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            if (![responseObject[@"total"] intValue]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"收藏夹为空"];
            }else {
                for (NSDictionary *dic in responseObject[@"tngou"]) {
                    SaveListModel *model = [[SaveListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_listModelArray addObject:model];
                }
                [MBProgressHUD hideHUD];
                [_tableView reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUD];
            NSLog(@"%@",error);
        }];
    }];
}
#pragma mark - 表格数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = @"listCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    cell.textLabel.text = [_listModelArray[indexPath.row] title];
    // 将时间戳转换成"年-月-日 时：分：秒"格式的时间
    NSString * timeStampString = [_listModelArray[indexPath.row] time];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStampString doubleValue]/ 1000];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [objDateformat stringFromDate: date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"收藏时间: %@",time];
    return cell;
}
#pragma mark cell滑动编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self checkNetWork:^{
        SaveListModel *model = _listModelArray[indexPath.row];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{
                                     @"access_token"    :[AccountManager manager].access_token,
                                     @"id"              :model.oid,
                                     @"type"            :model.otype
                                     };
        [manager GET:API_ACCOUNT_SAVE_DEL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (![responseObject[@"favoriter"] intValue]) {
                [MBProgressHUD showSuccess:@"取消收藏成功"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"取消收藏失败"];
        }];
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"取消收藏";
}

#pragma mark cell选中调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShowDetailViewController *svc = [[ShowDetailViewController alloc] init];
    svc.otype = [_listModelArray[indexPath.row] otype];
    svc.pageId = [_listModelArray[indexPath.row] oid];
    [self.navigationController pushViewController:svc animated:YES];
    
}

#pragma mark - UIAlertView协议方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        [self getDataWithAPI];
        [_tableView reloadData];
    }
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
