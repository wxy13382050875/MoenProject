//
//  AwardsStatisticsModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/11/16.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AwardsMonthDataModel;
@interface AwardsStatisticsModel : MoenBaseModel
/**本月摩恩奖励*/
@property (nonatomic, copy) NSString *moenReward;
/**本月经销商奖励*/
@property (nonatomic, copy) NSString *dealerReward;

/**当前月*/
@property (nonatomic, copy) NSString *currentYearMonth;

/***/
@property (nonatomic, strong) NSArray<AwardsMonthDataModel *>  *monthData;
@end


@interface AwardsMonthDataModel : MoenBaseModel
/**年月*/
@property (nonatomic, copy) NSString *month;
/**奖励金额*/
@property (nonatomic, copy) NSString *rewardAmount;
@end
NS_ASSUME_NONNULL_END
