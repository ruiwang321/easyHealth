//
//  DrugViewController.m
//  easyHealthy
//
//  Created by 王睿 on 15/11/28.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "DrugViewController.h"

#import "ClassifyDrugModel.h"
#import "ClassifyDrugListModel.h"

#import "ClassifyDrugCell.h"
#import "ClassifyDrugHeightView.h"

#import "DrugListViewController.h"

#define itemHeight 40.0f
@interface DrugViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,buttonClickDelegate>
{
    //存放数据的数组
    NSMutableArray *_dataArray;
    //创建collectionView
    UICollectionView *_collectionView;
    //定义一个值判断组的状态
    int isOpen[30];
    NSInteger openSection;
}
@end

@implementation DrugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.navigationItem.titleView = [self setTitleColor:@"药品信息" withFrame:CGRectMake(0, 0, 100, 40)];
    _dataArray = [[NSMutableArray alloc] init];
    isOpen[0] = 0;
    openSection = 0;
    [self requestData];
    [self initCollectionView];
    
}

#pragma mark - 请求本地数据
- (void)requestData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Drug" ofType:@"plist"];
    for (NSDictionary *dict in [NSMutableArray arrayWithContentsOfFile:path]) {
       
        ClassifyDrugModel *drugModel = [[ClassifyDrugModel alloc] init];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        drugModel.name = dict[@"name"];
        
        for (NSDictionary  *dic in dict[@"liteClassify"]) {
            ClassifyDrugListModel *drugListModel = [[ClassifyDrugListModel alloc] init];
            [drugListModel setValuesForKeysWithDictionary:dic];
            [array addObject:drugListModel];
        }
        drugModel.lite = array;
        [_dataArray addObject:drugModel];
    }
}
#pragma mark - 创建collectionView
- (void)initCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 6)/2.0f,itemHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    
    //初始化collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) collectionViewLayout:flowLayout];
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //注册collectionView
    [_collectionView registerClass:[ClassifyDrugCell class] forCellWithReuseIdentifier:@"cellId"];
    //注册collectionView的组头
    [_collectionView registerClass:[ClassifyDrugHeightView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellHeight"];
    
}
#pragma mark - 实现collectionView的协议方法
//分组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataArray.count;
}
//每组个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  isOpen[section]?[_dataArray[section] lite].count:0;
}
//每个cell的复用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //复用cell
    ClassifyDrugCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    ClassifyDrugListModel *model = [_dataArray[indexPath.section] lite][indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.label.text = model.name;
    cell.label.textAlignment = NSTextAlignmentCenter;
    return cell;

}
//cellHeight的复用
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ClassifyDrugHeightView *cellHeightView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellHeight" forIndexPath:indexPath];
    
    [cellHeightView.button setTitle:[_dataArray[indexPath.section] name] forState:UIControlStateNormal];
    [cellHeightView.button setTitleColor:THEME_MAIN_COLOR forState:UIControlStateSelected];
    
    cellHeightView.button.tag = indexPath.section + 100;
    if (isOpen[indexPath.section]) {
        cellHeightView.button.selected = YES;
    }else {
        cellHeightView.button.selected = NO;
    }
    cellHeightView.delegate = self;
    return cellHeightView;
}
//组头高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, 50.0f);
}
//每个cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DrugListViewController *dlVC = [[DrugListViewController alloc] init];
    ClassifyDrugListModel *model = [_dataArray[indexPath.section] lite][indexPath.row];
    dlVC.listId = model.ids;
    dlVC.navTitle = model.name;
    [self.navigationController pushViewController:dlVC animated:YES];

}
#pragma mark 设置最小边距(配合layout.sectionInset使用)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0f;
}

#pragma mark - cell组头button的代理
- (void)buttonClicked:(UIButton *)button{
    
   
    if (isOpen[button.tag- 100]) {
        isOpen[button.tag- 100] = 0;
    }else {
        isOpen[openSection] = 0;
        isOpen[button.tag-100] = 1;
        openSection = button.tag-100;
    }
    
    [_collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
