//
//  ReturnGoodsCounterStatisticsTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/17.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReturnOrderCounterModel.h"
#import "ReturnOrderDetailModel.h"
#import "ReturnOrderInfoModel.h"


static NSString *KReturnGoodsCounterStatisticsTCell = @"ReturnGoodsCounterStatisticsTCell";
static CGFloat KReturnGoodsCounterStatisticsTCellH = 120;
NS_ASSUME_NONNULL_BEGIN

@interface ReturnGoodsCounterStatisticsTCell : UITableViewCell


- (void)showDataWithReturnOrderCounterModel:(ReturnOrderCounterModel *)model;

- (void)showDataWithReturnOrderDetailModel:(ReturnOrderDetailModel *)model;

- (void)showDataWithReturnOrderInfoModel:(ReturnOrderInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
