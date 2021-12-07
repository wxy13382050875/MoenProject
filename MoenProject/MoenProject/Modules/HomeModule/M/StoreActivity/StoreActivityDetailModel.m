//
//  StoreActivityDetailModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/20.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StoreActivityDetailModel.h"

@implementation StoreActivityListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"getPromoList" : [StoreActivityDetailModel class]};
}

@end

@implementation StoreActivityDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"comboPromo" : [StoreActivityMealModel class], @"couponPromo" : [StoreActivityCouponInfoModel class]};
}
@end

@implementation StoreActivityMealModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"products" : [StoreActivityMealProductsModel class]};
}
@end

@implementation StoreActivityMealProductsModel

@end


@implementation StoreActivityCouponInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"couponShops" : [StoreActivityShopInfo class]};
}

@end
@implementation StoreActivityShopInfo

@end



