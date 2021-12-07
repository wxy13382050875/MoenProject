//
//  AppDelegate.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/26.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "AppDelegate.h"
#import "UITabBarController+AddChildController.h"
#import "WelcomeVC.h"
#import "LoginVC.h"
#import <Bugly/Bugly.h>
#import "CommonSkipHelper.h"
//#import "FPSDisplay.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Bugly startWithAppId:@"cd665b6a26"];
   
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.frame = [[UIScreen mainScreen] bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    WelcomeVC *welcomeController = [[WelcomeVC alloc] init];
    WEAKSELF
    welcomeController.completionBlock = ^(UIAlertController *alertController){
        //第一次登陆过了
        [QZLUserConfig sharedInstance].isFirstEnterIn = YES;
        [weakSelf setupNormalRootController];
        if (alertController) {
            [weakSelf.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
    };
    
    self.window.rootViewController = welcomeController;
    [self.window makeKeyAndVisible];
//    [FPSDisplay shareFPSDisplay];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -- Private Method

- (void)setupNormalRootController{    
    
    if ([QZLUserConfig sharedInstance].token.length) {
        [self setupUIAppearance];
        [CommonSkipHelper skipToHomeViewContrillerWithLoginSuccess];
    }
    else
    {
        [self setupUIAppearance];
        LoginVC *loginVC = [[LoginVC alloc] init];
        loginVC.controllerType = LoginVCType_login;
        loginVC.isFirstShow = YES;
        
        self.window.rootViewController = loginVC;
        [self.window makeKeyAndVisible];
    }
    
    
    
    
    
//    /*设置tabbarcontroller*/
//    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//    [tabBarController setupContentControllers];
//    [self setupUIAppearance];
//    self.window.rootViewController = tabBarController;
//    [self.window makeKeyAndVisible];
    
}

- (void)setupUIAppearance {
    
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#pragma clang diagnostic pop
    
    if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *navigationBarAppearance = [[UINavigationBarAppearance alloc]init];
            [navigationBarAppearance configureWithOpaqueBackground];
            [navigationBarAppearance setBackgroundImage:[UIImage imageWithRenderColor:UIColorFromRGB(0x5B7F95) renderSize:CGSizeMake(1, 0.5) ]];
            navigationBarAppearance.titleTextAttributes = @{NSFontAttributeName:FONTLanTingB(17)};
        [UINavigationBar appearance].scrollEdgeAppearance = navigationBarAppearance;
        [UINavigationBar appearance].standardAppearance = navigationBarAppearance;
    } else {
        [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x5B7F95)];
        [[UINavigationBar appearance] setShadowImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5) ]];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FONTLanTingB(17),NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
        [[UINavigationBar appearance] setTranslucent:NO];
        [[UITabBar appearance] setTranslucent:NO];
    }
    
    
    // tabBar Appearance
    //    [[UITabBar appearance] setShadowImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5)]];
    //    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)]];
    
    // separatorColor
    //    [[UITableView appearance] setBackgroundColor:[UIColor whiteColor]];
    //    [[UITableView appearance] setSeparatorColor:[UIColor hexColorFloat:@"e6e6e6"]];
    //
    //    // tabBar Colors
    //    UIColor *normalColor = [UIColor hexColorFloat:@"aeafb0"];
    //    UIColor *selectColor = AppBaseColor;
    //
    //    // tabBarItem Appearance
    //    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:normalColor} forState:UIControlStateNormal];
    //    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor} forState:UIControlStateSelected];
    //
    //    // navigationBar Appearance
    //    [[UINavigationBar appearance] setOpaque:YES];
    //    [[UINavigationBar appearance] setTranslucent:NO];
    //    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    //    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFang HK" size:17.0f],NSFontAttributeName,
    //
    //                                                          [UIColor blackColor],NSForegroundColorAttributeName,nil]];
}

@end
