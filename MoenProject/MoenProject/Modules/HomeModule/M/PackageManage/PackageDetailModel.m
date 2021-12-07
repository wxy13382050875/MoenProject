//
//  PackageDetailModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/27.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "PackageDetailModel.h"

@implementation PackageDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [PromotionInfoModel class], @"productList" : [GoodsDetailModel class]};
}
@end

@implementation PackageListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"listData" : [PackageDetailModel class]};
}
@end

@implementation PromotionInfoModel

@end





