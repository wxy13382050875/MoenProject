//
//  SamplingInputTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/6.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopPersonalModel.h"
#import "SCStatisticsModel.h"
#import "SamplingSingleModel.h"
#import "PatrolShopModel.h"
#import "CouponRecordModel.h"

typedef NS_ENUM(NSInteger, SamplingInputTCellType)
{
    SamplingInputTCellForInput = 0, //出样信息录入
    SamplingInputTCellForUsedRecord , //优惠券使用记录
    SamplingInputTCellForStoreStaff, //门店员工
    SamplingInputTCellForPatrolShop, //巡店查询
};

NS_ASSUME_NONNULL_BEGIN

@interface SamplingInputTCell : UITableViewCell

@property (nonatomic, assign) SamplingInputTCellType cellType;



- (void)showDataWithShopPersonalModel:(ShopPersonalModel *)model;


- (void)showDataWithSCStatisticsModel:(SCStatisticsModel *)model;



- (void)showDataWithSamplingSingleModel:(SamplingSingleModel *)model WithEditStatus:(BOOL)isEdit;



- (void)showDataWithPatrolShopModel:(PatrolShopModel *)model;


- (void)showDataWithCouponRecordModel:(CouponRecordModel *)model;

/**展示奖励统计每天的奖励数据*/
- (void)showDataWithAwardsMonthDataModel:(id)data;

/**展示奖励统计需求中的门店员工*/
- (void)showDataShopStaffModel:(id)data;
@end

NS_ASSUME_NONNULL_END
