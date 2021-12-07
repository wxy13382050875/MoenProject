//
//  UIButton+ClickDamping.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/3/13.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ClickDamping)
/**
 *  为按钮添加点击间隔 eventTimeInterval秒
 */
@property (nonatomic, assign) NSTimeInterval eventTimeInterval;

@end

NS_ASSUME_NONNULL_END
