//
//  KWTypeConditionSelectView.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/8.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^KWConditionSelectViewActionBlock)(NSInteger typeID, NSInteger atIndex);

typedef void(^KWTypeConditionSelectViewCancelBlock)(void);

@interface KWTypeConditionSelectView : UIView

- (instancetype)initWithMarginTop:(CGFloat)marginTop;

- (void)showWithArray:(NSMutableArray *)dataArr WithActionBlock:(KWConditionSelectViewActionBlock)actionBlock WithCancelBlock:(KWTypeConditionSelectViewCancelBlock)cancelBlock;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
