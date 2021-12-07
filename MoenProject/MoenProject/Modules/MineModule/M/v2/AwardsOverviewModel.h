//
//  AwardsOverviewModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/11/16.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RewardInfoModel;
@interface AwardsOverviewModel : MoenBaseModel
/**html*/
@property (nonatomic, strong) RewardInfoModel *rewardInfo;
/**html*/
//@property (nonatomic, copy) NSString *html;
@end


@interface RewardInfoModel : MoenBaseModel
/**累计奖励*/
@property (nonatomic, copy) NSString *totalReward;
/**本月奖励*/
@property (nonatomic, copy) NSString *monthReward;

/**是否隐藏显示*/
@property (nonatomic, assign) BOOL isHidden;
@end

NS_ASSUME_NONNULL_END
