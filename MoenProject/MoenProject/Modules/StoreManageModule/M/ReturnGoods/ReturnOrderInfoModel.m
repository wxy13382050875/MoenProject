//
//  ReturnOrderInfoModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/17.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "ReturnOrderInfoModel.h"
#import "CommonGoodsModel.h"

@implementation ReturnOrderInfoModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id", @"orderCode":@"code"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"productList" : [ReturnOrderSingleGoodsModel class], @"setMealList" : [ReturnOrderMealGoodsModel class],@"giftProductInfos" : [CommonProdutcModel class], @"giftOrderSetMealInfos" : [CommonMealProdutcModel class]};
}
@end

@implementation ReturnOrderSingleGoodsModel

@end

@implementation ReturnOrderMealGoodsModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"mealCode":@"code"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"productList" : [ReturnOrderSingleGoodsModel class]};
}
@end
