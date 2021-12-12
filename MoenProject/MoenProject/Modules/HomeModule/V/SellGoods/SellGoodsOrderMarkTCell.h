//
//  SellGoodsOrderMarkTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesCounterConfigModel.h"
#import "ReturnOrderCounterModel.h"
#import "ReturnOrderDetailModel.h"
#import "ReturnOrderInfoModel.h"

typedef void(^OrderMarkBlock)(NSString* text);

static NSString *KSellGoodsOrderMarkTCell = @"SellGoodsOrderMarkTCell";
static CGFloat KSellGoodsOrderMarkTCellH = 80;


typedef NS_ENUM(NSInteger, SellGoodsOrderMarkTCellType)
{
    /**卖货柜台*/
    SellGoodsOrderMarkTCellTypeDefault = 0,
    /**退货柜台*/
    SellGoodsOrderMarkTCellTypeReturn,
    /**整单退货柜台*/
    SellGoodsOrderMarkTCellTypeReturnAll,
};
NS_ASSUME_NONNULL_BEGIN

@interface SellGoodsOrderMarkTCell : UITableViewCell
@property(nonatomic,strong)NSString* orderRemarks;

@property (nonatomic, copy) OrderMarkBlock orderMarkBlock;

- (void)showDataWithSalesCounterConfigModel:(SalesCounterConfigModel *)model;

- (void)showDataWithString:(NSString *)str;

- (void)showDataWithReturnOrderCounterModel:(ReturnOrderCounterModel *)model;

- (void)showDataWithReturnOrderDetailModel:(ReturnOrderDetailModel *)model;

- (void)showDataWithReturnOrderInfoModel:(ReturnOrderInfoModel *)model;
@end

NS_ASSUME_NONNULL_END
