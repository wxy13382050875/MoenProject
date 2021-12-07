//
//  UITabBar+badge.h
//  GoodsTalk
//
//  Created by Davis on 2018/4/28.
//  Copyright © 2018年 Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (XWAdd)
- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
