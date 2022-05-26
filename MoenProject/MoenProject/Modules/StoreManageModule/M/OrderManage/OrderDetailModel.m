//
//  OrderDetailModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/7.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"codeStr":@"code"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderProductList" : [CommonProdutcModel class],@"orderSetMealList" : [CommonMealProdutcModel class],@"orderGiftProductList" : [CommonProdutcModel class],@"orderGiftSetMealList" : [CommonMealProdutcModel class],@"activityIndexList" : [XwActivityModel class]};
}
@end
