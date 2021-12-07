//
//  AwardsDetailModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/11/16.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AwardsDetailItemModel;
@interface AwardsDetailModel : MoenBaseModel
/***/
@property (nonatomic, strong) NSArray<AwardsDetailItemModel *>  *rewardList;
@end

@interface AwardsDetailItemModel : MoenBaseModel
/**奖励时间*/
@property (nonatomic, copy) NSString *rewardDate;
/**奖励类型：摩恩奖励、经销商奖励*/
@property (nonatomic, copy) NSString *rewardType;
/**订单编号*/
@property (nonatomic, copy) NSString *orderCode;
/**商品、套餐编号*/
@property (nonatomic, copy) NSString *productCode;
/**奖励金额*/
@property (nonatomic, copy) NSString *rewardAmount;

@end

NS_ASSUME_NONNULL_END
