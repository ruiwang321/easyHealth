//
//  HomeHeaderScrollView.m
//  EasyHealth
//
//  Created by Kirito on 15/12/4.
//  Copyright © 2015年 easyHealthTeam. All rights reserved.
//

#import "HomeHeaderScrollView.h"
#import "HomeInfoModel.h"
#import "HomeShowViewController.h"
@interface HomeHeaderScrollView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *headerScrollView;
@end
@implementation HomeHeaderScrollView

-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSMutableArray * )_homeInfoArray withBlock:(void(^)(NSInteger))block  {
    self.buttonBlock=block;
    self=[super initWithFrame:frame];
    _headerScrollView=[[UIScrollView alloc]initWithFrame:frame];
    _headerScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*7, frame.size.height);
    _headerScrollView.bounces=NO;
    _headerScrollView.showsHorizontalScrollIndicator=NO;
    _headerScrollView.showsVerticalScrollIndicator=NO;
    _headerScrollView.pagingEnabled=YES;
    _headerScrollView.contentOffset=CGPointMake(SCREEN_WIDTH*2, 0);
    _headerScrollView.delegate=self;
    NSMutableArray * arr=[[NSMutableArray alloc]init];
    [arr addObject:_homeInfoArray[4]];
    for (int i =0 ; i<5; i++) {
        [arr addObject:_homeInfoArray[i]];
    }
    [arr addObject:_homeInfoArray[0]];
        for (int i = 0; i<7; i++) {
            UIImageView * bt =[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*(i), 0, SCREEN_WIDTH, frame.size.height)];
            HomeInfoModel *model=[[HomeInfoModel alloc]init];
            bt.userInteractionEnabled=YES;
            bt.contentMode=UIViewContentModeScaleAspectFill;
            bt.clipsToBounds=YES;
            model=arr[i];
            [bt sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",API_PIC,model.img]]placeholderImage:[UIImage imageNamed:@"zhanwei_h"]];
            UILabel *lb =[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*(i), frame.size.height-(35*SCREEN_SCALE), SCREEN_WIDTH, 35*SCREEN_SCALE)];
            UILabel *titlelb =[[UILabel alloc]initWithFrame:CGRectMake(8+SCREEN_WIDTH*(i), frame.size.height-(35*SCREEN_SCALE), SCREEN_WIDTH, 35*SCREEN_SCALE)];
            titlelb.numberOfLines=1;
            titlelb.text=model.title;
            titlelb.font=[UIFont systemFontOfSize:15*SCREEN_SCALE];
            lb.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.6];
            titlelb.textColor=[UIColor whiteColor];
            [_headerScrollView addSubview:bt];
            [_headerScrollView addSubview:lb];
            [_headerScrollView addSubview:titlelb];
            UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerClicked:)];
            bt.tag=100+i;
            [bt addGestureRecognizer:tap];
        }
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, frame.size.height-(35*SCREEN_SCALE), 60, (35*SCREEN_SCALE))];
    _pageControl.numberOfPages=5;
    _pageControl.currentPage=0;
    _pageControl.pageIndicatorTintColor=[UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor=THEME_MAIN_COLOR;
    [self addSubview:_headerScrollView];
    [self addSubview:_pageControl];
    //自动轮播
//     [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(nextPhoto) userInfo:nil repeats:YES];
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0f target:self selector:@selector(nextPhoto) userInfo:nil repeats:YES];
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    return self;
}
#pragma mark - 广告页图片的自动轮播
- (void)nextPhoto{
    
    [UIView animateWithDuration:0.5f animations:^{
        _headerScrollView.contentOffset = CGPointMake(self.frame.size.width + _headerScrollView.contentOffset.x, 0);
    }completion:^(BOOL finished) {
        
        if (_headerScrollView.contentOffset.x == 6 * self.frame.size.width) {
            //回到第2张
            _headerScrollView.contentOffset = CGPointMake(_headerScrollView.frame.size.width, 0);
        }
    }];
    _pageControl.currentPage=_headerScrollView.contentOffset.x/SCREEN_WIDTH-2;
    
}
//block回调
-(void)headerClicked:(UITapGestureRecognizer*)tap {
    if (self.buttonBlock) {
        self.buttonBlock(tap.view.tag);
    }
}
//协议方法、手动滚动完成修改页码指示器
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        _pageControl.currentPage=_headerScrollView.contentOffset.x/SCREEN_WIDTH-2;
        if (scrollView.contentOffset.x==0) {
            scrollView.contentOffset=CGPointMake(SCREEN_WIDTH*5, 0);
        }
        if (scrollView.contentOffset.x==SCREEN_WIDTH*6) {
            scrollView.contentOffset=CGPointMake(SCREEN_WIDTH, 0);
        }
}
@end
