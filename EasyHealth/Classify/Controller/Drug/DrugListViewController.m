//
//  DrugListViewController.m
//  EasyHealth
//
//  Created by yanchao on 15/12/4.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "DrugListViewController.h"

#import "ClassifyDrugShowModel.h"
#import "ClassifyDrugShowCell.h"
#import "ShowDetailViewController.h"
@interface DrugListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    //定义一个接受数据的数组
    NSMutableArray *_dataArray;
    //定义一个collectionView
    UICollectionView *_collectionView;
}
@end

@implementation DrugListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [self setTitleColor:_navTitle withFrame:CGRectMake(0, 0, 100, 40)];
   _dataArray = [[NSMutableArray alloc] init];
    [self createUI];
    [self checkNetWork:^{
        [self requestData]; 
    }];
}
#pragma mark - 请求数据
- (void)requestData {
    //显示加载框
    [MBProgressHUD showMessage:@"加载中" toView:_collectionView];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:API_DRUG_LIST  parameters:@{@"id":_listId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",jsonObj);
        
        NSArray *array = jsonObj[@"tngou"];
        
        for (NSDictionary *dict in array) {
            ClassifyDrugShowModel *showModel = [[ClassifyDrugShowModel alloc] init];
            [showModel setValuesForKeysWithDictionary:dict];
            
            [_dataArray addObject:showModel];
        }
        //隐藏加载框
        [MBProgressHUD hideHUDForView:_collectionView animated:YES];
        [_collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //隐藏加载框
        [MBProgressHUD hideHUDForView:_collectionView animated:YES];
        [MBProgressHUD showError:@"加载失败" toView:_collectionView];
    }];

}
#pragma mark - 创建界面
- (void)createUI {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((self.view.frame.size.width-2)/2.0f, 150.0f);
    flowLayout.minimumInteritemSpacing = 1.0f;
    flowLayout.minimumLineSpacing = 1.0f;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- STATUS_AND_NAVIGATION_HEIGHT) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [self.view addSubview:_collectionView];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //注册colectionView
    [_collectionView registerNib:[UINib nibWithNibName:@"ClassifyDrugShowCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
}

#pragma mark - collectionView的协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyDrugShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    ClassifyDrugShowModel *model = _dataArray[indexPath.row];
    [cell.showImg sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",model.img]] placeholderImage:[UIImage imageNamed:@"zhanwei_h"]];
    cell.name.text = model.name;
    cell.price.text = [NSString stringWithFormat:@"¥%.2lf",model.price];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyDrugShowModel *model = _dataArray[indexPath.row];
    ShowDetailViewController *showVC = [[ShowDetailViewController alloc] init];
    showVC.pageId = model.id;
    showVC.otitle = model.name;
    showVC.otype = @"drug";
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
