//
//  BaseViewController+CustomNav.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/8.
//

#import "BaseViewController+CustomNav.h"

#import <sys/sysctl.h>
#import <objc/runtime.h>

void swizzled_Method(Class class,SEL originalSelector,SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzeldMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didSwizzle = class_addMethod(class, originalSelector, method_getImplementation(swizzeldMethod), method_getTypeEncoding(swizzeldMethod));
    
    if (didSwizzle) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzeldMethod);
    }
}

@implementation BaseViewController (CustomNav)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // viewWillAppear -> setNavBar
        swizzled_Method([self class],@selector(viewWillAppear:),@selector(setNavBar:));
        // viewWillDisappear -> reSetNavBar
        swizzled_Method([self class],@selector(viewWillDisappear:), @selector(reSetNavBar:));
    });
}

#pragma mark - setNavBar
- (void)setNavBar:(BOOL)animated {
    [self setNavBar:animated];
    
//    if ([self isKindOfClass:NSClassFromString(@"FinancingViewController")]) {
//        //设置字体
//        [self.navigationController.navigationBar setTitleTextAttributes:
//         @{NSFontAttributeName:[UIFont fontWithName:@"PingFang HK" size:17.0f],
//           NSForegroundColorAttributeName:AppTitleWhiteColor}];
//        
//         [self.navigationController.navigationBar setBackgroundImage:[UIImage stretchableImageWithImageName:@"n_red_background"] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5) ]];
//    }
//    else
//    {
//        //设置字体
//        [self.navigationController.navigationBar setTitleTextAttributes:
//         @{NSFontAttributeName:[UIFont fontWithName:@"PingFang HK" size:17.0f],
//           NSForegroundColorAttributeName:AppNavTitleBlackColor}];
//        
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:AppTitleWhiteColor] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5) ]];
//       
//    }
//    
//    if ([self isKindOfClass:NSClassFromString(@"HomeViewController")] ||
//        [self isKindOfClass:NSClassFromString(@"MineViewController")]) {
//        [self.navigationController setNavigationBarHidden:YES animated:NO];
//        self.edgesForExtendedLayout = UIRectEdgeTop;
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }

    
    //隐藏导航栏 -- 透明
//    if ([self isKindOfClass:[UserCenterController class]]||
//        [self isKindOfClass:NSClassFromString(@"ShopDetailController")]||
//        [self isKindOfClass:NSClassFromString(@"HotViewController")]) {
//        [self.navigationController setNavigationBarHidden:YES animated:NO];
//        self.edgesForExtendedLayout = UIRectEdgeTop;
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5) ]];
//    }
//
//    //导航栏 -- 白色
//    if ([self isKindOfClass:[HXDLoginController class]]||
//        [self isKindOfClass:NSClassFromString(@"SettingsViewController")]||
//        [self isKindOfClass:NSClassFromString(@"HXDRegistController")]||
//        [self isKindOfClass:NSClassFromString(@"NewClassificationVC")] ||
//        [self isKindOfClass:NSClassFromString(@"HXDShoppingCarController")]) {
//
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5) ]];
//    }
//
//    if ([self isKindOfClass:NSClassFromString(@"HomePageViewController")]||
//        [self isKindOfClass:NSClassFromString(@"HotContainerController")]) {
//        //基础色
//        [self.navigationController.navigationBar setTitleTextAttributes:
//         @{NSFontAttributeName:[UIFont fontWithName:@"PingFang HK" size:17.0f],
//           NSForegroundColorAttributeName:[UIColor whiteColor]}];
//
//        //去除导航条变空后导航条留下的黑线
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:AppBgSauceRedColor renderSize:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5) ]];
//        //        [self.navigationController.navigationBar setBarTintColor:AppBgSauceRedColor];
//        //        self.navigationController.navigationBar.translucent = NO;
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    
    
    
    //    if ([self isKindOfClass:NSClassFromString(@"HXDShoppingCarController")]) {
    //
    //        [self.navigationController.navigationBar setTitleTextAttributes:
    //         @{NSFontAttributeName:[UIFont fontWithName:@"PingFang HK" size:17.0f],
    //
    //           NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //
    //        [self.navigationController.navigationBar setBarTintColor:AppBgSauceRedColor];
    //        self.navigationController.navigationBar.translucent = NO;
    //    }
    
    //    if ( [self isKindOfClass:NSClassFromString(@"ShopDetailController")]) {
    //        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
    //            self.edgesForExtendedLayout = UIRectEdgeNone;
    //        }
    //
    //        // 透明导航栏
    //        for (UIView *subview in self.navigationController.navigationBar.subviews) {
    //            if ([subview isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
    //                UIView *backgroundView = subview;
    //                backgroundView.hidden = YES;
    //                break;
    //            }
    //        }
    //
    //        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5) ]];
    //    }
    
}

#pragma mark - resetNavBar
- (void)reSetNavBar:(BOOL)animated {
    [self reSetNavBar:animated];
    
    if ([self isKindOfClass:NSClassFromString(@"FinancingViewController")]) {
        
    }
    else
    {
        
    }
    
    //恢复透明
//    if ([self isKindOfClass:[UserCenterController class]]||
//        [self isKindOfClass:NSClassFromString(@"ShopDetailController")]||
//        [self isKindOfClass:NSClassFromString(@"HotViewController")]) {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//
//        self.edgesForExtendedLayout = UIRectEdgeTop;
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    }
//
//    if ([self isKindOfClass:[HXDLoginController class]]) {
//
//        // 透明导航栏
//        for (UIView *subview in self.navigationController.navigationBar.subviews) {
//            if ([subview isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
//                UIView *backgroundView = subview;
//                backgroundView.hidden = NO;
//                break;
//            }
//        }
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5) ]];
//    }
//    if ([self isKindOfClass:NSClassFromString(@"HomePageViewController")]||
//        [self isKindOfClass:NSClassFromString(@"HotContainerController")]) {
//
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//        //        [self.navigationController.navigationBar setBarTintColor:AppBGWhiteColor];
//        //        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    }
    //    if ([self isKindOfClass:NSClassFromString(@"HXDShoppingCarController")]) {
    //
    //        [self.navigationController.navigationBar setTitleTextAttributes:
    //         @{NSFontAttributeName:[UIFont fontWithName:@"PingFang HK" size:17.0f],
    //
    //           NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //
    //        [self.navigationController.navigationBar setBarTintColor:AppBGWhiteColor];
    //        self.navigationController.navigationBar.translucent = NO;
    //    }
    
    
}



@end




