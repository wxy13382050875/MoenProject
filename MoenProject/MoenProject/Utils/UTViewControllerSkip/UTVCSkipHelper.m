//
//  UTVCSkipHelper.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/9.
//

#import "UTVCSkipHelper.h"
//#import "FinancingProductDetailVC.h"
//#import "LoginVC.h"
#import "GestureViewController.h"

@implementation UTVCSkipHelper

+ (void)pushWithUrlType:(UTSkipViewControllerType)controllerType withParameters:(NSDictionary *)parameters
{
    switch (controllerType) {
        case UTFinancingProductDetailVCType:
        {
//            FinancingProductDetailVC *financingProductDetailVC = [[FinancingProductDetailVC alloc] init];
//            financingProductDetailVC.title = @"理财详情";
//            financingProductDetailVC.productID = [parameters[@"PrimaryKey"] integerValue];
//            financingProductDetailVC.hidesBottomBarWhenPushed = YES;
//            UIViewController *currentController = [UIViewController currentViewController];
//            [currentController.navigationController pushViewController:financingProductDetailVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

+ (void)presentLoginVCWithLoginWays:(BOOL)isChangeLoginWay
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        LoginVC *login = [[LoginVC alloc] init];
//        login.controllerType = LoginVCType_login;
//        login.isChangeLoginWay = isChangeLoginWay;
//        [[UIViewController currentViewController] presentViewController:login animated:NO completion:nil];
    });
    
}

+ (void)presentGestureLoginVC
{
    dispatch_async(dispatch_get_main_queue(), ^{
        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        gestureVc.type = GestureViewControllerTypeLogin;
        UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:gestureVc];
        [[UIViewController currentViewController] presentViewController:rootNav animated:NO completion:nil];
    });
    
}


+ (BOOL)isLoginStatus
{
    if ([QZLUserConfig sharedInstance].isLoginIn ||
        [QZLUserConfig sharedInstance].isLogining) {
        return YES;
    }
    else
    {
        [QZLUserConfig sharedInstance].isLogining = YES;
        if ([QZLUserConfig sharedInstance].isGestureLoginIn) {
            [UTVCSkipHelper presentGestureLoginVC];
        }
        else
        {
            [UTVCSkipHelper presentLoginVCWithLoginWays:NO];
        }
        return NO;
    }
}

@end
