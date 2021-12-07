//
//  HXDRefreshHeader.m
//  HaoXiaDan_iOS
//
//  Created by 鞠鹏 on 2017/1/17.
//  Copyright © 2017年 JuPeng. All rights reserved.
//

#import "HXDRefreshHeader.h"


#define kHeaderHeight 130
#define kIconHeight 80
#define kIconWidth 80
#define kRoundTag 600

@interface HXDRefreshHeader ()
{
    NSInteger _roundCount;
    BOOL _refreshed;
}
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UISwitch *s;
@property (weak, nonatomic) UIImageView *logo;
@property (weak, nonatomic) UIActivityIndicatorView *loading;

@property (nonatomic,strong) UIView *bgView;

@end

@implementation HXDRefreshHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    self.backgroundColor = UIColor.clearColor;
    // 设置控件的高度
    self.mj_h = kHeaderHeight;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromRGB(0x878787);
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = UIColor.clearColor;
    [self addSubview:label];
    self.label = label;
    
    // logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:logo];
    self.logo = logo;
    NSMutableArray *headerImgs = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i ++) {
        NSString *imgName = [NSString stringWithFormat:@"header%ld",(long)i];
        [headerImgs addObject:[UIImage imageNamed:imgName]];
    }
    self.logo.animationDuration =14*1/32.0f;
    self.logo.animationImages = headerImgs;
    
    
    

    /*
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0,- (SCREEN_HEIGHT - kHeaderHeight), SCREEN_WIDTH, SCREEN_HEIGHT )];
    self.bgView.backgroundColor = [UIColor hexColorFloat:@"ededef"];
    [self insertSubview:self.bgView atIndex:0];
    */
    /*
    
    CGFloat roudW = 4;
    //圆间距
    CGFloat padding = 8.0f;
    CGFloat baseY = kHeaderHeight * 0.5 - kIconHeight/2.0f - padding - roudW;
    _roundCount = SCREEN_HEIGHT /(roudW + padding);
    for (NSInteger i = 0; i < _roundCount; i ++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f - roudW/2.0f, baseY - (roudW + padding)*i, roudW, roudW)];
        label.backgroundColor  =[UIColor hexColorFloat:@"878787"];
        label.layer.cornerRadius = roudW/2.0f;
        label.clipsToBounds = YES;
        label.tag = kRoundTag + i;
        [self addSubview:label];
    }
     */
    // loading
//    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [self addSubview:loading];
//    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.logo.bounds = CGRectMake(0, 0, kIconWidth, kIconHeight);
    self.logo.center = CGPointMake(self.mj_w * 0.5 , 85);
    //挡住图片的字
    self.label.frame = CGRectMake(0, 10, SCREEN_WIDTH, 30);

    [self bringSubviewToFront:self.label];

}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];

    
    NSInteger newValue = [change[@"new"] integerValue];
    NSInteger oldValue = [change[@"old"] integerValue];
    //下拉
    if (newValue == 1 && oldValue == 0) {
        for (NSInteger i = 0; i < _roundCount; i ++) {
            UILabel *round = [self viewWithTag:(kRoundTag + i)];
            round.hidden = NO;
        }
    }
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            [self.s setOn:NO animated:YES];
            self.label.text = @"下拉刷新";
            [self.logo stopAnimating];
 
            self.logo.image = [UIImage imageNamed:@"header0"];
            
            break;
        case MJRefreshStatePulling:
        {
            [self.loading stopAnimating];
            [self.s setOn:YES animated:YES];
            self.label.text = @"松开刷新";
            [self.logo stopAnimating];
            self.logo.image = [UIImage imageNamed:@"header0"];
            for (NSInteger i = 0; i < _roundCount; i ++) {
                UILabel *round = [self viewWithTag:(kRoundTag + i)];
                round.hidden = NO;
            }
        }
            break;
        case MJRefreshStateRefreshing:
        {
            [self.s setOn:YES animated:YES];
            self.label.text = @"正在刷新";
            [self.loading startAnimating];
            for (NSInteger i = 0; i < _roundCount; i ++) {
                UILabel *round = [self viewWithTag:(kRoundTag + i)];
                round.hidden = YES;
            }

            [self.logo startAnimating];
        }
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    



}
// overide beginRefreshing

- (void)beginRefreshing{
    [super beginRefreshing];

}


// overide endrefreshing
- (void)endRefreshing{
    [super endRefreshing];
    for (NSInteger i = 0; i < _roundCount; i ++) {
        UILabel *round = [self viewWithTag:(kRoundTag + i)];
        round.hidden = YES;
    }
}



@end
