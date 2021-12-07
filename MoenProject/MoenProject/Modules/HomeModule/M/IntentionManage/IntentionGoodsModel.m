//
//  IntentionGoodsModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/10.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "IntentionGoodsModel.h"

@implementation IntentionListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"intentInfoList" : [IntentionGoodsModel class]};
}
@end

@implementation IntentionGoodsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"intentProductList" : [IntentionProductModel class],@"productList" : [IntentionProductModel class]};
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}
@end

@implementation IntentionProductModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}
@end
