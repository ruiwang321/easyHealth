//
//  ShowDetailViewController.m
//  EasyHealth
//
//  Created by yanchao on 15/12/1.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "ShowDetailViewController.h"

#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"

#import "ShowDetailModel.h"
@interface ShowDetailViewController ()<MGTemplateEngineDelegate>
{
    //存放信息的数组
    NSMutableArray * MessageArray;
    //模板引擎
    MGTemplateEngine * _engine;
    //网页
    UIWebView * _webView;
    //请求的数据存放的model
    ShowDetailModel * _model;
    
    //定义一个path存放模板的地址
    NSString * moudlePath;
    
    //定义一个path存放不同界面api
    NSString * moudleApi;
}


@end

@implementation ShowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MessageArray = [[NSMutableArray alloc] init];
    [self initWebView];
    [self initMGTempEngine];
    [self reqestHospitalMessage];
    SaveAndShareModel *model = [[SaveAndShareModel alloc] init];
    model.id = _pageId;
    model.title = _otitle;
    model.type = _otype;
    [[AccountManager manager] addSaveAndShareBarToView:self.view withSaveAndShareModel:model];
}

#pragma mark - 初始化webView
- (void)initWebView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT + 9)];
    _webView.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - 初始化控制模板显示的工具并且获得模板地址
- (void) initMGTempEngine {
    _engine = [MGTemplateEngine templateEngine];
    _engine.delegate = self;
    [_engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:_engine]];
    
    moudlePath = [[NSString alloc] init];
    moudleApi = [[NSString alloc] init];
    
    NSArray * apiURLArr = @[API_HOSPITAL_SHOW,API_STORE_SHOW,API_DRUG_SHOW,API_COOK_SHOW,API_FOOD_SHOW,API_INFO_SHOW,API_LORE_SHOW,API_DISEASE_SHOW];
    
    NSArray * moudleNameArr = @[@"webMoudle_hospital",@"webMoudle_medecineShop",@"webMoudle_drug_cook_food",@"webMoudle_drug_cook_food",@"webMoudle_drug_cook_food",@"webMoudle_news",@"webMoudle_news",@"webMoudle_disease"];
    NSArray *array = @[@"hospital",@"store",@"drug",@"cook",@"food",@"news",@"lore",@"disease"];
    
    moudleApi = apiURLArr[[array indexOfObject:_otype]];
    moudlePath = [[NSBundle mainBundle] pathForResource:moudleNameArr[[array indexOfObject:_otype]] ofType:@"html"];
    
}

#pragma mark - 请求网上下载数据
- (void) reqestHospitalMessage {
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (![moudleApi isEqualToString:@""]) {
        
        [manager GET:moudleApi parameters:@{@"id":self.pageId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            id ShowObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            _model = [[ShowDetailModel alloc] init];
            [_model setValuesForKeysWithDictionary:ShowObj];
            [MessageArray addObject:_model];
            [self dealMould];
            
            [MBProgressHUD hideHUDForView:self.view];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"加载出错"];
        }];
    
    }
    
}
#pragma mark - 将下载完的数据通过model改变模板
- (void)dealMould {
    
    [_engine setObject:[API_PIC stringByAppendingPathComponent:_model.img] forKey:@"img"];
    [_engine setObject:@(SCREEN_WIDTH-100) forKey:@"picWidth"];
    [_engine setObject:@((SCREEN_WIDTH-100)/16*9) forKey:@"picHeight"];

    if ([self.otype isEqualToString:@"hospital"]) {
        
        [_engine setObject:_model.name ? _model.name : @"无信息展示" forKey:@"name"];
        [_engine setObject:_model.message ? _model.message : @"无信息展示" forKey:@"message"];
        [_engine setObject:_model.address ? _model.address : @"无信息展示" forKey:@"address"];
        [_engine setObject:_model.level ? _model.level : @"无信息展示" forKey:@"level"];
        [_engine setObject:_model.tel ? _model.tel : @"无信息展示" forKey:@"tel"];
    }else if([self.otype isEqualToString:@"store"]){
        
         [_engine setObject:_model.name ? _model.name : @"无信息展示" forKey:@"name"];
        [_engine setObject:_model.business ? _model.business : @"无信息展示" forKey:@"business"];
        [_engine setObject:_model.address ? _model.address : @"无信息展示" forKey:@"address"];
        [_engine setObject:_model.type ? _model.type : @"无信息展示" forKey:@"type"];
        [_engine setObject:_model.tel ? _model.tel : @"无信息展示" forKey:@"tel"];
        
    }else if([self.otype isEqualToString:@"drug"]||[self.otype isEqualToString:@"cook"]||[self.otype isEqualToString:@"food"]){
        
         [_engine setObject:_model.name ? _model.name : @"无信息展示" forKey:@"name"];
        [_engine setObject:_model.description ? _model.description : @"无信息展示" forKey:@"description"];
        [_engine setObject:_model.message ? _model.message : @"无信息展示" forKey:@"message"];
    }else if([self.otype isEqualToString:@"news"]||[self.otype isEqualToString:@"lore"]){
        
        [_engine setObject:_model.title ? _model.title : @"无信息展示" forKey:@"title"];
        [_engine setObject:@(SCREEN_WIDTH-16) forKey:@"newPicWidth"];
        [_engine setObject:@((SCREEN_WIDTH-16)) forKey:@"newPicHeight"];
        [_engine setObject:_model.description ? _model.description : @"无信息展示" forKey:@"description"];
        [_engine setObject:_model.message ? _model.message : @"无信息展示" forKey:@"message"];
    }else if ([self.otype isEqualToString:@"disease"]){
        [_engine setObject:_model.name forKey:@"name"];
        [_engine setObject:_model.description?_model.description:@"无信息展示" forKey:@"description"];
        [_engine setObject:_model.department?_model.department:@"无信息展示" forKey:@"department"];
        [_engine setObject:_model.causetext?_model.causetext:@"无信息展示" forKey:@"causetext"];
        [_engine setObject:_model.symptomtext?_model.symptomtext:@"无信息展示" forKey:@"symptomtext"];
        [_engine setObject:_model.foodtext?_model.foodtext:@"无信息展示" forKey:@"foodtext"];
        [_engine setObject:_model.drugtext?_model.drugtext:@"无信息展示" forKey:@"drugtext"];
        [_engine setObject:_model.checktext?_model.checktext:@"无信息展示" forKey:@"checktext"];
        
    }

    
    NSString * html = [_engine processTemplateInFileAtPath:moudlePath withVariables:nil];
    
    [_webView loadHTMLString:html baseURL:nil];
    [self.view addSubview:_webView];
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
