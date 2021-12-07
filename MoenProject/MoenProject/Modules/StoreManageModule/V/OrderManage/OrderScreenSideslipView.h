//
//  OrderScreenSideslipView.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/27.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KWOSSVDataModel:MoenBaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *minValue;

@property (nonatomic, copy) NSString *maxValue;

@property (nonatomic, copy) NSString *itemId;

@property (nonatomic, assign) NSInteger statusValue;

@property (nonatomic, assign) BOOL isSelected;


@end

typedef void(^KWOrderScreenSideslipViewActionBlock)(KWOSSVDataModel *model, NSInteger type);


NS_ASSUME_NONNULL_BEGIN

@interface OrderScreenSideslipView : UIView

- (instancetype)initWithMarginTop:(CGFloat)marginTop;

- (void)showWithArray:(NSMutableArray *)dataArr WithActionBlock:(KWOrderScreenSideslipViewActionBlock)actionBlock;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
