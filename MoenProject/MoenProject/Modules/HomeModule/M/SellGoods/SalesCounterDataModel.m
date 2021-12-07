//
//  SalesCounterDataModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SalesCounterDataModel.h"

@implementation SalesCounterDataModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"useCouponList" : [CouponInfoModel class], @"notUseCouponList" : [CouponInfoModel class]};
}
@end
