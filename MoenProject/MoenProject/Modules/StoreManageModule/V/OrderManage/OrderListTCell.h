//
//  OrderListTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/9.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderManageModel.h"
#import "xWStockOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderListTCell : UITableViewCell
@property(nonatomic,strong)Orderlist* model;

- (void)showDataWithOrderManageModel:(OrderManageModel *)model;

- (void)showDataWithOrderManageModelForReturnGoodsManage:(OrderManageModel *)model;

@end

NS_ASSUME_NONNULL_END
