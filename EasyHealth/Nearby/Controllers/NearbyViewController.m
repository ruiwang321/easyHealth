//
//  NearbyViewController.m
//  easyHealthy
//
//  Created by 王睿 on 15/11/26.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//
#import "NearbyViewController.h"

#import <MAMapKit/MAMapKit.h>

//周边医院相关
#import "NearbyHospitalPlaceModel.h"
#import "ShowDetailViewController.h"
#import "NearbyTableViewCell.h"
//周边药店相关
#import "NearbyMedecineShopModel.h"


#define navButtonFontSize 15.0f //导航栏上按钮的字体大小

@interface NearbyViewController ()<MAMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    //地图相关
    MAMapView *_mapView;
    
    //定义一个CLLocation,存放当前的定位信息
    CLLocation *Location;
    
    //定义一个存放周边医院的数组
    NSMutableArray *hospitalArray;
    //定义一个存放周边药店的数组
    NSMutableArray *medicineShopArray;
    
    //设置系统定位管理器
    CLLocationManager *_locationManager;
    
    //创建tableView
    UITableView * _mapTableView;
    
    //定义一个选择器判断选择了医院还是药店
    BOOL  isSelect;
    
}
@end

@implementation NearbyViewController
- (void)viewWillAppear:(BOOL)animated {
    //设置导航栏背景为白色
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //设置导航条titleView
    UISegmentedControl * segControl = [[UISegmentedControl alloc] initWithItems:@[@"附近医院",@"附近药店"]];
    segControl.selectedSegmentIndex = 0;
    [segControl addTarget:self action:@selector(segmentedClicked:) forControlEvents:UIControlEventValueChanged];
    segControl.tintColor = THEME_MAIN_COLOR;
    self.navigationItem.titleView = segControl;
    
    //设置导航条右按钮
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50.0f*SCREEN_SCALE, 40.0f*SCREEN_SCALE)];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:THEME_MAIN_COLOR forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:navButtonFontSize];
    [rightBtn setTitle:@"切换" forState:UIControlStateNormal];
    [rightBtn setTitle:@"返回" forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    

    //创建地图
    [self createMap];
    
    hospitalArray = [[NSMutableArray alloc] init];
    medicineShopArray = [[NSMutableArray alloc] init];
    isSelect = YES;
    //创建定位管理器
    [self createLocationManager];
    
}

#pragma mark - 导航栏上segement点击事件
- (void)segmentedClicked:(UISegmentedControl *)segementCon {
    NSInteger index = segementCon.selectedSegmentIndex;
    if (index == 1) {
        NSLog(@"附近药店被点击啦");
        isSelect = NO;
        [self removeCustomAnnotation];
        [hospitalArray removeAllObjects];
        [medicineShopArray removeAllObjects];
        //请求周边药店数据
        [self requestData:index];
        
    }else {
        NSLog(@"附近医院被点击啦");
        isSelect = YES;
        [self removeCustomAnnotation];
        [hospitalArray removeAllObjects];
        [medicineShopArray removeAllObjects];
        //请求周边医院数据
        [self requestData:index];
        
    }
}
#pragma mark 移除所用自定义大头针
-(void)removeCustomAnnotation{
    [_mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx!=0) {
            [_mapView removeAnnotation:obj];
        }
        
    }];
}
#pragma mark - 地图定位管理器
- (void)createLocationManager {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    CLLocationDistance dictance = 100.0f;
    _locationManager.distanceFilter = dictance;
    [_locationManager startUpdatingLocation];
    
}
//系统地图定位管理器的回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    Location = [locations firstObject];
   // NSLog(@"----------%f,%f",Location.coordinate.longitude,Location.coordinate.latitude);
    //第一次请求数据
    [self requestData:0];
    
}

#pragma mark - 地图显示
- (void)createMap{
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 30.0f)];
    _mapView.delegate = self;
    //打开定位
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.view addSubview:_mapView];
    
}
//定位回调
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        Location = userLocation.location;
    }
}

#pragma mark - 请求数据
- (void)requestData:(NSInteger)selectIndex {
    [self checkNetWork:^{
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary * nowLocationDict = @{
                                           
                                           @"x":[NSString stringWithFormat:@"%lf",Location.coordinate.longitude],
                                           @"y":[NSString stringWithFormat:@"%lf",Location.coordinate.latitude]
                                           };
        //请求周边医院数据
        if (selectIndex == 0) {
            
            [manager GET:API_HOSPITAL_LOCATION parameters:nowLocationDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            id locationJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
           // NSLog(@"%@",locationJson);
            NSArray * array = locationJson[@"tngou"];
            for (NSDictionary * hospitalDict in array) {
               NearbyHospitalPlaceModel * placeModel = [[NearbyHospitalPlaceModel alloc]init];
                [placeModel setValuesForKeysWithDictionary:hospitalDict];
                [hospitalArray addObject:placeModel];
            }
            //添加大头针
            [self addAnnotation];
            [_mapTableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            }];
        }
        
        //请求周边药店数据
        if (selectIndex == 1) {
            [manager GET:API_STORE_LOCATION parameters:nowLocationDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                id locationJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",locationJson);
                NSArray * array = locationJson[@"tngou"];
                for (NSDictionary * medecineShopDict in array) {
                    NearbyMedecineShopModel * shopModel = [[NearbyMedecineShopModel alloc] init];
                    [shopModel setValuesForKeysWithDictionary:medecineShopDict];
                    [medicineShopArray addObject:shopModel];
                }
                //添加大头针
                [self addAnnotation];
                [_mapTableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
    }];
}

#pragma mark - 点击导航栏右按钮触发的事件
- (void)rightBtnClick:(UIButton *)button {
    if (!_mapTableView) {
        _mapTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _mapTableView.showsHorizontalScrollIndicator = NO;
        _mapTableView.showsVerticalScrollIndicator = NO;
        _mapTableView.delegate = self;
        _mapTableView.dataSource = self;
        [self.view addSubview:_mapTableView];
    }
    button.selected = !button.selected;
    if (button.selected) {
        [self.view bringSubviewToFront:_mapTableView];
    }else {
        [self.view bringSubviewToFront:_mapView];
    }
    
}

#pragma mark - tableView的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSelect == YES) {
       return hospitalArray.count;
    }else {
        return medicineShopArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NearbyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NearbyTableViewCell" owner:self options:nil] lastObject];
    }
    if (isSelect == YES) {
        if (hospitalArray.count>0) {
            NearbyHospitalPlaceModel * model = hospitalArray[indexPath.row];
            [cell.hospitalImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",model.img]] placeholderImage:[UIImage imageNamed:@"showzhanwei"]];
            cell.hospitalName.text = model.name;
            cell.hospitalAddress.text = [NSString stringWithFormat:@"地址: %@", model.address];
            cell.hospitalMtype.text = [NSString stringWithFormat:@"性质: %@",model.mtype];
            cell.phoneNumber = model.tel;
        }
        
    }else {
        if (medicineShopArray.count>0) {
            NearbyMedecineShopModel * model = medicineShopArray[indexPath.row];
            [cell.hospitalImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",model.img]] placeholderImage:[UIImage imageNamed:@"showzhanwei"]];
            cell.hospitalName.text = model.name;
            cell.hospitalAddress.text = [NSString stringWithFormat:@"地址: %@", model.address];
            cell.hospitalMtype.text = [NSString stringWithFormat:@"性质: %@",model.type];
            cell.phoneNumber = model.tel;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_SCALE * 100.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     ShowDetailViewController * showVC = [[ShowDetailViewController alloc] init];
    if (isSelect == YES) {
        
        NearbyHospitalPlaceModel * model = hospitalArray[indexPath.row];
        showVC.pageId = model.id;
        showVC.otype = @"hospital";
        showVC.otitle = model.name;
        
    }else {
        
        NearbyMedecineShopModel * model = medicineShopArray[indexPath.row];
        showVC.pageId = model.id;
        showVC.otype = @"store";
        showVC.otitle = model.name;
    }
    showVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:showVC animated:YES];
}
#pragma mark -添加大头针的方法
- (void)addAnnotation {
    
    if (isSelect == YES) {
        NSMutableArray *annotationArr = [NSMutableArray array];
        for (NearbyHospitalPlaceModel * model in hospitalArray) {
            MAPointAnnotation * pointAnn = [[MAPointAnnotation alloc] init];
            pointAnn.coordinate = CLLocationCoordinate2DMake([model.y floatValue], [model.x floatValue]);
            pointAnn.title = model.name;
            pointAnn.subtitle = model.address;
            [annotationArr addObject:pointAnn];
        }
        [_mapView addAnnotations:annotationArr];
        [_mapView showAnnotations:annotationArr animated:YES];
    }else {
        NSMutableArray *annotationArr1 = [NSMutableArray array];
        for (NearbyMedecineShopModel * model in medicineShopArray) {
            MAPointAnnotation * pointAnn = [[MAPointAnnotation alloc] init];
            pointAnn.coordinate = CLLocationCoordinate2DMake([model.y floatValue], [model.x floatValue]);
            pointAnn.title = model.name;
            pointAnn.subtitle = model.address;
            [annotationArr1 addObject:pointAnn];
        }
        [_mapView addAnnotations:annotationArr1];
        [_mapView showAnnotations:annotationArr1 animated:YES];
    
    }
    
}

//实现大头针的协议回调
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout  = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.pinColor = MAPinAnnotationColorRed;
        return annotationView;
    }
    return nil;
}
//点击气泡右侧按钮触发的事件
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
     ShowDetailViewController * showVC = [[ShowDetailViewController alloc] init];
    if (isSelect == YES) {
        
        for (NearbyHospitalPlaceModel * model in hospitalArray) {
            if ([model.name isEqualToString:view.annotation.title]) {
               
                showVC.otype = @"hospital";
                showVC.otitle = model.name;
                showVC.pageId = model.id;
                
            }
        }
    }else {

        for (NearbyMedecineShopModel * model in medicineShopArray) {
            if ([model.name isEqualToString:view.annotation.title]) {
                
                showVC.otype = @"store";
                showVC.otitle = model.name;
                showVC.pageId = model.id;
            }
        }
    }
    showVC.hidesBottomBarWhenPushed = YES;
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
