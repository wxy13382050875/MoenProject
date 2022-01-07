//
//  OrderManageModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/4.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "OrderManageModel.h"

@implementation OrderManageModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderItemInfos" : [OrderItemInfoModel class], @"productList" : [OrderItemInfoModel class], @"orderSetMealList" : [CommonGoodsModel class], @"orderProductList" : [CommonGoodsModel class]};
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end

@implementation OrderManageListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderList" : [OrderManageModel class], @"returnOrderList" : [OrderManageModel class]};
}
@end

@implementation OrderItemInfoModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"codeStr":@"code"};
}
@end
