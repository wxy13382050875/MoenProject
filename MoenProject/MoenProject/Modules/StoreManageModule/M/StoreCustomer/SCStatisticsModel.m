//
//  SCStatisticsModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/28.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SCStatisticsModel.h"

@implementation SCStatisticsModel

@end

@implementation SCStatisticsListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"coustomerList" : [SCStatisticsModel class]};
}
@end
