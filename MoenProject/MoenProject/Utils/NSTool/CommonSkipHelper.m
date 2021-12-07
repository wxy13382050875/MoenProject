//
//  CommonSkipHelper.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/27.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CommonSkipHelper.h"
#import "UITabBarController+AddChildController.h"

@implementation CommonSkipHelper

+ (void)skipToHomeViewContrillerWithLoginSuccess
{
    AppDelegate *delegate = [NSTool appDelegate];
    UIWindow *keywindow = delegate.window;
    /*设置tabbarcontroller*/
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setupContentControllers];
    keywindow.rootViewController = tabBarController;
    [keywindow makeKeyAndVisible];
}

@end
