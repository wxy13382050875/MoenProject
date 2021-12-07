//
//  xw_NavBar.h
//  XW_Object
//
//  Created by 武新义 on 2019/11/19.
//  Copyright © 2019年 武新义. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xw_NavBar : UINavigationBar
/**
 *  设置全局的导航栏背景图片
 *
 *  @param globalImg 全局导航栏背景图片
 */
+ (void)setGlobalBackGroundImage: (UIImage *)globalImg;
/**
 *  设置全局导航栏标题颜色, 和文字大小
 *
 *  @param globalTextColor 全局导航栏标题颜色
 *  @param fontSize        全局导航栏文字大小
 */
+ (void)setGlobalTextColor: (UIColor *)globalTextColor andFontSize: (CGFloat)fontSize;

@end
