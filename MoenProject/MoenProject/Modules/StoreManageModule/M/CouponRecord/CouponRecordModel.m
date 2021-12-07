//
//  CouponRecordModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CouponRecordModel.h"

@implementation CouponRecordModel

@end

@implementation CouponRecordListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderMonthDataList" : [CouponRecordModel class]};
}

@end
