//
//  HomeShowViewController.m
//  easyHealthy
//
//  Created by Kirito on 15/11/29.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "HomeShowViewController.h"
#import "HomeShowModel.h"

@interface HomeShowViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) HomeShowModel *model;
@property (nonatomic, strong) UITableView *homeShowTB;
@end
@implementation HomeShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadingData];
    [self createUI];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}


#pragma mark - 搭建界面
- (void)createUI {
    
    _homeShowTB = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _homeShowTB.delegate=self;
    _homeShowTB.dataSource=self;
    _homeShowTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: _homeShowTB];
}


#pragma mark -TB协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    (indexPath.section==0)?(cell.textLabel.text=_model.title):(cell.textLabel.text=_model.message);
    (indexPath.section==0)?(cell.textLabel.font=[UIFont systemFontOfSize:30*SCREEN_SCALE]):(cell.textLabel.font=[UIFont systemFontOfSize:17*SCREEN_SCALE]);
    cell.textLabel.numberOfLines=0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //第一个cell返回标题
    if (indexPath.section==0) {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:30*SCREEN_SCALE]};
        CGSize labelsize=[_model.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        return labelsize.height;
    }else {
        //第二个cell返回内容
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17*SCREEN_SCALE]};
        CGSize labelsize=[_model.message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        return labelsize.height;
    }
}


#pragma mark -网络请求
- (void)loadingData {
    NSLog(@"准备加载展示页面数据");
    _model=[[HomeShowModel alloc]init];
    NSString *url=[[NSString alloc]init];
    if (_isInfo) {
        url=API_INFO_SHOW;
    }else {
        url=API_LORE_SHOW;
    }
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:@{@"id":_showid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonObj=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [_model setValuesForKeysWithDictionary:jsonObj];
        [_homeShowTB reloadData];
        NSLog(@"展示页面数据加载成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"加载出错:%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController.navigationBar setBarTintColor:THEME_MAIN_COLOR];
     NSLog(@"展示页面跳转完成");
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
