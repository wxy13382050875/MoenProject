//
//  xw_NavBar.m
//  XW_Object
//
//  Created by 武新义 on 2019/11/19.
//  Copyright © 2019年 武新义. All rights reserved.
//

#import "xw_NavBar.h"

@implementation xw_NavBar


/*
*  设置全局的导航栏背景图片
*
*  @param globalImg 全局导航栏背景图片
*/
+ (void)setGlobalBackGroundImage: (UIImage *)globalImg {

    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:NSClassFromString(@"xw_NavigationController"), nil];
    [navBar setBackgroundImage:globalImg forBarMetrics:UIBarMetricsDefault];


}
/**
*  设置全局导航栏标题颜色
 *
 *  @param globalTextColor 全局导航栏标题颜色
 */
+ (void)setGlobalTextColor: (UIColor *)globalTextColor andFontSize: (CGFloat)fontSize  {
    
    if (globalTextColor == nil) {
        return;
    }
    if (fontSize < 6 || fontSize > 40) {
        fontSize = 16;
    }
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:NSClassFromString(@"xw_NavigationController"), nil];
    // 设置导航栏颜色
    NSDictionary *titleDic = @{
                               NSForegroundColorAttributeName: globalTextColor,
                               NSFontAttributeName: [UIFont systemFontOfSize:fontSize]
                               };
    [navBar setTitleTextAttributes:titleDic];
    
}
@end
