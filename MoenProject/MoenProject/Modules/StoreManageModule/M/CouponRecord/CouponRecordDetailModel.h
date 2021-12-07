//
//  CouponRecordDetailModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CouponRecordDetailModel : MoenBaseModel

@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *money;

@end

@class CouponRecordDetailModel;
@interface CouponRecordDetailListModel : MoenBaseModel

@property (nonatomic, strong) NSArray<CouponRecordDetailModel *> *couponUsageRecordDetail;

@end

NS_ASSUME_NONNULL_END
