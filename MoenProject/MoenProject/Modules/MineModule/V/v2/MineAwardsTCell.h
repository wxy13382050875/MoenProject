//
//  MineAwardsTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/11/15.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MineAwardsTCell : UITableViewCell

- (void)showDataWithRewardInfoModel:(id)data;

- (void)showDataWithAwardsStatisticsModel:(id)data;
@end

NS_ASSUME_NONNULL_END
