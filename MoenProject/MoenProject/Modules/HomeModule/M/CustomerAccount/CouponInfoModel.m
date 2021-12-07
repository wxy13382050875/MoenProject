//
//  CouponInfoModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CouponInfoModel.h"

@implementation CouponListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"couponList" : [CouponInfoModel class]};
}
@end

@implementation CouponInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"shopList" : [ShopInfo class]};
}
@end


@implementation ShopInfo

@end
