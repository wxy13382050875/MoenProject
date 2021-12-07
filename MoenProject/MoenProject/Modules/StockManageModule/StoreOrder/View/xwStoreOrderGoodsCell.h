//
//  xwStoreOrderGoodsCell.h
//  MoenProject
//
//  Created by wuxinyi on 2021/9/2.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "SKSTableViewCell.h"
#import "NumberCalculate.h"
NS_ASSUME_NONNULL_BEGIN
static NSString *KXwStoreOrderGoodsCell = @"xwStoreOrderGoodsCell";
static CGFloat KXwStoreOrderGoodsCellH = 160;
typedef NS_ENUM(NSInteger,OrderActionType)
{
    OrderActionTypeOrder = 0,
    OrderActionTypeReturn
};
@interface xwStoreOrderGoodsCell : SKSTableViewCell
@property (nonatomic, assign) OrderActionType orderType;
@end

NS_ASSUME_NONNULL_END
