//
//  ReturnGoodsAmountTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/25.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReturnOrderInfoModel.h"
#import "ReturnOrderCounterModel.h"

static NSString *KReturnGoodsAmountTCell = @"ReturnGoodsAmountTCell";
static NSString *KReturnGoodsAmountForMealTCell = @"ReturnGoodsAmountTCellForMeal";
static CGFloat KReturnGoodsAmountTCellH = 70;

typedef void(^ReturnGoodsAmountTCellBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface ReturnGoodsAmountTCell : UITableViewCell


- (void)showDataWithReturnOrderSingleGoodsModel:(ReturnOrderSingleGoodsModel *)model;

- (void)showDataWithReturnOrderMealGoodsModel:(ReturnOrderMealGoodsModel *)model;

- (void)showDataWithReturnOrderCounterGoodsModel:(ReturnOrderCounterGoodsModel *)model;

@property (nonatomic, copy) ReturnGoodsAmountTCellBlock completeBlock;

@end

NS_ASSUME_NONNULL_END
