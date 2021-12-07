//
//  UINavigationBar+BackgroundColor.h
//  XW_Object
//
//  Created by Benc Mai on 2019/11/22.
//  Copyright © 2019 武新义. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (XWAdd)
- (void)xw_setBackgroundColor:(UIColor *)backgroundColor;
/**
 * 动态给UINavigationBar添加属性，通过设置属性的值来实现导航条的透明雨渐变。
 */
- (void)xw_setElementsAlpha:(CGFloat)alpha;
- (void)xw_setTranslationY:(CGFloat)translationY;
- (void)xw_reset;
@end

NS_ASSUME_NONNULL_END
