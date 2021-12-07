//
//  CouponRecordDetailModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CouponRecordDetailModel.h"

@implementation CouponRecordDetailModel

@end

@implementation CouponRecordDetailListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"couponUsageRecordDetail" : [CouponRecordDetailModel class]};
}
@end
