//
//  ReturnGoodsCounterConfigTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/17.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReturnOrderCounterModel.h"
#import "ReturnOrderInfoModel.h"

typedef NS_ENUM(NSInteger, ReturnGoodsSelectType)
{
    ReturnGoodsSelectTypePickUp = 0,
    ReturnGoodsSelectTypeReturnType,
    ReturnGoodsSelectTypeReturnSeason,
};

typedef void(^ReturnGoodsCounterConfigTCellSelectBlock)(ReturnGoodsSelectType selectType);



static NSString *KReturnGoodsCounterConfigTCell = @"ReturnGoodsCounterConfigTCell";
static CGFloat KReturnGoodsCounterConfigTCellH = 123;

NS_ASSUME_NONNULL_BEGIN

@interface ReturnGoodsCounterConfigTCell : UITableViewCell

@property (nonatomic, copy) ReturnGoodsCounterConfigTCellSelectBlock configTCellSelectBlock;

- (void)showDataWithReturnOrderCounterModel:(ReturnOrderCounterModel *)model;

- (void)showDataWithReturnOrderInfoModel:(ReturnOrderInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
