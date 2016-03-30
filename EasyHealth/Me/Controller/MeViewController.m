//
//  MeViewController.m
//  easyHealthy
//
//  Created by 王睿 on 15/11/26.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "MeViewController.h"
#import "UIButton+WebCache.h"
#import "UserDetailInfoViewController.h"
#import "SaveListViewController.h"
#import "UserInfoModel.h"
#import "CleanManager.h"
#import "FeedbackViewController.h"
#import "ExonerateViewController.h"
#import "AboutUsViewController.h"

#define bkImageHeight 220
@interface MeViewController () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, UIAlertViewDelegate> {
    UIImageView *headerBg;
    UIVisualEffectView *visualEffectView;
    UIButton *_headerPhoto;
    UILabel *_nameLabel;
}
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MeViewController

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if ([_nameLabel.text isEqualToString:@"登录/注册"]) {
        [self updateHeadPhotoAndName];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createTableViewAndTableHeaderView];
}
#pragma mark - 更新头像和姓名信息
- (void)updateHeadPhotoAndName {
    // 判断是否登录 加载个人信息
    if ([AccountManager manager].isLogin) {
        UserInfoModel *model = [AccountManager manager].userInfoModel;
        _nameLabel.text = model.account;
        if (model.avatar == nil) {
            [_headerPhoto setBackgroundImage:[UIImage imageNamed:@"set_headphoto"] forState:UIControlStateNormal];
        }else {
            [_headerPhoto sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_PIC,model.avatar]] forState:UIControlStateNormal];
        }
        [_tableView reloadData];
    }
}

#pragma mark - 头像按钮点击事件
- (void)myHeadPhotoClick:(UIButton *)button {
    // 判断用户是否登录
    if ([AccountManager manager].isLogin) {
        UserDetailInfoViewController *userInfoVc = [[UserDetailInfoViewController alloc] init];
        // 隐藏tabbar
        userInfoVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userInfoVc animated:YES];
    }else {
         self.navigationController.navigationBarHidden=YES;
        [[AccountManager manager] presentLoginPageWithViewController:self success:^(UserInfoModel *model) {
            NSLog(@"---------------%@",model.account);
            _nameLabel.text = model.account;
            if (model.avatar == nil) {
                [_headerPhoto setBackgroundImage:[UIImage imageNamed:@"set_headphoto"] forState:UIControlStateNormal];
            }else {
                [_headerPhoto sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_PIC,model.avatar]] forState:UIControlStateNormal];
            }
            [_tableView reloadData];
        } fail:^(NSError *error) {
            
        }];
    }
}

#pragma mark - 创建表格和头视图
- (void)createTableViewAndTableHeaderView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT +20- TAB_BAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    headerBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    headerBg.frame = CGRectMake(0, 0, SCREEN_WIDTH, bkImageHeight);
    //空白头视图占位
    UIImageView * headerImage = [[UIImageView alloc]initWithFrame:headerBg.frame];
    _tableView.tableHeaderView = headerImage;
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = headerBg.bounds;
    [headerBg addSubview:visualEffectView];
    [_tableView addSubview:headerBg];
    _tableView.showsVerticalScrollIndicator = NO;
    
    _headerPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    _headerPhoto.frame = CGRectMake((SCREEN_WIDTH - 100) / 2, 70, 100, 100);
    _headerPhoto.layer.cornerRadius = _headerPhoto.frame.size.width / 2;
    _headerPhoto.layer.masksToBounds = YES;
    [_headerPhoto setBackgroundImage:[UIImage imageNamed:@"head_photo"] forState:UIControlStateNormal];
    [_headerPhoto addTarget:self action:@selector(myHeadPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerPhoto setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_tableView addSubview:_headerPhoto];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerPhoto.frame) + 10, SCREEN_WIDTH, 40)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = @"登录/注册";
    [_tableView addSubview:_nameLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 表格数据源和代理方法
//改变表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [AccountManager manager].isLogin ? 3 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text=@"我的收藏";
        }else if (indexPath.row == 1) {
            cell.textLabel.text=@"用户反馈";
        }else if (indexPath.row == 2) {
            cell.textLabel.text=@"清空缓存";
        }
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text=@"免责声明";
        }else if (indexPath.row == 1) {
            cell.textLabel.text=@"关于我们";
        }
    }else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text=@"退出登录";
        }
    }
    
    return cell;
}
#pragma mark 表格cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //取消cell默认选中效果 添加动画
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            //收藏
            if ([AccountManager manager].isLogin) {
                SaveListViewController *slVc = [[SaveListViewController alloc] init];
                slVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:slVc animated:YES];
            }else {
                UIAlertView *saveAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录,请登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
                saveAlert.tag = 199;
                [saveAlert show];
            }
        }else if (indexPath.row == 1) {
            //用户反馈
            self.hidesBottomBarWhenPushed = YES;
            FeedbackViewController * feedbackVc = [[FeedbackViewController alloc] init];
            feedbackVc.title = @"反馈";
            [self.navigationController pushViewController:feedbackVc animated:YES];
            
            self.hidesBottomBarWhenPushed = NO;
            self.navigationController.navigationBarHidden = NO;
        }else if (indexPath.row == 2) {
            //清除缓存
            [self cleanCache];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //免责声明
            ExonerateViewController * exonerateVc = [[ExonerateViewController alloc] init];
            exonerateVc.title = @"免责声明";
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:exonerateVc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            self.navigationController.navigationBarHidden = NO;
        }else {
            //关于我们
            AboutUsViewController * aboutVc = [[AboutUsViewController alloc] init];
            aboutVc.title = @"关于我们";
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutVc animated:YES];
            self.navigationController.navigationBarHidden = NO;
            self.hidesBottomBarWhenPushed = NO;
        }
        
    }else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            //退出登录
            UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
            logoutAlert.tag = 200;
            [logoutAlert show];
        }
    }
}
#pragma mark - UIAlertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //登录收藏
    if (alertView.tag == 199 && buttonIndex == 1) {
        [self myHeadPhotoClick:_headerPhoto];
    }
    //注销登录
    else if (alertView.tag == 200 && buttonIndex == 1) {
        [_headerPhoto setBackgroundImage:[UIImage imageNamed:@"head_photo"] forState:UIControlStateNormal];
        _nameLabel.text = @"登录/注册";
        [[AccountManager manager] logout];
        [_tableView reloadData];
    }
    //清除缓存
    else if (alertView.tag == 300 && buttonIndex == 1) {
        [CleanManager clearCache:[NSString stringWithFormat:@"%@/Library/Caches",NSHomeDirectory()]];
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Library/Caches",NSHomeDirectory()] withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark 表格滚动调用方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y+20;
//    NSLog(@"%lf",yOffset);
    if (yOffset < 0) {
        CGRect f = headerBg.frame;
        //保持图片原点仍为屏幕左上方
        f.origin.y = yOffset;
        //保证图片根据滑动高度拉伸
        f.size.height = bkImageHeight -yOffset;
        //给图片重新设置坐标
        headerBg.frame = f;
        visualEffectView.frame = headerBg.bounds;
    }
    
}
#pragma mark 清除缓存
- (void)cleanCache{
    
    float cacheSize = [CleanManager folderSizeAtPath:[NSString stringWithFormat:@"%@/Library/Caches",NSHomeDirectory()]];
    
    NSString * msg;
    NSString * btn1;
    NSString * btn2;
    if (cacheSize > 0.1 ) {
        msg = cacheSize>1 ? [NSString stringWithFormat:@"是否清理缓存(%.2lfMB)",cacheSize] : [NSString stringWithFormat:@"是否清理缓存(%.2lfKB)",cacheSize * 1024];
        btn1 = @"取消";
        btn2 = @"确定";
    }else{
        
        msg = @"垃圾已清理干净";
        btn1 = @"确定";
        btn2 = nil;
    }
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"缓存清理" message:msg delegate:self cancelButtonTitle:btn1 otherButtonTitles:btn2, nil];
    alertView.tag = 300;
    [alertView show];
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
