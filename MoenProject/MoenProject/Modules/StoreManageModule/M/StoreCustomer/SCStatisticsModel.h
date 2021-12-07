//
//  SCStatisticsModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/28.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCStatisticsModel : MoenBaseModel

/**月份*/
@property (nonatomic, copy) NSString *month;

/**数量*/
@property (nonatomic, copy) NSString *num;

@end

@class SCStatisticsModel;
@interface SCStatisticsListModel : MoenBaseModel

/**总数*/
@property (nonatomic, assign) NSInteger totalAmount;

@property (nonatomic, strong) NSArray<SCStatisticsModel *> *coustomerList;
@end

NS_ASSUME_NONNULL_END
