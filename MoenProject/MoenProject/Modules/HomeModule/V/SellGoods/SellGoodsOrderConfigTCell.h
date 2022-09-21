//
//  SellGoodsOrderConfigTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesCounterConfigModel.h"

typedef NS_ENUM(NSInteger, SelectType)
{
    SelectTypePickUp = 0,
    SelectTypeDelivery,
    SelectTypeReceivables,
    SelectTypeCoupon,
    SelectTypeStoreDiscount,
    SelectTypeOtherDiscount
};

typedef void(^SellGoodsOrderConfigTCellSelectBlock)(SelectType selectType);



static NSString *KSellGoodsOrderConfigTCell = @"SellGoodsOrderConfigTCell";
static CGFloat KSellGoodsOrderConfigTCellH = 339;
NS_ASSUME_NONNULL_BEGIN

@interface SellGoodsOrderConfigTCell : SKSTableViewCell



@property (nonatomic, copy) SellGoodsOrderConfigTCellSelectBlock orderConfigTCellSelectBlock;


- (void)showDataWithSalesCounterConfigModel:(SalesCounterConfigModel *)model WithUsableCount:(NSInteger)usableCount WithUnUsableCount:(NSInteger)unUsableCount WithCouponAmount:(NSString *)couponAmount;
@end

NS_ASSUME_NONNULL_END
