//
//  SellGoodsOrderStatisticsTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesCounterDataModel.h"
#import "OrderDetailModel.h"

static NSString *KSellGoodsOrderStatisticsTCell = @"SellGoodsOrderStatisticsTCell";
static CGFloat KSellGoodsOrderStatisticsTCellH = 215;
NS_ASSUME_NONNULL_BEGIN

@interface SellGoodsOrderStatisticsTCell : SKSTableViewCell


- (void)showDataWithSalesCounterDataModel:(SalesCounterDataModel *)model WithGoodsCount:(NSInteger )goodsCount WithGiftGoodsCount:(NSInteger)giftGoodsCount;


- (void)showDataWithOrderDetailModel:(OrderDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
