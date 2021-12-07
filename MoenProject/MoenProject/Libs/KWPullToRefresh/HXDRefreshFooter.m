//
//  HXDRefreshFooter.m
//  HaoXiaDan_iOS_2.0
//
//  Created by Kevin Jin on 17/4/13.
//  Copyright © 2017年 JuPeng. All rights reserved.
//

#import "HXDRefreshFooter.h"
 /**刷新控件高度*/
#define kFooterHeight SCREEN_WIDTH/3.0f

/**自定义图片的高度*/
#define kFIconHeight 40

/**自定义图片的宽度*/
#define kFIconWidth 40

#define kFRoundTag 800

@interface HXDRefreshFooter ()
{
    NSInteger _roundCount;
}

@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UISwitch *s;
@property (weak, nonatomic) UIImageView *logo;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
//@property (nonatomic, strong) UIView *bgView;

@end

@implementation HXDRefreshFooter


- (void)prepare
{
    [super prepare];
    self.backgroundColor = [UIColor clearColor];
    // 设置控件的高度
    self.mj_h = kFooterHeight;
    
    // 添加显示label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromRGB(0x878787);
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    
    // 添加自定义logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:logo];
    self.logo = logo;
    NSMutableArray *headerImgs = [NSMutableArray array];
    for (NSInteger i = 1; i < 9; i ++) {
        NSString *imgName = [NSString stringWithFormat:@"refresh%ld",(long)i];
        [headerImgs addObject:[UIImage imageNamed:imgName]];
    }
    self.logo.animationDuration = 0.7f;
    self.logo.animationImages = headerImgs;
    
    
    /**背景图片*/
//    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.bgView.backgroundColor = [UIColor yellowColor];
//    self.bgView.backgroundColor = [UIColor hexColorFloat:@"ededef"];
//    [self insertSubview:self.bgView atIndex:0];
    
    
//    /**设置圆点*/
//    /**圆点半径*/
//    CGFloat roudW = 4;
//    //圆间距
//    CGFloat padding = 8.0f;
//    
//    /**第一个圆点的y轴位置*/
//    CGFloat baseY = kFooterHeight * 0.5 + kFIconHeight/2.0f + 6 + 11 + padding;
//    
//    _roundCount = (SCREEN_HEIGHT - kFooterHeight/2.0f - kFIconHeight/2.0f - 17 - padding) /(roudW + padding);
//    for (NSInteger i = 0; i < _roundCount; i ++) {
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f - roudW/2.0f, baseY + (roudW + padding)*i, roudW, roudW)];
//        label.backgroundColor  =[UIColor hexColorFloat:@"878787"];
//        label.layer.cornerRadius = roudW/2.0f;
//        label.clipsToBounds = YES;
//        label.tag = kFRoundTag + i;
//        [self addSubview:label];
//    }
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.logo.bounds = CGRectMake(0, 0, kFIconWidth, kFIconHeight);
    self.logo.center = CGPointMake(self.mj_w * 0.5 , self.mj_h * 0.5 - 15);
    self.label.frame = CGRectMake(0, CGRectGetMaxY(self.logo.frame) + 10.0f, SCREEN_WIDTH, 11);
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
            UILabel *round = [self viewWithTag:(kFRoundTag + i)];
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
            self.label.text = @"上拉可以加载更多";
//            MyLocal(MJRefreshBackFooterIdleText,nil);
            [self.logo stopAnimating];
            self.logo.image = [UIImage imageNamed:@"refresh1"];
            break;
        case MJRefreshStatePulling:
        {
            self.label.text = @"松开立即加载更多";
//            MyLocal(MJRefreshBackFooterPullingText,nil);
            [self.logo stopAnimating];
            self.logo.image = [UIImage imageNamed:@"refresh1"];
            for (NSInteger i = 0; i < _roundCount; i ++) {
                UILabel *round = [self viewWithTag:(kFRoundTag + i)];
                round.hidden = NO;
            }
        }
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"正在加载更多的数据...";
//            MyLocal(MJRefreshBackFooterRefreshingText,nil);
            [self.logo startAnimating];
            for (NSInteger i = 0; i < _roundCount; i ++) {
                UILabel *round = [self viewWithTag:(kFRoundTag + i)];
                round.hidden = YES;
            }
            
            
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"木有数据了";
            break;
        default:
            break;
    }
}
- (void)setPullingPercent:(CGFloat)pullingPercent{
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
        UILabel *round = [self viewWithTag:(kFRoundTag + i)];
        round.hidden = YES;
    }
}
@end
