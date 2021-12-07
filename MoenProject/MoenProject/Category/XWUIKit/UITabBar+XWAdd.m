//
//  UITabBar+badge.m
//  GoodsTalk
//
//  Created by Davis on 2018/4/28.
//  Copyright © 2018年 Davis. All rights reserved.
//

#import "UITabBar+XWAdd.h"
#define TabbarItemNums 4.0  //item 个数
@implementation UITabBar (XWAdd)
//显示小蓝点
- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小蓝点
    [self removeBadgeOnItemIndex:index];
    
    //新建小蓝点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 3;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小蓝点的位置
    float percentX = (index +0.7) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width) - 2;
    CGFloat y = ceilf(0.1 * tabFrame.size.height) + 5;
    badgeView.frame = CGRectMake(x, y, 6, 6);//圆形大小为10
    [self addSubview:badgeView];
}


//隐藏小蓝点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小蓝点
    [self removeBadgeOnItemIndex:index];
}


//移除小蓝点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}


@end
