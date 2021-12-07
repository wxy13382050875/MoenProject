//
//  CouponRecordModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CouponRecordModel : MoenBaseModel

@property (nonatomic, copy) NSString *month;

@property (nonatomic, copy) NSString *numPrice;

@end


@class CouponRecordModel;
@interface CouponRecordListModel : MoenBaseModel


@property (nonatomic, copy) NSString *totalAmount;

@property (nonatomic, strong) NSArray<CouponRecordModel *> *orderMonthDataList;


@end

NS_ASSUME_NONNULL_END
