//
//  DiseaseViewController.m
//  easyHealthy
//
//  Created by 王睿 on 15/11/28.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "DiseaseViewController.h"
#import "ClassifyDiseaseModel.h"
#import "ClassifyDiseaseListModel.h"
#import "DiseaseListViewController.h"
@interface DiseaseViewController ()<UITableViewDataSource , UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _dataArr;
    UIBarButtonItem * _switchFilter;
    BOOL placeType;
    //请求本地数据存放的地址
    NSString *path;
}


@end

@implementation DiseaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.navigationItem.titleView = [self setTitleColor:@"疾病(按部位)" withFrame:CGRectMake(0, 0, 100, 40)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataArr = [[NSMutableArray alloc] init];
    placeType = YES;
    [self loadDataFormPlist:placeType];
    
    [self creatUI];

}

#pragma mark - 从本地plist中加载数据
- (void)loadDataFormPlist:(BOOL)type{
    if (type == YES) {
        
        //请求本地Place.plist
        [_dataArr removeAllObjects];
        path = [[NSBundle mainBundle] pathForResource:@"Place" ofType:@"plist"];

    }else {
        
        //请求本地Department.plist
        path = [[NSBundle mainBundle] pathForResource:@"Department" ofType:@"plist"];
        [_dataArr removeAllObjects];
        
    }
   
    for (NSDictionary *dict in [NSMutableArray arrayWithContentsOfFile:path]) {
        
        ClassifyDiseaseModel *diseaseModel = [[ClassifyDiseaseModel alloc] init];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        diseaseModel.name = dict[@"name"];
        
        for (NSDictionary  *dic in dict[@"liteClassify"]) {
            ClassifyDiseaseListModel *diseaseListModel = [[ClassifyDiseaseListModel alloc] init];
            [diseaseListModel setValuesForKeysWithDictionary:dic];
            [array addObject:diseaseListModel];
        }
        diseaseModel.lite = array;
        [_dataArr addObject:diseaseModel];
    }
    [_tableView reloadData];
}
#pragma mark - 创建UI
- (void)creatUI{
    
    //NavBar右上角
    _switchFilter = [[UIBarButtonItem alloc] initWithTitle:@"切换模式" style:UIBarButtonItemStyleDone target:self action:@selector(switchFilter)];
    self.navigationItem.rightBarButtonItem = _switchFilter;
    
    //tableView搭建
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}
#pragma mark 切换分类模式
- (void)switchFilter{
    
    //切换
    if (placeType == YES) {
        
        self.navigationItem.titleView = [self setTitleColor:@"疾病(按科室)" withFrame:CGRectMake(0, 0, 100, 40)];
        placeType = NO;
    }else{
        
        self.navigationItem.titleView = [self setTitleColor:@"疾病(按部位)" withFrame:CGRectMake(0, 0, 100, 40)];
        placeType = YES;
    }
    
    //刷新数据
    [self loadDataFormPlist:placeType];
}
#pragma mark - 协议方法
#pragma mark 分组个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArr.count;
}
#pragma mark 每组cell数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArr[section] lite].count;
}
#pragma mark 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    //将cell右侧按钮设为小箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [[_dataArr[indexPath.section] lite][indexPath.row] name];
    
    return cell;
}

#pragma mark 设置头尾视图
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    UILabel * label = [[UILabel alloc] initWithFrame:view.bounds];
    label.textColor = [UIColor blackColor];
    
    label.text = [_dataArr[section] name];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    return view;
}
//cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DiseaseListViewController * lVc = [[DiseaseListViewController alloc] init];
    lVc.navigationItem.titleView = [self setTitleColor:[[_dataArr[indexPath.section] lite][indexPath.row] name] withFrame:CGRectMake(0, 0, 100, 40)];
    lVc.ids = [[_dataArr[indexPath.section] lite][indexPath.row] ids];
    lVc.type = placeType;
    [self.navigationController pushViewController:lVc animated:YES];
    

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
