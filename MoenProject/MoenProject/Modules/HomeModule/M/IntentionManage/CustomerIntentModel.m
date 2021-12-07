//
//  CustomerIntentModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/9.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "CustomerIntentModel.h"

@implementation CustomerIntentModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"productList" : [CustomerIntentGoodsModel class]};
}
@end

@implementation CustomerIntentListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"customerIntentList" : [CustomerIntentModel class]};
}
@end

@implementation CustomerIntentGoodsModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}
@end

