//
//  xw_NavigationController.m
//  XW_Object
//
//  Created by 武新义 on 2019/11/19.
//  Copyright © 2019年 武新义. All rights reserved.
//

#import "xw_NavigationController.h"
#import "xw_NavBar.h"
@interface xw_NavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation xw_NavigationController



-(instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        [self setAppearance];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置手势代理
    UIGestureRecognizer *gester = self.interactivePopGestureRecognizer;
    //    gester.delegate = self;
    
    // 自定义手势
    // 手势加在谁身上, 手势执行谁的什么方法
    UIPanGestureRecognizer *panGester = [[UIPanGestureRecognizer alloc] initWithTarget:gester.delegate action:NSSelectorFromString(@"handleNavigationTransition:")];
    // 其实就是控制器的容器视图
    [gester.view addGestureRecognizer:panGester];
    
    gester.delaysTouchesBegan = YES;
    panGester.delegate = self;
    
    [self setAppearance];
}

- (void)back {
    
    if (self.presentingViewController != nil) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self popViewControllerAnimated:YES];
    }
    
}

- (void)setAppearance {
    
//     [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH, kNavBarAndStatusBarHeight) direction:XWChangeDirectionHorizontal startColor:COLOR(@"#12B8F6") endColor:COLOR(@"#1F7EFE")]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setBackgroundColor:[UIColor colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH, kNavBarAndStatusBarHeight) direction:XWChangeDirectionHorizontal startColor:COLOR(@"#12B8F6") endColor:COLOR(@"#1F7EFE")]];
//    [self.navigationBar xw_setBackgroundColor:[UIColor colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH, kNavBarAndStatusBarHeight) direction:XWChangeDirectionHorizontal startColor:COLOR(@"#12B8F6") endColor:COLOR(@"#1F7EFE")]];
    [self.navigationBar setBackgroundImage:[UIImage createImageWithSize:CGSizeMake(SCREEN_WIDTH, SCREEN_NavTop_Height) gradientColors:@[COLOR(@"#12B8F6"),COLOR(@"#1F7EFE")] gradientType:XWGradientFromLeftToRight] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationBar setBarTintColor:[UIColor clearColor]];

//    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:THEMECOLOR, NSForegroundColorAttributeName,nil]];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Light" size:17]}];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

 
//    [self.navigationBar xw_setBackgroundColor:[UIColor colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH, kNavBarAndStatusBarHeight) direction:FCGradientChangeDirectionHorizontal startColor:COLOR(@"#E42332") endColor:COLOR(@"#B10613")]];
//}
}
/**
 *  当控制器, 拿到导航控制器(需要是这个子类), 进行压栈时, 都会调用这个方法
 *
 *  @param viewController 要压栈的控制器
 *  @param animated       动画
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 拦截每一个push的控制器, 进行统一设置
    // 过滤第一个根控制器
    if (self.childViewControllers.count > 0) {
        //        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem customBackItemWithTarget:self action:@selector(back)];
        viewController.hidesBottomBarWhenPushed = YES;
        [self setBackItem:viewController];
        
        
    }
    
    // 千万不要忘记写
    [super pushViewController:viewController animated:animated];
    
}
- (void)setBackItem:(UIViewController *)vc {
    //设置后退的手势
    self.interactivePopGestureRecognizer.delegate = nil;
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    vc.navigationItem.leftBarButtonItem = back;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // 如果根控制器也要返回手势有效, 就会造成假死状态
    // 所以, 需要过滤根控制器
    if(self.childViewControllers.count == 1) {
        return NO;
    }
    
    return YES;
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
