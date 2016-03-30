//
//  UserDetailInfoViewController.m
//  EasyHealth
//
//  Created by 王睿 on 15/12/3.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "UserDetailInfoViewController.h"
#import "MeViewController.h"

@interface UserDetailInfoViewController () <UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
    UIImagePickerController *_imagePicker;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation UserDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTableView];
}

#pragma mark - 创建tableView
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    _tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.view addSubview:_tableView];
}

#pragma mark - 表格数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section ? 2 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserInfoModel *model = [AccountManager manager].userInfoModel;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    // 给cell添加详情label
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, SCREEN_WIDTH - 90, 44)];
    lb.textAlignment = NSTextAlignmentRight;
    lb.textColor = [UIColor grayColor];
    lb.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:lb];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 5, 80, 80)];
            [cell.contentView addSubview:iconView];
            [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_PIC,model.avatar]]];
            cell.textLabel.text = @"头像";
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"用户名";
            lb.text = model.account;
        }else if (indexPath.row == 2) {
            cell.textLabel.text = @"邮箱";
            lb.text = model.email;
        }
    }else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"性别";
            switch (model.gender.intValue) {
                case 0:
                    lb.text = @"女";
                    break;
                case 1:
                    lb.text = @"男";
                    break;
                case -1:
                    lb.text = @"保密";
                    break;
                    
                default:
                    break;
            }
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"个性签名";
            lb.text = ([model.signature isEqualToString:@""] || !model.signature) ? @"未填写" : model.signature;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 90;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark 表格cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 更换头像
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSLog(@"更换头像");
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选取头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [sheet showInView:self.view];
    }
}
#pragma mark UIActionSheet协议方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self initPickCameraPicker];
    }else if (buttonIndex == 1){
        [self initPicImagePicker];
    }
}

#pragma mark 调取系统相册
- (void)initPicImagePicker{
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  //数据来源，摄像头
    _imagePicker.allowsEditing = YES;//允许编辑
    _imagePicker.delegate = self;//设置代理，检测操作
    [self presentViewController:_imagePicker animated:YES completion:^{
        
    }];
}
#pragma mark 调取系统相机
- (void)initPickCameraPicker{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:^{
        
    }];//进入照相界面
    
}
#pragma mark UIImagePickerController协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    /*  
       Tnfs服务器 上传头像 http://www.tngou.net/tnfs/action/controller?action=uploadimage&path=avatar
     */
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(editedImage, 0.2f);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://www.tngou.net/tnfs/action/controller?action=uploadimage&path=avatar" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imageData name:@"head" fileName:@"head.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"state"]);
        if ([responseObject[@"state"] isEqualToString:@"SUCCESS"]) {
            NSString *imageUrl = responseObject[@"url"];
            NSDictionary *parameters = @{
                                         @"access_token":[AccountManager manager].access_token,
                                         @"url":imageUrl
                                         };
            [manager POST:
             @"http://www.tngou.net/api/user/portrait" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"%@",responseObject);
                 if (responseObject[@"msg"]) {
                     NSLog(@"%@",responseObject[@"msg"]);
                 }else {
                     NSLog(@"头像更换成功");
                     MeViewController *meVc = self.navigationController.viewControllers.firstObject;
                     [AccountManager manager].userInfoModel.avatar = responseObject[@"avatar"];
                     [_tableView reloadData];
                     [meVc updateHeadPhotoAndName];
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"error:%@",error);
             }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
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
