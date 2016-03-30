//
//  GalleryViewController.m
//  easyHealthy
//
//  Created by 王睿 on 15/11/28.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "GalleryViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "ShowDetailViewController.h"
@interface GalleryViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    AVCaptureSession *_session;
    //扫描框
    UIView *_boxView;
    //扫描线
    CALayer *_scanLayer;
    //提示label
    UILabel *_label;
    //存放数据的数组
    NSMutableArray *dataArray;
}
@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = [self setTitleColor:@"条码扫描" withFrame:CGRectMake(0, 0, 100, 40)];
   
    
}
- (void)viewWillAppear:(BOOL)animated {
     [self star];
}

#pragma mark - 开启扫描
- (void)star{
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理，在主线程刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化连接对象
    _session = [[AVCaptureSession alloc] init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    
    //设置扫描支持的编码格式
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
    
    //实例化预览图层
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    
    //扫描框
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - SCREEN_WIDTH - 40 - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT, SCREEN_WIDTH - 40, SCREEN_WIDTH - 40)];
    _boxView.layer.borderColor = [UIColor greenColor].CGColor;
    _boxView.layer.borderWidth = 1.0f;
    [layer addSublayer:_boxView.layer];
    
    //设置扫描范围
    output.rectOfInterest = CGRectMake(0, 0, 1, 1);
    
    //扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 2);
    _scanLayer.backgroundColor = [UIColor greenColor].CGColor;
    
    [_boxView.layer addSublayer:_scanLayer];
    
    //提示label
    _label = [[UILabel alloc] initWithFrame:CGRectMake(_boxView.frame.origin.x, CGRectGetMaxY(_boxView.frame)+40.0f, CGRectGetWidth(_boxView.frame), 20)];
    _label.textColor = [UIColor whiteColor];
    _label.text = @"请将条形码置于取景器内扫描，尽量避免反光！";
    _label.font = [UIFont systemFontOfSize:13.0f];
    _label.textAlignment = NSTextAlignmentCenter;
    [layer addSublayer:_label.layer];
    
    
    //开启扫描
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    //开始扑捉
    [_session startRunning];

}

#pragma mark -协议方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects !=nil &&[metadataObjects count]>0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeEAN13Code]) {
            result = metadataObj.stringValue;
            
        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
            
        }
        
       
    }

}
#pragma mark - 扫描成功后调用的方法
- (void)reportScanResult:(NSString *)result {
    //扫描成功后的声音
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"bi" withExtension:@"mp3"];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    AudioServicesPlaySystemSound(soundID);
    
    [self stopReading];
    
    dataArray = [[NSMutableArray alloc] init];
    [self checkNetWork:^{
        [self requestData:result];
    }];
    
}


#pragma mark - 停止扫描
- (void)stopReading {

    [_session stopRunning];
    _session = nil;
}

#pragma mark - 扫描框中扫描线的动画
- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        
        frame.origin.y += 5;
        
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}
#pragma mark - 扫描完成请求数据
- (void)requestData:(NSString *)code{
    //显示加载框
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:API_DRUG_CODE parameters:@{@"code":code} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", jsonObj);
        //隐藏加载框
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([jsonObj count]<=2) {
            NSLog(@"没找到所要查询的数据");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",jsonObj[@"msg"]]message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }else {
            
            ShowDetailViewController *showVC = [[ShowDetailViewController alloc] init];
            showVC.pageId = jsonObj[@"id"];
            showVC.otype = @"drug";
            showVC.otitle = jsonObj[@"name"];
            [self.navigationController pushViewController:showVC animated:YES];
           
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //隐藏加载框
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}

#pragma mark - alertView的协议方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }

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
