//
//  CounterAddressTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/20.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesCounterDataModel.h"
#import "OrderDetailModel.h"

static NSString *KCounterAddressTCell = @"CounterAddressTCell";
static CGFloat KCounterAddressTCellH = 65;

NS_ASSUME_NONNULL_BEGIN

@interface CounterAddressTCell : SKSTableViewCell


- (void)showDataWithSalesCounterDataModel:(SalesCounterDataModel *)model;


- (void)showDataWithOrderDetailModel:(OrderDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
