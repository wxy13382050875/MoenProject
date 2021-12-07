//
//  UIView+Awesome.m
//  ChatDemo-UI3.0
//
//  Created by Davis on 16/12/26.
//  Copyright © 2016年 Davis. All rights reserved.
//

#import "UIView+XWAdd.h"
#import <objc/runtime.h>
@implementation UIView (XWAdd)

/// 添加四边阴影效果
- (void)addShadowToView:(UIColor *)theColor {
    // 阴影颜色
    self.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    self.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    self.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    self.layer.shadowRadius = 5;
}


@end
