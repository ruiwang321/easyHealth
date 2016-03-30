//
//  SearchViewController.m
//  EasyHealth
//
//  Created by yanchao on 15/12/5.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTypeListModel.h"
#import "SearchResultModel.h"
#import "SearchResultTableViewCell.h"
#import "SearchResultViewController.h"

@interface SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    //搜索栏UIView
    UIView *_searchView;
    //搜索框背景图
    UIImageView *_searchImg;
    //搜索框
    UITextField *_searchField;
    //搜索框右侧按钮
    UIButton *_rightButton;
    
    //搜索显示的tableView
    UITableView *_tableView;
    
    //数组
    NSMutableArray *dataArray;
  
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    dataArray = [[NSMutableArray alloc] init];
    [self createSearch];
    _searchField.text = @"";
    //创建tableView
    [self createTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    _searchView.hidden = NO;
}

#pragma mark - 创建导航栏上的搜索框
- (void)createSearch {
    //取消导航栏上返回按钮
    [self.navigationItem setHidesBackButton:YES];
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, self.view.frame.size.width, 34)];
    [self.navigationController.navigationBar addSubview:_searchView];
    
    _searchImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-10-55, 34)];
    _searchImg.image = [[UIImage imageNamed:@"search"] stretchableImageWithLeftCapWidth:100 topCapHeight:38];
    
    _searchImg.userInteractionEnabled = YES;
    [_searchView addSubview:_searchImg];
    
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(50*SCREEN_SCALE, 0, CGRectGetWidth(_searchImg.frame)-40, 34)];
    _searchField.backgroundColor = [UIColor clearColor];
    _searchField.placeholder = @"食品、菜谱、药品、疾病";
    _searchField.delegate = self;
    _searchField.clearsOnBeginEditing = YES;
    _searchField.returnKeyType = UIReturnKeySearch;
    [_searchField becomeFirstResponder];
    _searchField.tintColor = [UIColor lightGrayColor];
    [_searchImg addSubview:_searchField];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(CGRectGetWidth(_searchImg.frame)+10, 0, _searchView.frame.size.width - CGRectGetWidth(_searchImg.frame)-10, 34);
    [_rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_searchView addSubview:_rightButton];
    
}

#pragma mark - 右侧取消按钮触发的方法
- (void)rightButtonClicked:(UIButton *)button {
    
    [_searchView removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self getTextRequestData];
    [textField resignFirstResponder];
    return YES;
}
////时刻监听textfield的值改变
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    [self getTextRequestData];
//    return YES;
//}

#pragma mark - 拿到搜索框中的文字请求数据
- (void)getTextRequestData {
    [self checkNetWork:^{
        [dataArray removeAllObjects];
        NSArray * typeNameArr = @[@"药品",@"疾病",@"菜谱",@"食品"];
        NSArray * typeIdentArr = @[@"drug",@"disease",@"cook",@"food"];

        for (int i=0; i<typeIdentArr.count; i++) {
            
            
            NSDictionary * paraDict = @{@"keyword"  :   _searchField.text,
                                        @"name"     :   typeIdentArr[i],
                                        @"rows"     :   @"1"};
            
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager GET:API_Search parameters:paraDict success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                SearchTypeListModel * model = [[SearchTypeListModel alloc] init];
                
                model.typeName = typeNameArr[i];
                model.typeIdentify = paraDict[@"name"];
                model.total = [[dict objectForKey:@"total"] integerValue];
                
                if (model.total>0) {
                    
                    [dataArray addObject:model];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_tableView reloadData];
                    });
                }
                
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
    }];


}

#pragma mark - 创建表格
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - tableView的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultTableViewCell" owner:self options:nil] lastObject];
    
    SearchTypeListModel *model = dataArray[indexPath.row];
    cell.typeName.text = [NSString stringWithFormat:@"%@相关",model.typeName];
    cell.total.text = [NSString stringWithFormat:@"约%ld条",model.total];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _searchView.hidden  = YES;

    SearchResultViewController * srvc = [[SearchResultViewController alloc] init];
    srvc.navigationItem.titleView = [self setTitleColor:[NSString stringWithFormat:@"%@相关",[dataArray[indexPath.row] typeName]] withFrame:CGRectMake(0, 0, 100, 40)];
    srvc.keyword = _searchField.text;
    srvc.typeIdentify = [dataArray[indexPath.row] typeIdentify];
    srvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:srvc animated:YES];

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
