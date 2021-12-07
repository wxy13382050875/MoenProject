//
//  OrderHeaderTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/7.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"
#import "ReturnOrderInfoModel.h"
#import "ReturnOrderDetailModel.h"
#import "XwOrderDetailModel.h"
static NSString *KOrderHeaderTCell = @"OrderHeaderTCell";
static CGFloat KOrderHeaderTCellHeight = 87;

NS_ASSUME_NONNULL_BEGIN

@interface OrderHeaderTCell : SKSTableViewCell

@property(nonatomic,strong)XwOrderDetailModel* model;
/**订单详情*/
- (void)showDataWithOrderDetailModel:(OrderDetailModel *)model;


/**退货单 商品选择*/
- (void)showDataWithReturnOrderInfoModel:(ReturnOrderInfoModel *)model;

/**退货单详情*/
- (void)showDataWithReturnOrderDetailModel:(ReturnOrderDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
