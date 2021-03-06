//
//  UINavigationItem+ILAdditions.m
//  iLight
//
//  Created by chang qin on 15/9/4.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "UIButton+WebCache.h"
#import "UIButton+NSAdditions.h"
#import "UINavigationItem+NSAdditions.h"

@implementation UINavigationItem (NSAdditions)

- (UIButton *)actionCustomLeftBarButton:(NSString *)title
                               nrlImage:(NSString *)nrlImage
                               hltImage:(NSString *)hltImage
                                 action:(void(^)())actionBlock {
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom
                                       configure:^(UIButton *btn) {
                                           if ([UIImage imageNamed:nrlImage]) {
                                               [btn setImage:[UIImage imageNamed:nrlImage] forState:UIControlStateNormal];
                                           }
                                           if ([UIImage imageNamed:hltImage]) {
                                               [btn setImage:[UIImage imageNamed:hltImage] forState:UIControlStateHighlighted];
                                           }
                                           btn.titleLabel.numberOfLines = 2;
                                           btn.titleLabel.font = [UIFont systemFontOfSize:14];
                                           [btn setTitle:title forState:UIControlStateNormal];
                                           [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                           btn.frame = CGRectMake(-8, 0, 60, 44);
                                           btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                                       } action:^(UIButton *btn) {
                                           if (actionBlock) {
                                               actionBlock();
                                           }
                                       }];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;
    self.leftBarButtonItems = @[negativeSpacer,backBtn];
    
//    self.leftBarButtonItems = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    return leftBtn;
}

- (UIButton *)actionCustomRightBarButton:(NSString *)title
                                nrlImage:(NSString *)nrlImage
                                hltImage:(NSString *)hltImage
                                  action:(void(^)())actionBlock {
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom
                                        configure:^(UIButton *btn) {
                                            if ([UIImage imageNamed:nrlImage]) {
                                                [btn setImage:[UIImage imageNamed:nrlImage] forState:UIControlStateNormal];
                                            }
                                            if ([UIImage imageNamed:hltImage]) {
                                                [btn setImage:[UIImage imageNamed:hltImage] forState:UIControlStateHighlighted];
                                            }
                                            btn.titleLabel.font = [UIFont systemFontOfSize:15];
                                            [btn setTitle:title forState:UIControlStateNormal];
                                            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                            [btn setTitleColor:UIColorFromRGB(0xfca68d) forState:UIControlStateDisabled];
                                            [btn sizeToFit];
                                        } action:^(UIButton *btn) {
                                            if (actionBlock) {
                                                actionBlock();
                                            }
                                        }];
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    return rightBtn;
}


@end
