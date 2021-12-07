//
//  CStatisticsNumberTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/6.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCStatisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CStatisticsNumberTCell : UITableViewCell

- (void)showDataWithSCStatisticsModel:(SCStatisticsListModel *)model;

- (void)showDataWithCountStr:(NSString *)count;

- (void)showDataWithCouponRecordCountStr:(NSString *)count;

@end

NS_ASSUME_NONNULL_END
