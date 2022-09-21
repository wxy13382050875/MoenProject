//
//  SalesCounterDataModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SalesCounterDataModel.h"

@implementation SalesCounterDataModel
@synthesize code = _code;//适用于所有特性的数据类
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"useCouponList" : [CouponInfoModel class],
             @"notUseCouponList" : [CouponInfoModel class],
             @"orderProductList" : [CommonGoodsModel class],
             @"orderGiftProductList" : [CommonGoodsModel class],
             @"orderSetMealList" : [CommonGoodsModel class],
             @"orderGiftSetMealList" : [CommonGoodsModel class]};
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"useCouponList" : @"CouponInfoModel",
             @"notUseCouponList":@"CouponInfoModel",
             @"orderProductList":@"CommonGoodsModel",
             @"orderGiftProductList":@"CommonGoodsModel",
             @"orderSetMealList":@"CommonGoodsModel",
             @"orderGiftSetMealList":@"CommonGoodsModel",
             };
}
@end
