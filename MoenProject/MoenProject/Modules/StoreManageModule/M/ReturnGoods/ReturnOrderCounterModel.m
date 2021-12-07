//
//  ReturnOrderCounterModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/17.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "ReturnOrderCounterModel.h"
#import "CommonGoodsModel.h"

@implementation ReturnOrderCounterModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"productList" : [ReturnOrderCounterGoodsModel class],@"giftProductInfos" : [CommonProdutcModel class],@"giftOrderSetMealInfos" : [CommonMealProdutcModel class]};
}
@end

@implementation ReturnOrderCounterGoodsModel

@end
