//
//  FeedbackViewController.m
//  HealthDrips
//
//  Created by Arom on 15-11-12.
//  Copyright (c) 2015年 UpTeam. All rights reserved.
//


#import <MessageUI/MessageUI.h>

#import "FeedbackViewController.h"
#import "HClTextView.h"
#import "Masonry.h"


@interface FeedbackViewController ()<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) HClTextView * textView;
@property (copy, nonatomic) NSString * myInPutText;
@property (copy,nonatomic) NSString * inputText;

@end

@implementation FeedbackViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [_textView becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.navigationController.navigationBarHidden = NO;
    [self viewSetting];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    /**
     *  修改导航栏title颜色以及字号
     */
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];

    
    }

- (void)viewSetting{

    HClTextView *textView = [[NSBundle mainBundle] loadNibNamed:@"HClTextView" owner:self options:nil].lastObject;
    //textView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:textView];
    self.textView = textView;
    
    textView.delegate = self;
    textView.clearButtonType = ClearButtonAppearWhenEditing;
    [textView setLeftTitleText:@"留言"];
    
    //Placeholder为空,则会显示:请输入您的"LeftTitleText的内容", "maxTextCount"字以内,Placeholder有值,则显示设置内容
    [textView setPlaceholder:nil contentText:_myInPutText maxTextCount:300];
    __weak typeof(self) weakSelf = self;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.equalTo(@(300));
        make.top.equalTo(weakSelf.view.mas_top).with.offset(0);
    }];
    
    NSLog(@"%@",_myInPutText);
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sender)];
    self.navigationItem.rightBarButtonItem = rightItem;

}

- (void)textViewDidChange:(UITextView *)textView
{
    self.inputText = textView.text;
}

- (void)sender{

    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            if (self.inputText.length == 0 || self.inputText.length >300) {
                
                [self alertWithTitle:nil msg:@"字数在0~300之间哟,亲~"];
                
            }else{
                
                [self displayComposerSheet];
            
            }
            
        }
        else
        {
            [self alertWithTitle:nil msg:@"系统不支持发送邮件"];
        }
    }
    else
    {
        [self alertWithTitle:nil msg:@"系统不支持发送邮件"];
    }
    
}

- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

//发送邮件
- (void)displayComposerSheet{
    
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject:@"反馈 健康点滴(HealthDrips)"];
    
    //添加发送者
    NSArray * toRecipients = [NSArray arrayWithObject:@"upteam@devhy.com"];
    [mailPicker setToRecipients:toRecipients];
    
    //设置发送邮件内容
    NSString * emailBody = self.inputText;
    
        [mailPicker setMessageBody:emailBody isHTML:NO];
        
        //邮件发送的邮件窗口
        [self presentModalViewController:mailPicker animated:YES];
    
}

//邮件发送完成调用的方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{

    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}
    




////运行系统邮箱
//- (void)launchMailAppOnDevice{
//
//    
//}

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
