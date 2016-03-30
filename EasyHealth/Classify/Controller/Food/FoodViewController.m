//
//  FoodViewController.m
//  easyHealthy
//
//  Created by 王睿 on 15/11/28.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "FoodViewController.h"
#import "FoodClassifyModel.h"
#import "FoodLiteClassifyModel.h"
#import "FoodListModel.h"
#import "FoodListCollectionViewCell.h"

#import "ShowDetailViewController.h"
@interface FoodViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    
    int a[25];
}
/**
 *  分类表格视图
 */
@property (nonatomic, strong) UITableView *classifyTableView;
/**
 *  菜品展示列表
 */
@property (nonatomic, strong) UICollectionView *listCollectionView;
/**
 *  存放分类数据模型
 */
@property (nonatomic, strong) NSArray *classifyModelsList;
/**
 *  列表数据源
 */
@property (nonatomic, strong) NSMutableArray *listDataArray;
@end

@implementation FoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.navigationItem.titleView = [self setTitleColor:@"食品" withFrame:CGRectMake(0, 0, 100, 40)];
    [self createClassifyTableView];
    [self createListCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 初始化数组 判断表格分组是否展开
- (void)inita {
    for (int i = 0; i < self.classifyModelsList.count; i++) {
        a[i] = 0;
    }
}
#pragma mark - 懒加载
- (NSArray *)classifyModelsList {
    if (_classifyModelsList == nil) {
        _classifyModelsList = [FoodClassifyModel classifyModelsList];
    }
    return _classifyModelsList;
}

- (NSMutableArray *)listDataArray {
    if (_listDataArray == nil) {
        _listDataArray = [NSMutableArray array];
    }
    return _listDataArray;
}
#pragma mark - 请求网络数据

- (void)getDataWithId:(NSString *)Id {
    [MBProgressHUD showMessage:@"加载中" toView:_listCollectionView];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"id":Id
                                 };
    [manager GET:API_FOOD_LIST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.listDataArray removeAllObjects];
        for (NSDictionary *dic in responseObject[@"tngou"]) {
            FoodListModel *model = [[FoodListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.listDataArray addObject:model];
        }
        [MBProgressHUD hideHUDForView:_listCollectionView];
        [_listCollectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:_listCollectionView];
        [MBProgressHUD showError:@"加载失败" toView:_listCollectionView];
    }];
}
#pragma mark - 创建collectionView
- (void)createListCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(4,4,4,4);
    
    _listCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_classifyTableView.frame), 0, SCREEN_WIDTH - CGRectGetWidth(_classifyTableView.frame), SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) collectionViewLayout:flowLayout];
    _listCollectionView.backgroundColor = [UIColor colorWithRed:255 / 255.0f green:252 / 255.0f blue:229 / 255.0f alpha:1];
    [self.view addSubview:_listCollectionView];
    _listCollectionView.dataSource = self;
    _listCollectionView.delegate = self;
    [_listCollectionView registerNib:[UINib nibWithNibName:@"FoodListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"listCell"];
}
#pragma mark - 创建tableView
- (void)createClassifyTableView {
    _classifyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_SCALE * 110, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
    _classifyTableView.delegate = self;
    _classifyTableView.dataSource = self;
    _classifyTableView.showsVerticalScrollIndicator = NO;
    _classifyTableView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_classifyTableView];
}

#pragma mark - tableView数据源和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.classifyModelsList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return a[section] ? [self.classifyModelsList[section] liteClassifys].count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"classifyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        backView.backgroundColor = [UIColor colorWithRed:255 / 255.0f green:252 / 255.0f blue:229 / 255.0f alpha:1];
        cell.selectedBackgroundView = backView;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    cell.textLabel.text = [[self.classifyModelsList[indexPath.section] liteClassifys][indexPath.row] name];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"1";
}
#pragma mark 自定义表格头视图方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerButton setTitle:[self.classifyModelsList[section] name] forState:UIControlStateNormal];
    headerButton.backgroundColor = [UIColor lightGrayColor];
    headerButton.tag = section + 200;
    [headerButton addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    headerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    return headerButton;
}
#pragma mark cell点击回调方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",[[_classifyModelsList[indexPath.section] liteClassifys][indexPath.row] ids]);
    [self checkNetWork:^{
        [self getDataWithId:[[_classifyModelsList[indexPath.section] liteClassifys][indexPath.row] ids]];
    }];
    
}
#pragma mark - 按钮点击事件
#pragma mark 表格头视图按钮点击事件 点击弹开 再次点击收起
- (void)headerButtonClick:(UIButton *)button {
    if (a[button.tag - 200]) {
        a[button.tag - 200] = 0;
        [_classifyTableView reloadData];
    }else {
        [self inita];
        a[button.tag - 200] = 1;
        [_classifyTableView reloadData];
        [_classifyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:button.tag - 200] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
#pragma mark - collectionView的数据源和代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FoodListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"listCell" forIndexPath:indexPath];
    cell.nameLabel.text = [self.listDataArray[indexPath.row] name];
    NSString *url = [NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",[self.listDataArray[indexPath.row] img]];
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:url]  placeholderImage:[UIImage imageNamed:@"zhanwei_h"]];
    cell.iconView.contentMode=UIViewContentModeScaleAspectFill;
    cell.iconView.clipsToBounds=YES;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((CGRectGetWidth(_listCollectionView.frame)-12.0f) / 2.0f, (CGRectGetWidth(_listCollectionView.frame)-12.0f) / 2.0f * 1.6);
}
#pragma mark 设置最小边距(配合layout.sectionInset使用)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4.0f;
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ShowDetailViewController *showVC = [[ShowDetailViewController alloc] init];
    FoodListModel *model = self.listDataArray[indexPath.row];
    showVC.pageId = model.id;
    showVC.otitle = model.name;
    showVC.otype = @"food";
    [self.navigationController pushViewController:showVC animated:YES];
    
}
@end










