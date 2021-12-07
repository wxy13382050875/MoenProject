
//  UIButton+ILAdditions.m
//  iLight
//
//  Created by chang qin on 15/9/4.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "UIButton+NSAdditions.h"
#import <objc/runtime.h>

@implementation UIButton (NSAdditions)
static char *UIButton_actionBlockKey;
static char *UIButton_acceptEventInstervalKey = "acceptEventInsterval";
static char *UIButton_ignoreEventKey = "ignoreEventKey";

+ (instancetype)buttonWithType:(UIButtonType)buttonType configure:(void(^)(UIButton *btn))configureBlock action:(void(^)(UIButton *btn))actionBlock {
    UIButton *btn = [UIButton buttonWithType:buttonType];
    if (configureBlock) {
        configureBlock(btn);
    }
    objc_setAssociatedObject(btn, &UIButton_actionBlockKey, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [btn addTarget:btn action:@selector(actionCallBlock:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}





#pragma mark - clickForce
- (void)clickForce{
    
    void (^actionBlock) (UIButton *btn) = objc_getAssociatedObject(self, &UIButton_actionBlockKey);
    if (actionBlock) {
        actionBlock(self);
    }
}

#pragma mark -actionCallBlock
- (void)actionCallBlock:(UIButton *)btn {
    void (^actionBlock) (UIButton *btn) = objc_getAssociatedObject(self, &UIButton_actionBlockKey);
    if (actionBlock) {
        actionBlock(btn);
    }
}
@end
