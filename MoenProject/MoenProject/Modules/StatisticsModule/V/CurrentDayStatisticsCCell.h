//
//  CurrentDayStatisticsCCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/10.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurrentDayStatisticsCCell : UICollectionViewCell

- (void)showDataWithStatisticsTVModel:(StatisticsTVModel *)model;
@end

NS_ASSUME_NONNULL_END
