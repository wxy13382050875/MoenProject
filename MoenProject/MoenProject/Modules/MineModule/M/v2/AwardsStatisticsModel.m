//
//  AwardsStatisticsModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/11/16.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "AwardsStatisticsModel.h"

@implementation AwardsStatisticsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"monthData" : [AwardsMonthDataModel class]};
}
@end

@implementation AwardsMonthDataModel

@end


