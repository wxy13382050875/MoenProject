//
//  OrderScreenSideslipView.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/27.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XwScreenModel.h"


typedef void(^KWOrderScreenSideslipViewActionBlock)(XwScreenModel *model, NSInteger type);


NS_ASSUME_NONNULL_BEGIN

@interface OrderScreenSideslipView : UIView

- (instancetype)initWithMarginTop:(CGFloat)marginTop;

- (void)showWithArray:(NSMutableArray *)dataArr WithActionBlock:(KWOrderScreenSideslipViewActionBlock)actionBlock;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
