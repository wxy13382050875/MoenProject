//
//  XiangQuToastManager.m
//  XiangQu
//
//  Created by yandi on 14/10/29.
//  Copyright (c) 2014年 yinchao. All rights reserved.
//

#import "MBProgressHUD.h"
#import "NSToastManager.h"
#import "AppDelegate.h"

#define minshowtime   .9
#define progesswidth  5.
#define rotationspeed 2
#define customcenter  CGPointMake(22.5, 22.5)

@interface NSToastManager () {
    
    MBProgressHUD *toastHud;
    MBProgressHUD *progressHud;
}
@end

@implementation NSToastManager
static NSToastManager *toastManager;

#pragma mark -manager
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toastManager = [[NSToastManager alloc] init];
        [toastManager actionRenderUIComponents];
    });
    return toastManager;
}

#pragma mark -keyWindow
+ (UIWindow *)keyWindow {
    AppDelegate *delegate = [NSTool appDelegate];
    UIWindow *keywindow = delegate.window;
    
    return keywindow;
}

#pragma mark -actionRenderUIComponents
- (void)actionRenderUIComponents {
    UIWindow *keywindow = [NSToastManager keyWindow];
    /**提示*/
    toastHud = [[MBProgressHUD alloc] initWithView:keywindow];
    toastHud.userInteractionEnabled = NO;
    toastHud.mode = MBProgressHUDModeText;
    toastHud.minShowTime = minshowtime*2;
    [keywindow addSubview:toastHud];
    
    /**转菊*/
    progressHud = [[MBProgressHUD alloc] initWithView:keywindow];
    progressHud.animationType = MBProgressHUDAnimationFade;
    progressHud.mode = MBProgressHUDModeCustomView;
    progressHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    progressHud.bezelView.color = UIColor.clearColor;
//    progressHud.backgroundView.backgroundColor = UIColor.clearColor;
    
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    NSMutableArray *gifImgArr = [[NSMutableArray alloc] init];
    for (int i = 1; i < 9; i++) {
        [gifImgArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"refresh%d",i]]];
    }
    gifImageView.animationImages = gifImgArr; //动画图片数组
    gifImageView.animationDuration = 0.8; //执行一次完整动画所需的时长
    gifImageView.animationRepeatCount = 0;  //动画重复次数
    [gifImageView startAnimating];
    progressHud.customView = gifImageView;
    progressHud.bounds = CGRectMake(0, 0, 32, 32);
    progressHud.minShowTime = minshowtime;
    progressHud.square = YES;
    progressHud.userInteractionEnabled = NO;
    [keywindow addSubview:progressHud];
}

#pragma mark -toast
- (void)showtoast:(NSString *)toastStr {
    [NSToastManager keyWindow].userInteractionEnabled = YES;

    [progressHud setHidden:YES];

    if (![NSTool isStringEmpty:toastStr]) {
        if (toastStr.length > 15) {
            toastHud.label.text = @"";
            toastHud.detailsLabel.text = toastStr;
        } else {
            toastHud.label.text = toastStr;
            toastHud.detailsLabel.text = @"";
        }
        
        [toastHud setHidden:NO];

        [[NSToastManager keyWindow] bringSubviewToFront:toastHud];
        [toastHud showAnimated:YES];
        [toastHud hideAnimated:YES];
    }
}

#pragma mark -progress
- (void)hideprogress {
    [NSToastManager keyWindow].userInteractionEnabled = YES;
    [progressHud hideAnimated:YES];
}

- (void)showprogress {

    [toastHud setHidden:YES];

    [[NSToastManager keyWindow] bringSubviewToFront:progressHud];
    [progressHud setHidden:NO];
    [progressHud hideAnimated:NO];
    [progressHud showAnimated:YES];
}

- (void)showmodalityprogress
{
    [toastHud setHidden:YES];
    
    [[NSToastManager keyWindow] bringSubviewToFront:progressHud];
    [NSToastManager keyWindow].userInteractionEnabled = NO;
    [progressHud setHidden:NO];
    [progressHud hideAnimated:NO];
    [progressHud showAnimated:YES];
}
@end
